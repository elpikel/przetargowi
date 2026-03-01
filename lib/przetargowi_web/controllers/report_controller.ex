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
    |> assign(:page_title, "Raporty przetargowe")
    |> assign(
      :meta_description,
      "Analizy i raporty rynku zamówień publicznych w Polsce. Statystyki przetargów według regionów i branż."
    )
    |> assign(:canonical_url, "https://przetargowi.pl/raporty")
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

    search_opts = [
      page: page,
      per_page: 12
    ]

    result = Reports.list_tender_reports_by_region(region, search_opts)
    region_name = Map.get(@region_names, region, region)

    conn
    |> assign(:region, region)
    |> assign(:page_title, "Raporty #{region_name}")
    |> assign(
      :meta_description,
      "Raporty i analizy przetargów w województwie #{region_name}."
    )
    |> assign(:canonical_url, "https://przetargowi.pl/raporty/#{region}")
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
        canonical_url = "https://przetargowi.pl/raporty/#{report.slug}"

        conn
        |> assign(:page_title, report.title)
        |> assign(:meta_description, report.meta_description || "Raport: #{report.title}")
        |> assign(:canonical_url, canonical_url)
        |> assign(:og_url, canonical_url)
        |> render(:show, report: report)
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
