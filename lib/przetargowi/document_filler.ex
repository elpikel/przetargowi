defmodule Przetargowi.DocumentFiller do
  @moduledoc """
  Fills tender document placeholders with company profile data.

  Uses the same ZIP/XML approach as DocumentParser to read and modify DOCX files.
  Documents must be pre-downloaded by the DownloadTenderDocuments worker.
  """

  alias Przetargowi.Profiles.CompanyProfile

  @doc """
  Fills a local DOCX file with profile data.

  Returns {:ok, binary} or {:error, reason}.
  """
  def fill_document_from_file(docx_path, %CompanyProfile{} = profile) do
    with {:ok, original_binary} <- File.read(docx_path),
         {:ok, filled_binary} <- fill_docx(original_binary, profile) do
      {:ok, filled_binary}
    end
  end

  @doc """
  Fills a document from stored binary content.

  Returns {:ok, binary} or {:error, reason}.
  """
  def fill_document_from_binary(binary, %CompanyProfile{} = profile) when is_binary(binary) do
    fill_docx(binary, profile)
  end

  @doc """
  Fills multiple documents and returns a ZIP archive.

  Documents must be TenderDocument structs with stored content.
  Returns {:ok, zip_binary, success_count, total_count} or {:error, reason}.
  """
  def fill_documents(documents, %CompanyProfile{} = profile) do
    results =
      documents
      |> Enum.map(fn doc -> fill_single_document(doc, profile) end)

    successes =
      results
      |> Enum.filter(&match?({:ok, _}, &1))
      |> Enum.map(fn {:ok, file_tuple} -> file_tuple end)

    if Enum.empty?(successes) do
      {:error, :no_documents_filled}
    else
      case create_zip(successes) do
        {:ok, zip_binary} -> {:ok, zip_binary, length(successes), length(documents)}
        {:error, reason} -> {:error, reason}
      end
    end
  end

  # Fills a single document - requires stored content
  defp fill_single_document(%{content: content} = doc, profile)
       when is_binary(content) do
    filename = get_filename(doc)

    case fill_docx(content, profile) do
      {:ok, binary} -> {:ok, {filename, binary}}
      {:error, reason} -> {:error, {filename, reason}}
    end
  end

  defp fill_single_document(%{content: nil} = doc, _profile) do
    filename = get_filename(doc)
    {:error, {filename, :content_not_downloaded}}
  end

  defp fill_single_document(doc, _profile) do
    filename = get_filename(doc)
    {:error, {filename, :content_not_downloaded}}
  end

  # Fills placeholders in a DOCX binary
  defp fill_docx(docx_binary, profile) do
    with {:ok, zip_handle} <- open_docx_binary(docx_binary),
         {:ok, entries} <- list_zip_entries(zip_handle),
         {:ok, modified_entries} <- process_entries(zip_handle, entries, profile),
         :ok <- close_zip(zip_handle),
         {:ok, new_zip_binary} <- create_new_docx(modified_entries) do
      {:ok, new_zip_binary}
    end
  end

  defp open_docx_binary(binary) do
    case :zip.zip_open(binary, [:memory]) do
      {:ok, handle} -> {:ok, handle}
      {:error, reason} -> {:error, {:zip_open_failed, reason}}
    end
  end

  defp list_zip_entries(zip_handle) do
    case :zip.zip_list_dir(zip_handle) do
      {:ok, entries} ->
        file_entries =
          entries
          |> Enum.filter(fn
            {:zip_file, _name, _info, _comment, _offset, _comp_size} -> true
            _ -> false
          end)
          |> Enum.map(fn {:zip_file, name, _info, _comment, _offset, _comp_size} ->
            to_string(name)
          end)

        {:ok, file_entries}

      {:error, reason} ->
        {:error, {:zip_list_failed, reason}}
    end
  end

  defp process_entries(zip_handle, entries, profile) do
    results =
      Enum.map(entries, fn entry_name ->
        case :zip.zip_get(String.to_charlist(entry_name), zip_handle) do
          {:ok, {^entry_name, content}} ->
            process_entry(entry_name, content, profile)

          {:ok, {name, content}} ->
            process_entry(to_string(name), content, profile)

          {:error, reason} ->
            {:error, {entry_name, reason}}
        end
      end)

    errors = Enum.filter(results, &match?({:error, _}, &1))

    if Enum.empty?(errors) do
      {:ok, Enum.map(results, fn {:ok, entry} -> entry end)}
    else
      {:error, {:processing_failed, errors}}
    end
  end

  defp process_entry(entry_name, content, profile) do
    content_binary = IO.iodata_to_binary(content)

    # Only process XML files that might contain text
    if String.ends_with?(entry_name, ".xml") do
      filled_content = fill_xml_placeholders(content_binary, profile)
      {:ok, {String.to_charlist(entry_name), filled_content}}
    else
      {:ok, {String.to_charlist(entry_name), content_binary}}
    end
  end

  defp fill_xml_placeholders(xml_content, profile) do
    replacements = build_replacement_map(profile)

    Enum.reduce(replacements, xml_content, fn {pattern, replacement}, acc ->
      String.replace(acc, pattern, replacement)
    end)
  end

  defp build_replacement_map(profile) do
    # Build map of placeholder patterns to values
    base_replacements = [
      # Bracket placeholders
      {"[nazwa wykonawcy]", profile.company_name || ""},
      {"[nazwa firmy]", profile.company_name || ""},
      {"[Nazwa wykonawcy]", profile.company_name || ""},
      {"[Nazwa firmy]", profile.company_name || ""},
      {"[NAZWA WYKONAWCY]", profile.company_name || ""},
      {"[nip]", profile.nip || ""},
      {"[NIP]", profile.nip || ""},
      {"[regon]", profile.regon || ""},
      {"[REGON]", profile.regon || ""},
      {"[krs]", profile.krs || ""},
      {"[KRS]", profile.krs || ""},
      {"[adres]", format_full_address(profile)},
      {"[Adres]", format_full_address(profile)},
      {"[ADRES]", format_full_address(profile)},
      {"[adres siedziby]", format_full_address(profile)},
      {"[Adres siedziby]", format_full_address(profile)},
      {"[miejscowość]", profile.city || ""},
      {"[Miejscowość]", profile.city || ""},
      {"[kod pocztowy]", profile.postal_code || ""},
      {"[ulica]", profile.street || ""},
      {"[telefon]", profile.phone || ""},
      {"[Telefon]", profile.phone || ""},
      {"[tel]", profile.phone || ""},
      {"[e-mail]", profile.email || ""},
      {"[E-mail]", profile.email || ""},
      {"[email]", profile.email || ""},
      {"[adres e-mail]", profile.email || ""},
      {"[adres email]", profile.email || ""},
      {"[epuap]", profile.epuap_address || ""},
      {"[ePUAP]", profile.epuap_address || ""},
      {"[adres ePUAP]", profile.epuap_address || ""},
      {"[osoba reprezentująca]", format_primary_representative(profile)},
      {"[Osoba reprezentująca]", format_primary_representative(profile)},
      {"[imię i nazwisko]", format_primary_representative_name(profile)},
      {"[Imię i nazwisko]", format_primary_representative_name(profile)},
      {"[stanowisko]", format_primary_representative_position(profile)},
      {"[bank]", profile.bank_name || ""},
      {"[nazwa banku]", profile.bank_name || ""},
      {"[numer konta]", profile.bank_account || ""},
      {"[numer rachunku]", profile.bank_account || ""},
      {"[rachunek bankowy]", profile.bank_account || ""},
      {"[wpisz nazwę]", profile.company_name || ""},
      {"[wpisz adres]", format_full_address(profile)},
      {"[wpisz NIP]", profile.nip || ""},
      {"[wpisz nip]", profile.nip || ""}
    ]

    # Filter out empty replacements
    Enum.filter(base_replacements, fn {_, value} -> value != "" end)
  end

  defp format_full_address(profile) do
    parts =
      [
        profile.street,
        [profile.postal_code, profile.city] |> Enum.filter(& &1) |> Enum.join(" ")
      ]
      |> Enum.filter(&(&1 && &1 != ""))
      |> Enum.join(", ")

    if parts == "", do: "", else: parts
  end

  defp format_primary_representative(profile) do
    case get_primary_representative(profile) do
      nil -> ""
      rep -> "#{rep.full_name}, #{rep.position}"
    end
  end

  defp format_primary_representative_name(profile) do
    case get_primary_representative(profile) do
      nil -> ""
      rep -> rep.full_name || ""
    end
  end

  defp format_primary_representative_position(profile) do
    case get_primary_representative(profile) do
      nil -> ""
      rep -> rep.position || ""
    end
  end

  defp get_primary_representative(profile) do
    case profile.representatives do
      nil -> nil
      [] -> nil
      reps -> Enum.find(reps, List.first(reps), & &1.is_primary)
    end
  end

  defp close_zip(zip_handle) do
    :zip.zip_close(zip_handle)
    :ok
  end

  defp create_new_docx(entries) do
    case :zip.create(~c"document.docx", entries, [:memory]) do
      {:ok, {~c"document.docx", binary}} -> {:ok, binary}
      {:error, reason} -> {:error, {:zip_create_failed, reason}}
    end
  end

  defp create_zip(file_tuples) do
    entries =
      Enum.map(file_tuples, fn {filename, binary} -> {String.to_charlist(filename), binary} end)

    case :zip.create(~c"documents.zip", entries, [:memory]) do
      {:ok, {~c"documents.zip", binary}} -> {:ok, binary}
      {:error, reason} -> {:error, {:zip_create_failed, reason}}
    end
  end

  defp get_filename(%{file_name: file_name}) when is_binary(file_name) and file_name != "" do
    file_name
  end

  defp get_filename(%{name: name}) when is_binary(name) do
    "#{name}.docx"
  end

  defp get_filename(_), do: "document.docx"

  @doc """
  Returns a preview of which fields would be filled for a given profile.

  This is useful for showing users what data will be used before filling.
  """
  def preview_field_mapping(%CompanyProfile{} = profile) do
    %{
      company_name: profile.company_name,
      nip: profile.nip,
      regon: profile.regon,
      krs: profile.krs,
      address: format_full_address(profile),
      phone: profile.phone,
      email: profile.email,
      epuap: profile.epuap_address,
      representative: format_primary_representative(profile),
      bank_account:
        if(profile.bank_name && profile.bank_account,
          do: "#{profile.bank_name}: #{profile.bank_account}",
          else: profile.bank_account
        )
    }
  end
end
