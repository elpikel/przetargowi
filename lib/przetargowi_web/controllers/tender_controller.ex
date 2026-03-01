defmodule PrzetargowiWeb.TenderController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Tenders

  @valid_regions ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

  def index(conn, params) do
    page = parse_page(params["page"])

    regions = params["regions"] || []
    order_types = params["order_types"] || []

    search_opts = [
      query: params["q"],
      regions: regions,
      order_types: order_types,
      page: page,
      per_page: 20
    ]

    result = Tenders.search_tender_notices(search_opts)

    conn
    |> render(:index,
      notices: result.notices,
      total_count: result.total_count,
      page: result.page,
      total_pages: result.total_pages,
      query: params["q"] || "",
      regions: regions,
      order_types: order_types
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

  defp show_region(conn, region, params) do
    page = parse_page(params["page"])

    search_opts = [
      query: params["q"],
      regions: [region],
      order_types: params["order_types"] || [],
      page: page,
      per_page: 20
    ]

    result = Tenders.search_tender_notices(search_opts)

    conn
    |> render(:index,
      notices: result.notices,
      total_count: result.total_count,
      page: result.page,
      total_pages: result.total_pages,
      query: params["q"] || "",
      regions: [region],
      order_types: params["order_types"] || []
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

        render(conn, :show,
          tender: tender,
          is_expired: is_expired,
          related_contract_notice: related_contract_notice
        )
    end
  end

  defp parse_page(nil), do: 1

  defp parse_page(page) when is_binary(page) do
    case Integer.parse(page) do
      {num, _} when num > 0 -> num
      _ -> 1
    end
  end

  defp parse_page(_), do: 1
end
