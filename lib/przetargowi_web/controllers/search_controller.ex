defmodule PrzetargowiWeb.SearchController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements

  @per_page 10

  def index(conn, params) do
    query = Map.get(params, "q", "")
    page = parse_page(Map.get(params, "page", "1"))
    offset = (page - 1) * @per_page

    # Fetch judgements and count from database
    {results, total_count} =
      if query != "" do
        {
          Judgements.search_judgements(query, limit: @per_page, offset: offset),
          Judgements.count_search_results(query)
        }
      else
        {
          Judgements.list_judgements(limit: @per_page, offset: offset),
          Judgements.count_judgements()
        }
      end

    total_pages = ceil(total_count / @per_page)

    # Transform to view format
    view_results = Enum.map(results, &transform_judgement/1)

    conn
    |> assign(:page_title, if(query != "", do: "Wyniki: #{query}", else: "Wyszukiwarka"))
    |> assign(
      :meta_description,
      "Wyszukaj orzeczenia KIO dotyczące zamówień publicznych."
    )
    |> assign(:query, query)
    |> assign(:results, view_results)
    |> assign(:total_count, total_count)
    |> assign(:current_page, page)
    |> assign(:total_pages, total_pages)
    |> render(:index)
  end

  defp parse_page(page_str) do
    case Integer.parse(page_str) do
      {page, ""} when page > 0 -> page
      _ -> 1
    end
  end

  defp transform_judgement(judgement) do
    %{
      id: judgement.id,
      signature: judgement.signature,
      decision_date: judgement.decision_date,
      document_type: judgement.document_type,
      resolution_method: judgement.resolution_method,
      contracting_authority: judgement.contracting_authority,
      meritum: judgement.meritum
    }
  end
end
