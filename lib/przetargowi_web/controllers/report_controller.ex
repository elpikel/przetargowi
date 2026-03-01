defmodule PrzetargowiWeb.ReportController do
  @moduledoc """
  Controller for displaying tender reports.
  """
  use PrzetargowiWeb, :controller

  alias Przetargowi.Reports

  @valid_regions ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

  def index(conn, params) do
    page = parse_page(params["page"])
    query = params["q"] || ""

    search_opts = [
      query: query,
      page: page,
      per_page: 12
    ]

    result = Reports.list_tender_reports(search_opts)

    conn
    |> render(:index,
      reports: result.reports,
      total_count: result.total_count,
      page: result.page,
      total_pages: result.total_pages,
      query: query
    )
  end

  def show(conn, %{"slug" => slug} = params) do
    # Check if slug is a valid region - if so, show regional reports
    if slug in @valid_regions do
      show_region(conn, slug, params)
    else
      show_report(conn, slug)
    end
  end

  defp show_region(conn, region, params) do
    page = parse_page(params["page"])

    search_opts = [
      page: page,
      per_page: 12
    ]

    result = Reports.list_tender_reports_by_region(region, search_opts)

    conn
    |> assign(:region, region)
    |> render(:index,
      reports: result.reports,
      total_count: result.total_count,
      page: result.page,
      total_pages: result.total_pages,
      query: ""
    )
  end

  defp show_report(conn, slug) do
    case Reports.get_report_by_slug(slug) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(html: PrzetargowiWeb.ErrorHTML)
        |> render(:"404")

      report ->
        render(conn, :show, report: report)
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
