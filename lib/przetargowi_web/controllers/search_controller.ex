defmodule PrzetargowiWeb.SearchController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements

  @per_page 10
  @max_searches_for_guests 3

  def index(conn, params) do
    query = Map.get(params, "q", "")
    page = parse_page(Map.get(params, "page", "1"))
    offset = (page - 1) * @per_page
    filters = extract_filters(params)

    is_logged_in = logged_in?(conn)
    is_search = query != "" or has_filters?(filters)
    search_count = get_session(conn, :search_count) || 0

    # Check rate limit for non-logged-in users
    if not is_logged_in and is_search and search_count >= @max_searches_for_guests do
      render_rate_limited(conn, query, filters)
    else
      # Increment search count for non-logged-in users
      conn =
        if not is_logged_in and is_search do
          put_session(conn, :search_count, search_count + 1)
        else
          conn
        end

      # Fetch judgements and count from database
      results = Judgements.search_judgements(query, limit: @per_page, offset: offset, filters: filters)
      total_count = Judgements.count_search_results(query, filters)
      total_pages = ceil(total_count / @per_page)

      # Get filter options for dropdowns
      filter_options = Judgements.get_filter_options()

      # Transform to view format
      view_results = Enum.map(results, &transform_judgement/1)

      # Canonical URL without page param to avoid duplicate content
      canonical_url = build_canonical_url(query, filters)

      conn
      |> assign(:page_title, if(query != "", do: "Wyniki: #{query}", else: "Wyszukiwarka"))
      |> assign(:meta_description, build_search_meta_description(query, filters))
      |> assign(:canonical_url, canonical_url)
      |> assign(:og_url, canonical_url)
      |> assign(:query, query)
      |> assign(:filters, filters)
      |> assign(:filter_options, filter_options)
      |> assign(:results, view_results)
      |> assign(:total_count, total_count)
      |> assign(:current_page, page)
      |> assign(:total_pages, total_pages)
      |> assign(:rate_limited, false)
      |> render(:index)
    end
  end

  defp logged_in?(conn) do
    conn.assigns[:current_scope] != nil and conn.assigns.current_scope.user != nil
  end

  defp has_filters?(filters) do
    Enum.any?(filters, fn {_k, v} -> v != "" end)
  end

  defp render_rate_limited(conn, query, filters) do
    filter_options = Judgements.get_filter_options()

    conn
    |> assign(:page_title, "Wyszukiwarka")
    |> assign(:meta_description, "Wyszukaj orzeczenia KIO dotyczące zamówień publicznych.")
    |> assign(:query, query)
    |> assign(:filters, filters)
    |> assign(:filter_options, filter_options)
    |> assign(:results, [])
    |> assign(:total_count, 0)
    |> assign(:current_page, 1)
    |> assign(:total_pages, 0)
    |> assign(:rate_limited, true)
    |> render(:index)
  end

  defp parse_page(page_str) do
    case Integer.parse(page_str) do
      {page, ""} when page > 0 -> page
      _ -> 1
    end
  end

  defp extract_filters(params) do
    %{
      document_type: Map.get(params, "document_type", ""),
      issuing_authority: Map.get(params, "issuing_authority", ""),
      resolution_method: Map.get(params, "resolution_method", ""),
      procedure_type: Map.get(params, "procedure_type", ""),
      date_from: Map.get(params, "date_from", ""),
      date_to: Map.get(params, "date_to", "")
    }
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

  defp build_canonical_url(query, filters) do
    base = "https://przetargowi.pl/szukaj"

    params =
      [{"q", query}]
      |> add_filter_param(filters, :document_type, "document_type")
      |> add_filter_param(filters, :issuing_authority, "issuing_authority")
      |> add_filter_param(filters, :resolution_method, "resolution_method")
      |> Enum.filter(fn {_, v} -> v != "" end)

    if params == [] do
      base
    else
      query_string = URI.encode_query(params)
      "#{base}?#{query_string}"
    end
  end

  defp add_filter_param(params, filters, key, param_name) do
    value = Map.get(filters, key, "")
    if value != "", do: params ++ [{param_name, value}], else: params
  end

  defp build_search_meta_description(query, filters) do
    base = "Wyszukaj orzeczenia KIO dotyczące zamówień publicznych"

    cond do
      query != "" ->
        "#{base}. Wyniki dla: #{query}"

      filters[:document_type] != "" ->
        "#{base}. Filtr: #{filters[:document_type]}"

      true ->
        "#{base}."
    end
  end
end
