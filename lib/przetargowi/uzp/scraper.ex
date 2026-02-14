defmodule Przetargowi.UZP.Scraper do
  @moduledoc """
  Scraper for fetching judgements from orzeczenia.uzp.gov.pl

  The UZP website uses AJAX to load search results. The main search page
  is at /Home/Search but actual results are fetched via POST to /Home/GetResults.
  """

  require Logger

  alias Przetargowi.Judgements.TextExtractor

  @base_url "https://orzeczenia.uzp.gov.pl"
  @results_path "/Home/GetResults"
  @details_path "/Home/Details"

  @doc """
  Fetches a page of judgements from the search results.
  Returns {:ok, %{judgements: [...], total_pages: n}} or {:error, reason}
  """
  def fetch_list_page(page \\ 1) do
    url = "#{@base_url}#{@results_path}"
    body = build_search_params(page)

    case http_client().post(url, body) do
      {:ok, %{status: 200, body: body}} ->
        parse_list_page(body)

      {:ok, %{status: status}} ->
        {:error, "Unexpected status code: #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Fetches details for a specific judgement by UZP ID.
  Returns {:ok, details_map} or {:error, reason}
  """
  def fetch_details(uzp_id) do
    url = build_details_url(uzp_id)

    case http_client().get(url) do
      {:ok, %{status: 200, body: body}} ->
        with {:ok, details} <- parse_details_page(body, uzp_id) do
          # Fetch the actual document content HTML from iframe URL
          content_html = fetch_content_html(details.content_url)

          # Extract deliberation section and generate meritum summary
          deliberation = TextExtractor.extract_deliberation(content_html)
          meritum = TextExtractor.extract_deliberation_summary(deliberation)

          {:ok,
           details
           |> Map.put(:content_html, content_html)
           |> Map.put(:deliberation, deliberation)
           |> Map.put(:meritum, meritum)
           |> Map.delete(:content_url)}
        end

      {:ok, %{status: status}} ->
        {:error, "Unexpected status code: #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp fetch_content_html(nil), do: nil

  defp fetch_content_html(content_url) do
    case http_client().get(content_url) do
      {:ok, %{status: 200, body: body}} ->
        body

      _ ->
        nil
    end
  end

  # URL/params builders

  defp build_search_params(page) do
    "Fle=1&SCnt=1&CountStats=True&Pg=#{page}"
  end

  defp build_details_url(uzp_id) do
    "#{@base_url}#{@details_path}/#{uzp_id}?Fle=1&SCnt=1&CountStats=False"
  end

  # List page parsing

  defp parse_list_page(html) do
    with {:ok, document} <- Floki.parse_document(html) do
      judgements = extract_judgements_from_list(document)
      total_pages = extract_total_pages(document)

      {:ok, %{judgements: judgements, total_pages: total_pages}}
    end
  end

  defp extract_judgements_from_list(document) do
    document
    |> Floki.find(".search-list-item")
    |> Enum.map(&parse_list_item/1)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_list_item(element) do
    # Find the details link to extract UZP ID
    details_link =
      element
      |> Floki.find("a.link-details")
      |> List.first()

    case details_link do
      nil -> nil
      link -> parse_with_link(element, link)
    end
  end

  defp parse_with_link(element, link) do
    href = Floki.attribute(link, "href") |> List.first() || ""
    uzp_id = extract_uzp_id_from_href(href)

    if uzp_id do
      %{
        uzp_id: uzp_id,
        signature: extract_label_value(element, "Sygnatura"),
        issuing_authority: extract_label_value(element, "Organ wydający"),
        document_type: extract_label_value(element, "Rodzaj dokumentu"),
        decision_date: extract_and_parse_date_from_element(element),
        synced_at: DateTime.utc_now() |> DateTime.truncate(:second)
      }
    else
      nil
    end
  end

  defp extract_label_value(element, label_text) do
    # Find <label> elements containing the given text
    labels = Floki.find(element, "label")

    Enum.find_value(labels, fn label_el ->
      label = Floki.text(label_el) |> String.trim()

      if String.contains?(label, label_text) do
        # Get the parent element (the <p> or <div> containing this label)
        # Since Floki doesn't have parent navigation, we find the element by its label text
        element
        |> Floki.find("p, div")
        |> Enum.find_value(fn parent_el ->
          parent_labels = parent_el |> Floki.find("label") |> Floki.text() |> String.trim()

          if parent_labels == label do
            # Get text after the label (siblings)
            full_text = Floki.text(parent_el) |> String.trim()
            # Remove the label part - label already contains colon
            value = String.replace(full_text, ~r/^#{Regex.escape(label)}\s*/, "", global: false)
            String.trim(value)
          else
            nil
          end
        end)
      else
        nil
      end
    end)
  end

  defp extract_and_parse_date_from_element(element) do
    date_text = extract_label_value(element, "Data wydania")
    parse_date_text(date_text)
  end

  defp parse_date_text(nil), do: nil

  defp parse_date_text(text) do
    # Try DD-MM-YYYY format (used by UZP)
    case Regex.run(~r/(\d{2})-(\d{2})-(\d{4})/, text) do
      [_, day, month, year] ->
        case Date.new(String.to_integer(year), String.to_integer(month), String.to_integer(day)) do
          {:ok, date} -> date
          _ -> nil
        end

      _ ->
        # Try YYYY-MM-DD format
        case Regex.run(~r/(\d{4})-(\d{2})-(\d{2})/, text) do
          [_, year, month, day] ->
            case Date.new(String.to_integer(year), String.to_integer(month), String.to_integer(day)) do
              {:ok, date} -> date
              _ -> nil
            end

          _ ->
            nil
        end
    end
  end

  defp extract_uzp_id_from_href(href) do
    case Regex.run(~r/Details\/(\d+)/, href) do
      [_, id] -> id
      _ -> nil
    end
  end

  defp extract_total_pages(document) do
    # First try to find pagination info from result counts (more reliable)
    result_counts =
      document
      |> Floki.find("#resultCounts")
      |> Floki.attribute("value")
      |> List.first()

    case result_counts do
      nil ->
        # Fallback: try pagination text
        extract_pages_from_pagination(document)

      counts_str ->
        # Format is "total,kio,so,sa,sn"
        case String.split(counts_str, ",") |> List.first() do
          nil -> 1
          total_str ->
            total = String.to_integer(total_str)
            # 10 results per page, round up, minimum 1 page
            max(1, div(total + 9, 10))
        end
    end
  end

  defp extract_pages_from_pagination(document) do
    # Look for "X z Y" pattern in pagination
    pagination_text =
      document
      |> Floki.find(".results-pager a, .pagination a")
      |> Enum.map(&Floki.text/1)
      |> Enum.join(" ")

    case Regex.run(~r/(\d+)\s+z\s+(\d+)/, pagination_text) do
      [_, _current, total] -> String.to_integer(total)
      _ -> 1
    end
  end

  # Details page parsing

  defp parse_details_page(html, uzp_id) do
    with {:ok, document} <- Floki.parse_document(html) do
      details = %{
        chairman: extract_detail_field(document, "Przewodniczący"),
        contracting_authority: extract_detail_field(document, "Zamawiający"),
        location: extract_detail_field(document, "Miejscowość"),
        resolution_method: extract_resolution_method(document),
        procedure_type: extract_detail_field(document, "Tryb postępowania"),
        key_provisions: extract_provisions(document),
        thematic_issues: extract_thematic_issues(document),
        content_url: extract_content_url(document),
        content_html: nil,
        pdf_url: extract_pdf_url(document, uzp_id),
        details_synced_at: DateTime.utc_now() |> DateTime.truncate(:second)
      }

      {:ok, details}
    end
  end

  defp extract_detail_field(document, label) do
    # The details page uses <p><label>Label</label>VALUE</p> structure in .details-metrics
    document
    |> Floki.find(".details-metrics p, .details p")
    |> Enum.find_value(fn p_el ->
      label_el = Floki.find(p_el, "label") |> List.first()

      case label_el do
        nil ->
          nil

        _ ->
          label_text = Floki.text(label_el) |> String.trim()

          if String.contains?(label_text, label) do
            # Get full text and remove label part
            full_text = Floki.text(p_el) |> String.trim()
            # Remove the label text (the CSS adds colon via :after)
            value = String.replace(full_text, label_text, "", global: false) |> String.trim()
            if value == "", do: nil, else: value
          else
            nil
          end
      end
    end)
  end

  defp extract_resolution_method(document) do
    # Resolution method is in: <label>Sygnatura akt / Sposób rozstrzygnięcia</label><ul><li>KIO xxx / METHOD</li></ul>
    document
    |> Floki.find(".details-metrics li, .details li")
    |> Enum.map(&Floki.text/1)
    |> Enum.find_value(fn li_text ->
      # Format is "KIO xxx/xx / resolution method"
      case Regex.run(~r/\/\s*([^\/]+)$/, String.trim(li_text)) do
        [_, method] -> String.trim(method)
        _ -> nil
      end
    end)
  end

  defp extract_provisions(document) do
    # Provisions are in: <b>Kluczowe przepisy ustawy Pzp</b><p><a>provisions separated by |</a></p>
    document
    |> Floki.find("b")
    |> Enum.find_value(fn b_el ->
      if String.contains?(Floki.text(b_el), "Kluczowe przepisy") do
        # Find the next <p> sibling with <a> containing provisions
        # Since Floki doesn't have next-sibling, we search for <a> after this <b>
        document
        |> Floki.find("a[href*='Search?Phrase=art']")
        |> List.first()
        |> case do
          nil ->
            []

          a_el ->
            Floki.text(a_el)
            |> String.split("|")
            |> Enum.map(&String.trim/1)
            |> Enum.reject(&(&1 == ""))
        end
      else
        nil
      end
    end) || []
  end

  defp extract_thematic_issues(document) do
    # Thematic issues are in: <b>Zagadnienia merytoryczne...</b><p><a>issues separated by |</a></p>
    document
    |> Floki.find("b")
    |> Enum.find_value(fn b_el ->
      if String.contains?(Floki.text(b_el), "Zagadnienia merytoryczne") do
        # Find the <a> element after this section
        # Look for <a> tags that link to search with thematic index
        document
        |> Floki.find("a[title*='indeksu tematycznego']")
        |> List.first()
        |> case do
          nil ->
            []

          a_el ->
            Floki.text(a_el)
            |> String.split("|")
            |> Enum.map(&String.trim/1)
            |> Enum.reject(&(&1 == ""))
            |> Enum.take(20)
        end
      else
        nil
      end
    end) || []
  end

  defp extract_content_url(document) do
    # Content is loaded via iframe at /Home/ContentHtml/{id}
    # Extract the iframe src to get the content URL
    iframe = document |> Floki.find("#iframeContent, iframe") |> List.first()

    case iframe do
      nil ->
        nil

      _ ->
        src = Floki.attribute(iframe, "src") |> List.first()
        if src, do: "#{@base_url}#{src}", else: nil
    end
  end

  defp extract_pdf_url(document, uzp_id) do
    # Look for PDF content link first
    pdf_link =
      document
      |> Floki.find("a[href*='PdfContent'], a[href*='PdfMetrics']")
      |> List.first()

    case pdf_link do
      nil ->
        # Build default PDF URL
        "#{@base_url}/Home/PdfContent/#{uzp_id}"

      link ->
        href = Floki.attribute(link, "href") |> List.first() || ""

        if String.starts_with?(href, "http") do
          href
        else
          "#{@base_url}#{href}"
        end
    end
  end

  # HTTP client (allows mocking in tests)

  defp http_client do
    Application.get_env(:przetargowi, :uzp_http_client, Przetargowi.UZP.HTTPClient)
  end
end
