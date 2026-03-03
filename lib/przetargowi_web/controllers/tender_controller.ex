defmodule PrzetargowiWeb.TenderController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Alerts
  alias Przetargowi.Payments
  alias Przetargowi.Tenders

  @valid_regions ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

  def index(conn, params) do
    page = parse_page(params["page"])

    regions = params["regions"] || []
    order_types = params["order_types"] || []
    deadline_from = parse_date(params["deadline_from"])
    deadline_to = parse_date(params["deadline_to"])

    search_opts = [
      query: params["q"],
      regions: regions,
      order_types: order_types,
      deadline_from: deadline_from,
      deadline_to: deadline_to,
      page: page,
      per_page: 20
    ]

    result = Tenders.search_tender_notices(search_opts)

    # Check if user can create alerts
    {can_create_alert, is_premium} = get_alert_permissions(conn)

    conn
    |> assign(:page_title, "Przetargi publiczne")
    |> assign(
      :meta_description,
      "Aktualne przetargi publiczne z Biuletynu Zamówień Publicznych. Przeglądaj #{result.total_count} aktywnych ogłoszeń."
    )
    |> assign(:canonical_url, "https://przetargowi.pl/przetargi")
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
      can_create_alert: can_create_alert,
      is_premium: is_premium
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

    search_opts = [
      query: params["q"],
      regions: [region],
      order_types: params["order_types"] || [],
      deadline_from: deadline_from,
      deadline_to: deadline_to,
      page: page,
      per_page: 20
    ]

    result = Tenders.search_tender_notices(search_opts)
    region_name = Map.get(@region_names, region, region)

    # Check if user can create alerts
    {can_create_alert, is_premium} = get_alert_permissions(conn)

    conn
    |> assign(:page_title, "Przetargi #{region_name}")
    |> assign(
      :meta_description,
      "Przetargi publiczne w województwie #{region_name}. #{result.total_count} aktywnych ogłoszeń z BZP."
    )
    |> assign(:canonical_url, "https://przetargowi.pl/przetargi/#{region}")
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
      can_create_alert: can_create_alert,
      is_premium: is_premium
    )
  end

  defp show_tender(conn, slug) do
    case Tenders.get_tender_by_slug(slug) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(html: PrzetargowiWeb.ErrorHTML)
        |> render(:"404")

      tender ->
        is_expired =
          tender.submitting_offers_date &&
            DateTime.before?(tender.submitting_offers_date, DateTime.utc_now())

        # Get related contract notice if this is not a ContractNotice
        related_contract_notice =
          if tender.notice_type != "ContractNotice" && tender.tender_id do
            Tenders.get_contract_notice_by_tender_id(tender.tender_id)
          else
            nil
          end

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

        conn
        |> assign(:page_title, page_title)
        |> assign(:meta_description, meta_description)
        |> assign(:canonical_url, canonical_url)
        |> assign(:og_url, canonical_url)
        |> render(:show,
          tender: tender,
          is_expired: is_expired,
          related_contract_notice: related_contract_notice,
          documents: documents
        )
    end
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

  defp get_alert_permissions(conn) do
    case conn.assigns[:current_scope] do
      nil ->
        {false, false}

      scope ->
        user = scope.user
        is_premium = Payments.has_alerts_access?(user.id)
        can_create = is_premium or Alerts.can_create_free_alert?(user.id)
        {can_create, is_premium}
    end
  end
end
