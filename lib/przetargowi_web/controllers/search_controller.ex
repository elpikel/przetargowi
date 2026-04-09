defmodule PrzetargowiWeb.SearchController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Embeddings
  alias Przetargowi.Judgements
  alias Przetargowi.Payments
  alias Przetargowi.SearchLogs

  @per_page 10
  @max_searches_free 3
  @semantic_results_limit 20

  def index(conn, params) do
    query = Map.get(params, "q", "")
    search_mode = Map.get(params, "mode", "keyword")
    page = parse_page(Map.get(params, "page", "1"))
    offset = (page - 1) * @per_page
    filters = extract_filters(params)

    is_search = query != "" or has_filters?(filters)
    has_premium = has_premium_access?(conn)
    search_count = get_session(conn, :search_count) || 0

    # Check rate limit for non-premium users
    if not has_premium and is_search and search_count >= @max_searches_free do
      render_rate_limited(conn, query, filters, search_mode)
    else
      # Increment search count for non-premium users
      conn =
        if not has_premium and is_search do
          put_session(conn, :search_count, search_count + 1)
        else
          conn
        end

      case search_mode do
        "semantic" -> perform_semantic_search(conn, query, filters)
        _ -> perform_keyword_search(conn, query, filters, page, offset)
      end
    end
  end

  defp perform_keyword_search(conn, query, filters, page, offset) do
    # Fetch judgements and count from database
    results =
      Judgements.search_judgements(query, limit: @per_page, offset: offset, filters: filters)

    total_count = Judgements.count_search_results(query, filters)

    # Log search query
    if query != "" do
      SearchLogs.log_search(%{
        query: query,
        source: "kio",
        filters: filters,
        user_id: SearchLogs.get_user_id(conn)
      })
    end

    total_pages = ceil(total_count / @per_page)

    # Get filter options for dropdowns
    filter_options = Judgements.get_filter_options()

    # Transform to view format
    view_results = Enum.map(results, &transform_judgement/1)

    # Canonical URL without page param to avoid duplicate content
    canonical_url = build_canonical_url(query, filters)

    conn
    |> assign(
      :page_title,
      if(query != "",
        do: "#{query} — orzecznictwo KIO",
        else: "Orzecznictwo KIO — wyszukiwarka orzeczeń Krajowej Izby Odwoławczej"
      )
    )
    |> assign(:meta_description, build_search_meta_description(query, filters, total_count))
    |> assign(:canonical_url, canonical_url)
    |> assign(:og_url, canonical_url)
    |> assign(:query, query)
    |> assign(:search_mode, "keyword")
    |> assign(:filters, filters)
    |> assign(:filter_options, filter_options)
    |> assign(:results, view_results)
    |> assign(:total_count, total_count)
    |> assign(:current_page, page)
    |> assign(:total_pages, total_pages)
    |> assign(:rate_limited, false)
    |> assign(:semantic_error, nil)
    |> render(:index)
  end

  defp perform_semantic_search(conn, query, filters) do
    filter_options = Judgements.get_filter_options()

    if query == "" do
      # No query for semantic search
      conn
      |> assign(:page_title, "Orzecznictwo KIO — wyszukiwarka semantyczna z AI")
      |> assign(
        :meta_description,
        "Orzecznictwo KIO wyszukiwarka z AI — znajdź podobne wyroki Krajowej Izby Odwoławczej i orzeczenia zamówień publicznych."
      )
      |> assign(:query, query)
      |> assign(:search_mode, "semantic")
      |> assign(:filters, filters)
      |> assign(:filter_options, filter_options)
      |> assign(:results, [])
      |> assign(:total_count, 0)
      |> assign(:current_page, 1)
      |> assign(:total_pages, 0)
      |> assign(:rate_limited, false)
      |> assign(:semantic_error, nil)
      |> render(:index)
    else
      # Fetch more results to account for filtering
      fetch_limit = @semantic_results_limit * 3

      case Embeddings.search_similar(query, fetch_limit) do
        {:ok, chunks} ->
          # Transform chunks to view format with judgement info
          view_results =
            chunks
            |> transform_semantic_results()
            |> apply_filters_to_results(filters)
            |> Enum.take(@semantic_results_limit)

          # Log semantic search query
          SearchLogs.log_search(%{
            query: query,
            source: "kio",
            filters: Map.put(filters, :mode, "semantic"),
            user_id: SearchLogs.get_user_id(conn)
          })

          conn
          |> assign(:page_title, "#{query} — orzecznictwo KIO")
          |> assign(:meta_description, "Orzecznictwo KIO wyszukiwarka: semantyczne wyniki dla #{query}")
          |> assign(:query, query)
          |> assign(:search_mode, "semantic")
          |> assign(:filters, filters)
          |> assign(:filter_options, filter_options)
          |> assign(:results, view_results)
          |> assign(:total_count, length(view_results))
          |> assign(:current_page, 1)
          |> assign(:total_pages, 1)
          |> assign(:rate_limited, false)
          |> assign(:semantic_error, nil)
          |> render(:index)

        {:error, :missing_api_key} ->
          conn
          |> assign(:page_title, "Orzecznictwo KIO — wyszukiwarka")
          |> assign(:meta_description, "Orzecznictwo KIO wyszukiwarka — znajdź wyroki Krajowej Izby Odwoławczej.")
          |> assign(:query, query)
          |> assign(:search_mode, "semantic")
          |> assign(:filters, filters)
          |> assign(:filter_options, filter_options)
          |> assign(:results, [])
          |> assign(:total_count, 0)
          |> assign(:current_page, 1)
          |> assign(:total_pages, 0)
          |> assign(:rate_limited, false)
          |> assign(:semantic_error, "Wyszukiwanie semantyczne jest tymczasowo niedostępne.")
          |> render(:index)

        {:error, _reason} ->
          conn
          |> assign(:page_title, "Orzecznictwo KIO — wyszukiwarka")
          |> assign(:meta_description, "Orzecznictwo KIO wyszukiwarka — znajdź wyroki Krajowej Izby Odwoławczej.")
          |> assign(:query, query)
          |> assign(:search_mode, "semantic")
          |> assign(:filters, filters)
          |> assign(:filter_options, filter_options)
          |> assign(:results, [])
          |> assign(:total_count, 0)
          |> assign(:current_page, 1)
          |> assign(:total_pages, 0)
          |> assign(:rate_limited, false)
          |> assign(:semantic_error, "Wystąpił błąd podczas wyszukiwania. Spróbuj ponownie.")
          |> render(:index)
      end
    end
  end

  defp transform_semantic_results(chunks) do
    chunks
    |> Enum.map(fn chunk ->
      judgement = chunk.judgement

      %{
        id: judgement.id,
        signature: judgement.signature,
        slug: judgement.slug,
        decision_date: judgement.decision_date,
        document_type: judgement.document_type,
        resolution_method: judgement.resolution_method,
        contracting_authority: judgement.contracting_authority,
        meritum: judgement.meritum,
        # Include matched chunk content for semantic results
        matched_chunk: chunk.content
      }
    end)
    |> Enum.uniq_by(& &1.id)
  end

  defp apply_filters_to_results(results, filters) do
    results
    |> filter_by(:document_type, filters[:document_type])
    |> filter_by(:resolution_method, filters[:resolution_method])
    |> filter_by_date(:decision_date, filters[:date_from], filters[:date_to])
  end

  defp filter_by(results, _field, nil), do: results
  defp filter_by(results, _field, ""), do: results

  defp filter_by(results, field, value) do
    Enum.filter(results, fn result ->
      Map.get(result, field) == value
    end)
  end

  defp filter_by_date(results, _field, nil, nil), do: results
  defp filter_by_date(results, _field, "", ""), do: results

  defp filter_by_date(results, field, date_from, date_to) do
    Enum.filter(results, fn result ->
      date = Map.get(result, field)

      cond do
        is_nil(date) ->
          false

        date_from != "" and date_to != "" ->
          from = Date.from_iso8601!(date_from)
          to = Date.from_iso8601!(date_to)
          Date.compare(date, from) != :lt and Date.compare(date, to) != :gt

        date_from != "" ->
          from = Date.from_iso8601!(date_from)
          Date.compare(date, from) != :lt

        date_to != "" ->
          to = Date.from_iso8601!(date_to)
          Date.compare(date, to) != :gt

        true ->
          true
      end
    end)
  end

  defp has_premium_access?(conn) do
    case conn.assigns[:current_scope] do
      %{user: %{id: user_id}} when not is_nil(user_id) ->
        Payments.has_search_access?(user_id)

      _ ->
        false
    end
  end

  defp has_filters?(filters) do
    Enum.any?(filters, fn {_k, v} -> v != "" end)
  end

  defp render_rate_limited(conn, query, filters, search_mode) do
    filter_options = Judgements.get_filter_options()

    conn
    |> assign(:page_title, "Orzecznictwo KIO — wyszukiwarka orzeczeń Krajowej Izby Odwoławczej")
    |> assign(
      :meta_description,
      "Orzecznictwo KIO wyszukiwarka — wyroki i orzeczenia Krajowej Izby Odwoławczej, zamówienia publiczne."
    )
    |> assign(:query, query)
    |> assign(:search_mode, search_mode)
    |> assign(:filters, filters)
    |> assign(:filter_options, filter_options)
    |> assign(:results, [])
    |> assign(:total_count, 0)
    |> assign(:current_page, 1)
    |> assign(:total_pages, 0)
    |> assign(:rate_limited, true)
    |> assign(:semantic_error, nil)
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

  defp build_search_meta_description(query, filters, total_count) do
    base =
      "Orzecznictwo KIO wyszukiwarka — wyroki Krajowej Izby Odwoławczej, zamówienia publiczne"

    cond do
      query != "" ->
        "#{base}. Wyniki dla: #{query}"

      filters[:document_type] != "" ->
        "#{base}. Filtr: #{filters[:document_type]}"

      true ->
        "#{base}. Przeglądaj #{total_count} orzeczeń w bazie."
    end
  end
end
