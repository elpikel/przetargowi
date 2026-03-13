defmodule Przetargowi.TenderDocuments do
  @moduledoc """
  Handles downloading and classifying tender documents from the e-Zamówienia platform.
  """

  defmodule DownloadableDocument do
    @moduledoc """
    Embedded schema for a downloadable tender document with classification.
    """
    use Ecto.Schema

    import Ecto.Changeset

    @document_types [
      :swz,
      :offer_form,
      :declaration_art125,
      :declaration_capital_group,
      :declaration_actuality,
      :declaration_ukraine,
      :contract_template,
      :description_of_object,
      :amendment,
      :other
    ]

    @primary_key false
    embedded_schema do
      field :name, :string
      field :filename, :string
      field :url, :string
      field :document_type, Ecto.Enum, values: @document_types, default: :other
      field :fillable, :boolean, default: false
      field :downloaded_path, :string
    end

    def changeset(doc, attrs) do
      doc
      |> cast(attrs, [:name, :filename, :url, :document_type, :fillable, :downloaded_path])
      |> validate_required([:name, :filename, :url])
    end

    def document_types, do: @document_types
  end

  @doc """
  Classifies a document by its name and filename into a document_type.
  Returns one of: :swz, :offer_form, :declaration_art125, :declaration_capital_group,
  :declaration_actuality, :declaration_ukraine, :contract_template,
  :description_of_object, :amendment, :other
  """
  def classify_document(name, filename) do
    name_lower = String.downcase(name || "")
    filename_lower = String.downcase(filename || "")
    combined = name_lower <> " " <> filename_lower

    cond do
      # Formularz ofertowy
      String.contains?(combined, "formularz ofertowy") or
          String.contains?(combined, "formularz oferty") ->
        :offer_form

      # Oświadczenie art. 125
      String.contains?(combined, "oświadczenie") and
          (String.contains?(combined, "art. 125") or String.contains?(combined, "art.125")) ->
        :declaration_art125

      # Oświadczenie o grupie kapitałowej
      String.contains?(combined, "oświadczenie") and
        String.contains?(combined, "grup") and
          String.contains?(combined, "kapitał") ->
        :declaration_capital_group

      # Oświadczenie o aktualności
      String.contains?(combined, "oświadczenie") and String.contains?(combined, "aktualn") ->
        :declaration_actuality

      # Oświadczenie dot. Ukrainy / art. 7
      String.contains?(combined, "oświadczenie") and
          (String.contains?(combined, "ukrain") or String.contains?(combined, "art. 7") or
             String.contains?(combined, "art.7")) ->
        :declaration_ukraine

      # SWZ (but not załącznik do SWZ)
      String.contains?(filename_lower, "swz") and not String.contains?(combined, "załącznik") ->
        :swz

      # Opis przedmiotu zamówienia / załącznik nr 1
      String.contains?(combined, "opis przedmiotu") or
          (String.contains?(combined, "załącznik nr 1") and String.contains?(combined, "opz")) ->
        :description_of_object

      # Umowa / wzór umowy / projekt umowy
      String.contains?(combined, "umow") or String.contains?(combined, "wzór umowy") or
          String.contains?(combined, "projekt umowy") ->
        :contract_template

      # Zmiana / modyfikacja
      String.contains?(combined, "zmiana") or String.contains?(combined, "modyfikacja") ->
        :amendment

      # Default
      true ->
        :other
    end
  end

  @doc """
  Determines if a document is fillable (needs to be filled by executor).
  """
  def fillable?(name, filename) do
    name_lower = String.downcase(name || "")
    filename_lower = String.downcase(filename || "")
    combined = name_lower <> " " <> filename_lower

    # Fillable documents are typically forms and declarations
    String.contains?(combined, "formularz") or
      String.contains?(combined, "oświadczenie") or
      String.contains?(combined, "załącznik nr") or
      String.contains?(combined, "wykaz") or
      String.contains?(combined, "zobowiązanie")
  end

  @doc """
  Parses a przetargowi.pl tender page HTML and extracts document links.
  Returns a list of %DownloadableDocument{} structs.
  """
  def parse_tender_page(html_body) do
    html_body
    |> Floki.parse_document!()
    |> Floki.find("a[href*='ezamowienia.gov.pl/mp-client/search/tenderdocument']")
    |> Enum.map(&parse_document_link/1)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_document_link(link_element) do
    url = Floki.attribute(link_element, "href") |> List.first()

    # Try to extract name and filename from the link structure
    # Based on the tender page template, structure is:
    # <a><div><icon/></div><div><p>name</p><p>filename</p></div><icon/></a>
    texts =
      link_element
      |> Floki.find("p")
      |> Enum.map(&Floki.text/1)
      |> Enum.map(&String.trim/1)

    {name, filename} =
      case texts do
        [n, f | _] -> {n, f}
        [n] -> {n, extract_filename_from_url(url)}
        [] -> {extract_name_from_url(url), extract_filename_from_url(url)}
      end

    if url do
      document_type = classify_document(name, filename)
      fillable = fillable?(name, filename)

      %DownloadableDocument{
        name: name,
        filename: filename,
        url: url,
        document_type: document_type,
        fillable: fillable
      }
    end
  end

  defp extract_filename_from_url(url) when is_binary(url) do
    url
    |> URI.parse()
    |> Map.get(:path, "")
    |> Path.basename()
  end

  defp extract_filename_from_url(_), do: "document"

  defp extract_name_from_url(url) when is_binary(url) do
    extract_filename_from_url(url)
  end

  defp extract_name_from_url(_), do: "Document"

  @doc """
  Downloads a document from the given URL to the destination directory.

  Returns {:ok, local_path} on success, {:error, reason} on failure.

  Note: e-Zamówienia uses a JavaScript SPA, so direct downloads may return HTML.
  In that case, returns {:error, :spa_redirect} as a placeholder for future
  headless browser automation.
  """
  def download_document(url, dest_dir) do
    filename = extract_filename_from_url(url)
    dest_path = Path.join(dest_dir, filename)

    with :ok <- ensure_directory(dest_dir),
         {:ok, response} <- fetch_document(url),
         :ok <- validate_response(response),
         :ok <- File.write(dest_path, response.body) do
      {:ok, dest_path}
    else
      {:error, :spa_redirect} = error -> error
      {:error, reason} -> {:error, reason}
    end
  end

  defp ensure_directory(dir) do
    case File.mkdir_p(dir) do
      :ok -> :ok
      {:error, reason} -> {:error, {:mkdir_failed, reason}}
    end
  end

  defp fetch_document(url) do
    case Req.get(url, follow_redirects: true, max_redirects: 5) do
      {:ok, %{status: status} = response} when status in 200..299 ->
        {:ok, response}

      {:ok, %{status: status}} ->
        {:error, {:http_error, status}}

      {:error, reason} ->
        {:error, {:request_failed, reason}}
    end
  end

  defp validate_response(%{headers: headers, body: body}) do
    content_type =
      headers
      |> Enum.find(fn {k, _} -> String.downcase(k) == "content-type" end)
      |> case do
        {_, v} -> String.downcase(v)
        nil -> ""
      end

    cond do
      # If content-type indicates HTML, it's likely an SPA redirect
      String.contains?(content_type, "text/html") ->
        {:error, :spa_redirect}

      # Check if body looks like HTML (SPA shell)
      is_binary(body) and String.starts_with?(String.trim(body), "<!DOCTYPE") ->
        {:error, :spa_redirect}

      is_binary(body) and String.starts_with?(String.trim(body), "<html") ->
        {:error, :spa_redirect}

      true ->
        :ok
    end
  end

  @doc """
  Downloads all documents concurrently.

  Returns a list of {document, result} tuples where result is
  {:ok, local_path} or {:error, reason}.
  """
  def download_all(documents, dest_dir) do
    documents
    |> Task.async_stream(
      fn doc -> {doc, download_document(doc.url, dest_dir)} end,
      max_concurrency: 3,
      timeout: 60_000
    )
    |> Enum.map(fn
      {:ok, result} -> result
      {:exit, reason} -> {nil, {:error, {:task_failed, reason}}}
    end)
  end

  @doc """
  Updates a document with its downloaded path.
  """
  def set_downloaded_path(%DownloadableDocument{} = doc, path) do
    %{doc | downloaded_path: path}
  end

  @doc """
  Filters documents by type.
  """
  def filter_by_type(documents, type) when is_atom(type) do
    Enum.filter(documents, &(&1.document_type == type))
  end

  @doc """
  Filters fillable documents.
  """
  def filter_fillable(documents) do
    Enum.filter(documents, & &1.fillable)
  end
end
