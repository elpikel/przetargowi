defmodule Przetargowi.DocumentParser do
  @moduledoc """
  Extracts fillable fields from .doc and .docx tender documents.

  Polish tender documents (załączniki do SWZ) use .doc or .docx format
  and contain fill-in-the-blank fields indicated by:
  - Sequences of dots: "…………………………………" or ".................."
  - Sequences of underscores: "________________"
  - Placeholder text in brackets: "[nazwa wykonawcy]", "[adres]"
  - Checkboxes: "☐" or "□"
  """

  @doc """
  Converts a .doc file to .docx using LibreOffice headless mode.

  Returns {:ok, docx_path} or {:error, reason}.
  """
  def convert_doc_to_docx(doc_path) do
    outdir = Path.dirname(doc_path)
    basename = Path.basename(doc_path, ".doc")
    expected_output = Path.join(outdir, "#{basename}.docx")

    case System.find_executable("soffice") do
      nil ->
        {:error, :soffice_not_installed}

      soffice_path ->
        args = ["--headless", "--convert-to", "docx", "--outdir", outdir, doc_path]

        case System.cmd(soffice_path, args, stderr_to_stdout: true) do
          {_output, 0} ->
            if File.exists?(expected_output) do
              {:ok, expected_output}
            else
              {:error, :conversion_failed}
            end

          {output, _code} ->
            {:error, {:soffice_error, output}}
        end
    end
  end

  @doc """
  Extracts full text content from a .docx file.

  Returns the text content as a string with paragraph breaks as \\n.
  """
  def extract_text(docx_path) do
    case extract_paragraphs(docx_path) do
      {:ok, paragraphs} ->
        text =
          paragraphs
          |> Enum.map(& &1.text)
          |> Enum.join("\n")

        {:ok, text}

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Extracts paragraphs from a .docx file with style information.

  Returns {:ok, paragraphs} where each paragraph is:
  %{index: integer, text: string, style: string | nil}
  """
  def extract_paragraphs(docx_path) do
    with {:ok, zip_handle} <- open_docx(docx_path),
         {:ok, document_xml} <- read_document_xml(zip_handle),
         :ok <- close_zip(zip_handle) do
      paragraphs = parse_document_xml(document_xml)
      {:ok, paragraphs}
    end
  end

  defp open_docx(path) do
    case :zip.zip_open(String.to_charlist(path), [:memory]) do
      {:ok, handle} -> {:ok, handle}
      {:error, reason} -> {:error, {:zip_open_failed, reason}}
    end
  end

  defp read_document_xml(zip_handle) do
    case :zip.zip_get(~c"word/document.xml", zip_handle) do
      {:ok, {~c"word/document.xml", content}} ->
        {:ok, content}

      {:error, reason} ->
        {:error, {:document_xml_not_found, reason}}
    end
  end

  defp close_zip(zip_handle) do
    :zip.zip_close(zip_handle)
    :ok
  end

  defp parse_document_xml(xml_content) when is_list(xml_content) do
    parse_document_xml(IO.iodata_to_binary(xml_content))
  end

  defp parse_document_xml(xml_content) when is_binary(xml_content) do
    # Extract paragraphs using regex-based parsing
    # Looking for <w:p>...</w:p> elements
    paragraph_regex = ~r/<w:p[^>]*>(.*?)<\/w:p>/s

    Regex.scan(paragraph_regex, xml_content)
    |> Enum.with_index()
    |> Enum.map(fn {[_full, content], index} ->
      %{
        index: index,
        text: extract_text_from_paragraph(content),
        style: extract_style_from_paragraph(content)
      }
    end)
    |> Enum.reject(&(&1.text == ""))
  end

  defp extract_text_from_paragraph(paragraph_xml) do
    # Extract text from <w:t>...</w:t> elements
    text_regex = ~r/<w:t[^>]*>([^<]*)<\/w:t>/

    Regex.scan(text_regex, paragraph_xml)
    |> Enum.map(fn [_full, text] -> text end)
    |> Enum.join("")
    |> String.trim()
  end

  defp extract_style_from_paragraph(paragraph_xml) do
    # Extract style from <w:pStyle w:val="..."/>
    style_regex = ~r/<w:pStyle\s+w:val="([^"]+)"/

    case Regex.run(style_regex, paragraph_xml) do
      [_full, style] -> style
      nil -> nil
    end
  end

  @doc """
  Identifies fillable fields from a list of paragraphs.

  Returns a list of field maps:
  %{
    paragraph_index: integer,
    field_label: string,
    field_type: atom,
    placeholder: string,
    suggested_category: atom
  }
  """
  def identify_fillable_fields(paragraphs) do
    paragraphs
    |> Enum.flat_map(&find_fields_in_paragraph/1)
  end

  defp find_fields_in_paragraph(%{index: index, text: text}) do
    fields = []

    # Find dot sequences (both regular dots and ellipsis character)
    fields = fields ++ find_dot_fields(index, text)

    # Find underscore sequences
    fields = fields ++ find_underscore_fields(index, text)

    # Find bracket placeholders
    fields = fields ++ find_bracket_fields(index, text)

    # Find checkboxes
    fields = fields ++ find_checkbox_fields(index, text)

    fields
  end

  defp find_dot_fields(index, text) do
    # Match sequences of dots (3+) or ellipsis characters (2+)
    dot_regex = ~r/([^\.…]*?)([\.]{3,}|[…]{2,})/u

    Regex.scan(dot_regex, text)
    |> Enum.map(fn
      [_full, label, placeholder] ->
        %{
          paragraph_index: index,
          field_label: clean_label(label),
          field_type: :dots,
          placeholder: placeholder,
          suggested_category: categorize_field(label)
        }
    end)
    |> Enum.reject(&(&1.field_label == ""))
  end

  defp find_underscore_fields(index, text) do
    # Match sequences of underscores (3+)
    underscore_regex = ~r/([^_]*?)(_{3,})/

    Regex.scan(underscore_regex, text)
    |> Enum.map(fn
      [_full, label, placeholder] ->
        %{
          paragraph_index: index,
          field_label: clean_label(label),
          field_type: :underscores,
          placeholder: placeholder,
          suggested_category: categorize_field(label)
        }
    end)
    |> Enum.reject(&(&1.field_label == ""))
  end

  defp find_bracket_fields(index, text) do
    # Match [placeholder text]
    bracket_regex = ~r/([^\[]*?)\[([^\]]+)\]/u

    Regex.scan(bracket_regex, text)
    |> Enum.map(fn
      [_full, label, placeholder] ->
        %{
          paragraph_index: index,
          field_label: clean_label(label),
          field_type: :brackets,
          placeholder: "[#{placeholder}]",
          suggested_category: categorize_field(label <> " " <> placeholder)
        }
    end)
  end

  defp find_checkbox_fields(index, text) do
    # Match checkbox characters followed by label
    checkbox_regex = ~r/(☐|□|▢)\s*([^☐□▢\n]+)/u

    Regex.scan(checkbox_regex, text)
    |> Enum.map(fn
      [_full, checkbox, label] ->
        %{
          paragraph_index: index,
          field_label: clean_label(label),
          field_type: :checkbox,
          placeholder: checkbox,
          suggested_category: categorize_field(label)
        }
    end)
  end

  defp clean_label(label) do
    label
    |> String.trim()
    |> String.replace(~r/[\s]+/, " ")
    |> String.replace(~r/^[\-–—\s:]+/, "")
    |> String.replace(~r/[\-–—\s:]+$/, "")
    |> String.trim()
  end

  @doc """
  Categorizes a field based on its label text.

  Returns an atom representing the suggested category.
  """
  def categorize_field(label) do
    label_lower = String.downcase(label)

    cond do
      # Company name
      String.contains?(label_lower, "nazw") and
          (String.contains?(label_lower, "firmy") or
             String.contains?(label_lower, "wykonawcy") or
             String.contains?(label_lower, "podmiotu")) ->
        :company_name

      # NIP
      String.contains?(label_lower, "nip") ->
        :nip

      # REGON
      String.contains?(label_lower, "regon") ->
        :regon

      # KRS
      String.contains?(label_lower, "krs") ->
        :krs

      # ePUAP (check before address - "Adres ePUAP" should be :epuap)
      String.contains?(label_lower, "epuap") or String.contains?(label_lower, "puap") ->
        :epuap

      # Email (check before address - "Adres e-mail" should be :email)
      String.contains?(label_lower, "e-mail") or
        String.contains?(label_lower, "email") or
          String.contains?(label_lower, "mail") ->
        :email

      # Phone
      String.contains?(label_lower, "telefon") or
        String.contains?(label_lower, "tel.") or
          String.contains?(label_lower, "tel:") ->
        :phone

      # Address
      String.contains?(label_lower, "adres") or
        String.contains?(label_lower, "siedzib") or
          String.contains?(label_lower, "miejscowoś") ->
        :address

      # Price
      String.contains?(label_lower, "cen") and
          (String.contains?(label_lower, "netto") or
             String.contains?(label_lower, "brutto") or
             String.contains?(label_lower, "ofert")) ->
        :price

      # Warranty
      String.contains?(label_lower, "gwarancj") ->
        :warranty

      # Representative
      (String.contains?(label_lower, "osoba") and String.contains?(label_lower, "reprezentuj")) or
          String.contains?(label_lower, "upoważnion") ->
        :representative

      # Proceeding reference number
      String.contains?(label_lower, "numer") and
          (String.contains?(label_lower, "postępowan") or
             String.contains?(label_lower, "referency")) ->
        :proceeding_ref

      # Proceeding name
      String.contains?(label_lower, "nazwa") and String.contains?(label_lower, "zamówieni") ->
        :proceeding_name

      # Bank account
      String.contains?(label_lower, "rachunek") or
        String.contains?(label_lower, "konto") or
          String.contains?(label_lower, "bank") ->
        :bank_account

      # Date
      String.contains?(label_lower, "data") or String.contains?(label_lower, "dnia") ->
        :date

      # Signature
      String.contains?(label_lower, "podpis") ->
        :signature

      # Unknown
      true ->
        :unknown
    end
  end

  @doc """
  Parses a document (.doc or .docx) and extracts all information.

  Returns:
  %{
    paragraphs: [...],
    fields: [...],
    format: :doc | :docx
  }
  """
  def parse_document(path) do
    format = detect_format(path)

    with {:ok, docx_path} <- ensure_docx(path, format),
         {:ok, paragraphs} <- extract_paragraphs(docx_path) do
      fields = identify_fillable_fields(paragraphs)

      result = %{
        paragraphs: paragraphs,
        fields: fields,
        format: format
      }

      # Clean up converted file if we created one
      if format == :doc and docx_path != path do
        File.rm(docx_path)
      end

      {:ok, result}
    end
  end

  defp detect_format(path) do
    case Path.extname(path) |> String.downcase() do
      ".doc" -> :doc
      ".docx" -> :docx
      _ -> :unknown
    end
  end

  defp ensure_docx(path, :docx), do: {:ok, path}
  defp ensure_docx(path, :doc), do: convert_doc_to_docx(path)
  defp ensure_docx(_path, :unknown), do: {:error, :unsupported_format}

  @doc """
  Groups fields by their suggested category.
  """
  def group_fields_by_category(fields) do
    Enum.group_by(fields, & &1.suggested_category)
  end

  @doc """
  Returns fields that match the given category.
  """
  def filter_fields_by_category(fields, category) do
    Enum.filter(fields, &(&1.suggested_category == category))
  end
end
