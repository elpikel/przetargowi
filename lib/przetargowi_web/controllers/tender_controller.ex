defmodule PrzetargowiWeb.TenderController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.SearchLogs
  alias Przetargowi.Tenders
  alias Przetargowi.Tenders.Hubs
  alias Przetargowi.Watchlist

  @valid_regions ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

  def index(conn, params) do
    page = parse_page(params["page"])

    regions = params["regions"] || []
    order_types = params["order_types"] || []
    deadline_from = parse_date(params["deadline_from"])
    deadline_to = parse_date(params["deadline_to"])
    with_winner_analysis = params["with_winner_analysis"] == "1"

    search_opts = [
      query: params["q"],
      regions: regions,
      order_types: order_types,
      deadline_from: deadline_from,
      deadline_to: deadline_to,
      with_winner_analysis: with_winner_analysis,
      page: page,
      per_page: 20
    ]

    result = Tenders.search_tender_notices(search_opts)

    # Log search query
    if params["q"] && params["q"] != "" do
      SearchLogs.log_search(%{
        query: params["q"],
        source: "tenders",
        filters: %{
          regions: regions,
          order_types: order_types,
          deadline_from: params["deadline_from"],
          deadline_to: params["deadline_to"]
        },
        user_id: SearchLogs.get_user_id(conn)
      })
    end

    # Check if user can create alerts
    {can_create_alert, is_premium} = get_alert_permissions(conn)

    # Get watchlist data for logged-in users
    {watched_ids, can_add_to_watchlist} = get_watchlist_data(conn)

    conn
    |> assign(:page_title, "Aktualne przetargi publiczne — wyszukiwarka przetargów")
    |> assign(
      :meta_description,
      "Wyszukiwarka przetargów publicznych — #{result.total_count} aktualnych ogłoszeń o przetargach z BZP. Przeglądaj oferty przetargowe i składaj wnioski."
    )
    |> then(fn conn ->
      has_filters =
        regions != [] or order_types != [] or deadline_from != nil or
          deadline_to != nil or with_winner_analysis or (params["q"] || "") != ""

      cond do
        has_filters ->
          conn
          |> assign(:meta_robots, "noindex, follow")

        page > 1 ->
          conn
          |> assign(:canonical_url, "https://przetargowi.pl/przetargi?page=#{page}")
          |> assign(:meta_robots, "noindex, follow")

        true ->
          assign(conn, :canonical_url, "https://przetargowi.pl/przetargi")
      end
    end)
    |> render(:index,
      notices: result.notices,
      total_count: result.total_count,
      page: result.page,
      total_pages: result.total_pages,
      query: params["q"] || "",
      regions: regions,
      order_types: order_types,
      deadline_from: params["deadline_from"] || "",
      deadline_to: params["deadline_to"] || "",
      with_winner_analysis: with_winner_analysis,
      can_create_alert: can_create_alert,
      is_premium: is_premium,
      watched_ids: watched_ids,
      can_add_to_watchlist: can_add_to_watchlist
    )
  end

  def show(conn, %{"slug" => slug} = params) do
    # Check if slug is a valid region - if so, show regional tenders
    if slug in @valid_regions do
      show_region(conn, slug, params)
    else
      show_tender(conn, slug)
    end
  end

  # Category hub by order type (roboty budowlane / dostawy / usługi)
  def hub_order_type(conn, %{"slug" => slug} = params) do
    case Hubs.order_type_hub(slug) do
      nil ->
        render_404(conn)

      hub ->
        render_hub(
          conn,
          params,
          [order_types: [hub.order_type]],
          hub,
          "/przetargi/rodzaj/#{slug}"
        )
    end
  end

  # Category hub by CPV industry (budowlane / medyczne / IT / ...)
  def hub_category(conn, %{"slug" => slug} = params) do
    case Hubs.category_hub(slug) do
      nil ->
        render_404(conn)

      hub ->
        render_hub(
          conn,
          params,
          [cpv_prefixes: hub.cpv_prefixes],
          hub,
          "/przetargi/branza/#{slug}"
        )
    end
  end

  defp render_hub(conn, params, filter_opts, hub, path) do
    page = parse_page(params["page"])

    search_opts =
      Keyword.merge(
        [query: nil, regions: [], order_types: [], page: page, per_page: 20],
        filter_opts
      )

    result = Tenders.search_tender_notices(search_opts)

    {can_create_alert, is_premium} = get_alert_permissions(conn)
    {watched_ids, can_add_to_watchlist} = get_watchlist_data(conn)

    canonical =
      if page > 1,
        do: "https://przetargowi.pl#{path}?page=#{page}",
        else: "https://przetargowi.pl#{path}"

    conn
    |> assign(:page_title, hub.page_title)
    |> assign(:meta_description, hub.meta_description)
    |> assign(:canonical_url, canonical)
    |> then(fn conn ->
      if page > 1, do: assign(conn, :meta_robots, "noindex, follow"), else: conn
    end)
    |> assign(:hub_title, hub.h1)
    |> assign(:hub_intro, hub.intro)
    |> render(:index,
      notices: result.notices,
      total_count: result.total_count,
      page: result.page,
      total_pages: result.total_pages,
      query: "",
      regions: [],
      order_types: Keyword.get(search_opts, :order_types, []),
      deadline_from: "",
      deadline_to: "",
      with_winner_analysis: false,
      can_create_alert: can_create_alert,
      is_premium: is_premium,
      watched_ids: watched_ids,
      can_add_to_watchlist: can_add_to_watchlist
    )
  end

  defp render_404(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(html: PrzetargowiWeb.ErrorHTML)
    |> render(:"404")
  end

  @region_names %{
    "dolnoslaskie" => "dolnośląskie",
    "kujawsko-pomorskie" => "kujawsko-pomorskie",
    "lubelskie" => "lubelskie",
    "lubuskie" => "lubuskie",
    "lodzkie" => "łódzkie",
    "malopolskie" => "małopolskie",
    "mazowieckie" => "mazowieckie",
    "opolskie" => "opolskie",
    "podkarpackie" => "podkarpackie",
    "podlaskie" => "podlaskie",
    "pomorskie" => "pomorskie",
    "slaskie" => "śląskie",
    "swietokrzyskie" => "świętokrzyskie",
    "warminsko-mazurskie" => "warmińsko-mazurskie",
    "wielkopolskie" => "wielkopolskie",
    "zachodniopomorskie" => "zachodniopomorskie"
  }

  defp show_region(conn, region, params) do
    page = parse_page(params["page"])
    deadline_from = parse_date(params["deadline_from"])
    deadline_to = parse_date(params["deadline_to"])
    with_winner_analysis = params["with_winner_analysis"] == "1"

    search_opts = [
      query: params["q"],
      regions: [region],
      order_types: params["order_types"] || [],
      deadline_from: deadline_from,
      deadline_to: deadline_to,
      with_winner_analysis: with_winner_analysis,
      page: page,
      per_page: 20
    ]

    result = Tenders.search_tender_notices(search_opts)
    region_name = Map.get(@region_names, region, region)

    # Log search query
    if params["q"] && params["q"] != "" do
      SearchLogs.log_search(%{
        query: params["q"],
        source: "tenders",
        filters: %{
          regions: [region],
          order_types: params["order_types"] || [],
          deadline_from: params["deadline_from"],
          deadline_to: params["deadline_to"]
        },
        user_id: SearchLogs.get_user_id(conn)
      })
    end

    # Check if user can create alerts
    {can_create_alert, is_premium} = get_alert_permissions(conn)

    # Get watchlist data for logged-in users
    {watched_ids, can_add_to_watchlist} = get_watchlist_data(conn)

    conn
    |> assign(:page_title, "Przetargi #{region_name}")
    |> assign(
      :meta_description,
      "Przetargi publiczne w województwie #{region_name}. #{result.total_count} aktywnych ogłoszeń z BZP."
    )
    |> then(fn conn ->
      has_filters =
        (params["q"] || "") != "" or (params["order_types"] || []) != [] or
          deadline_from != nil or deadline_to != nil or with_winner_analysis

      cond do
        has_filters ->
          assign(conn, :meta_robots, "noindex, follow")

        page > 1 ->
          conn
          |> assign(:canonical_url, "https://przetargowi.pl/przetargi/#{region}?page=#{page}")
          |> assign(:meta_robots, "noindex, follow")

        true ->
          assign(conn, :canonical_url, "https://przetargowi.pl/przetargi/#{region}")
      end
    end)
    |> render(:index,
      notices: result.notices,
      total_count: result.total_count,
      page: result.page,
      total_pages: result.total_pages,
      query: params["q"] || "",
      regions: [region],
      order_types: params["order_types"] || [],
      deadline_from: params["deadline_from"] || "",
      deadline_to: params["deadline_to"] || "",
      with_winner_analysis: with_winner_analysis,
      can_create_alert: can_create_alert,
      is_premium: is_premium,
      watched_ids: watched_ids,
      can_add_to_watchlist: can_add_to_watchlist
    )
  end

  defp show_tender(conn, slug) do
    case Tenders.get_tender_by_slug(slug) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(html: PrzetargowiWeb.ErrorHTML)
        |> render(:"404")

      notice ->
        # A procurement can have several notices (ContractNotice + result notice
        # etc.) sharing a tender_id. Merge them onto one canonical page and
        # 301-redirect the non-canonical notice URLs to it.
        notices =
          case notice.tender_id do
            nil -> [notice]
            tender_id -> Tenders.get_notices_by_tender_id(tender_id)
          end

        canonical = Tenders.canonical_notice(notices) || notice

        if canonical.slug != notice.slug do
          conn
          |> put_status(:moved_permanently)
          |> redirect(to: ~p"/przetargi/#{canonical.slug}")
        else
          render_tender(conn, canonical, notices)
        end
    end
  end

  defp render_tender(conn, tender, notices) do
    is_expired =
      tender.submitting_offers_date != nil &&
        DateTime.before?(tender.submitting_offers_date, DateTime.utc_now())

    # Result/award data lives on a sibling notice (Ogłoszenie o wyniku).
    result_notice = Tenders.find_result_notice(notices)

    # Get documents for this tender
    documents =
      if tender.tender_id do
        Tenders.get_documents_by_tender_id(tender.tender_id)
      else
        []
      end

    canonical_url = "https://przetargowi.pl/przetargi/#{tender.slug}"
    page_title = truncate_title(tender.order_object)
    meta_description = build_tender_meta_description(tender)

    # Get watchlist status for logged-in users
    {is_watching, can_add_to_watchlist, watchlist_entry_id} =
      get_watchlist_status(conn, tender.object_id)

    # Get precomputed winner analysis and premium status
    similar_winners = Tenders.get_winner_analysis(tender)
    is_premium = check_premium(conn)

    conn
    |> assign(:page_title, page_title)
    |> assign(:meta_description, meta_description)
    |> assign(:canonical_url, canonical_url)
    |> assign(:og_url, canonical_url)
    # Individual tender pages carry no unique search value at scale (they mirror
    # the BZP notice). We keep them crawlable (follow) for on-site users but
    # steer indexing to the category hubs, regions, blog and KIO instead.
    |> assign(:meta_robots, "noindex, follow")
    |> render(:show,
      tender: tender,
      is_expired: is_expired,
      result_notice: result_notice,
      documents: documents,
      is_watching: is_watching,
      can_add_to_watchlist: can_add_to_watchlist,
      watchlist_entry_id: watchlist_entry_id,
      similar_winners: similar_winners,
      is_premium: is_premium
    )
  end

  defp truncate_title(nil), do: "Przetarg"

  defp truncate_title(title) when byte_size(title) > 60 do
    String.slice(title, 0, 57) <> "..."
  end

  defp truncate_title(title), do: title

  defp build_tender_meta_description(tender) do
    base = "Przetarg: #{truncate_title(tender.order_object)}"
    org = if tender.organization_name, do: " | #{tender.organization_name}", else: ""
    city = if tender.organization_city, do: ", #{tender.organization_city}", else: ""
    String.slice(base <> org <> city, 0, 160)
  end

  defp parse_page(nil), do: 1

  defp parse_page(page) when is_binary(page) do
    case Integer.parse(page) do
      {num, _} when num > 0 -> num
      _ -> 1
    end
  end

  defp parse_page(_), do: 1

  defp parse_date(nil), do: nil
  defp parse_date(""), do: nil

  defp parse_date(date_string) when is_binary(date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} -> date
      _ -> nil
    end
  end

  defp parse_date(_), do: nil

  # Alerts are free for every logged-in user. can_create is true when there is a
  # user in scope; is_premium is kept for template compatibility and is always
  # true (all features are free).
  defp get_alert_permissions(conn) do
    case conn.assigns[:current_scope] do
      nil -> {false, false}
      _scope -> {true, true}
    end
  end

  defp get_watchlist_data(conn) do
    case conn.assigns[:current_scope] do
      nil ->
        {[], false}

      scope ->
        watched_ids = Watchlist.get_watched_tender_ids(scope.user.id)
        {watched_ids, true}
    end
  end

  defp get_watchlist_status(conn, tender_object_id) do
    case conn.assigns[:current_scope] do
      nil ->
        {false, false, nil}

      scope ->
        entry = Watchlist.get_entry_by_tender(scope.user.id, tender_object_id)
        is_watching = entry != nil
        entry_id = if entry, do: entry.id, else: nil
        {is_watching, true, entry_id}
    end
  end

  # Competitor/winner analysis is free for everyone.
  defp check_premium(_conn), do: true
end
