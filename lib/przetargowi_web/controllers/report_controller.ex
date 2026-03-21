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
      "#{result.total_count} raportów i analiz rynku zamówień publicznych w Polsce. Statystyki przetargów według regionów i branż."
    )
    |> assign(:canonical_url, "https://przetargowi.pl/raporty")
    |> assign(:breadcrumbs, [
      %{name: "Strona główna", url: "https://przetargowi.pl"},
      %{name: "Raporty", url: "https://przetargowi.pl/raporty"}
    ])
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
      "#{result.total_count} raportów i analiz przetargów w województwie #{region_name}. Statystyki zamówień publicznych."
    )
    |> assign(:canonical_url, "https://przetargowi.pl/raporty/#{region}")
    |> assign(:breadcrumbs, [
      %{name: "Strona główna", url: "https://przetargowi.pl"},
      %{name: "Raporty", url: "https://przetargowi.pl/raporty"},
      %{name: "Woj. #{region_name}", url: "https://przetargowi.pl/raporty/#{region}"}
    ])
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
        meta_description = build_report_meta_description(report)

        conn
        |> assign(:page_title, report.title)
        |> assign(:meta_description, meta_description)
        |> assign(:canonical_url, canonical_url)
        |> assign(:og_url, canonical_url)
        |> assign(:og_image, report.cover_image_url)
        |> assign(:og_type, "article")
        |> assign(:breadcrumbs, build_report_breadcrumbs(report))
        |> assign(:article_json_ld, build_article_json_ld(report, canonical_url))
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

  defp build_report_meta_description(report) do
    if report.meta_description do
      report.meta_description
    else
      base = "Raport: #{report.title}"

      region_part =
        if report.region do
          region_name = Map.get(@region_names, report.region, report.region)
          " | Woj. #{region_name}"
        else
          ""
        end

      month_part =
        if report.report_month do
          " | #{format_month(report.report_month)}"
        else
          ""
        end

      String.slice(base <> region_part <> month_part, 0, 160)
    end
  end

  defp format_month(date) do
    months =
      ~w(styczeń luty marzec kwiecień maj czerwiec lipiec sierpień wrzesień październik listopad grudzień)

    month_name = Enum.at(months, date.month - 1)
    "#{month_name} #{date.year}"
  end

  defp build_report_breadcrumbs(report) do
    base = [
      %{name: "Strona główna", url: "https://przetargowi.pl"},
      %{name: "Raporty", url: "https://przetargowi.pl/raporty"}
    ]

    region_crumb =
      if report.region do
        region_name = Map.get(@region_names, report.region, report.region)

        [
          %{
            name: "Woj. #{region_name}",
            url: "https://przetargowi.pl/raporty/#{report.region}"
          }
        ]
      else
        []
      end

    base ++
      region_crumb ++
      [%{name: report.title, url: "https://przetargowi.pl/raporty/#{report.slug}"}]
  end

  defp build_article_json_ld(report, canonical_url) do
    %{
      "@context" => "https://schema.org",
      "@type" => "Article",
      "headline" => report.title,
      "description" => report.meta_description || "Raport: #{report.title}",
      "url" => canonical_url,
      "datePublished" => Date.to_iso8601(report.inserted_at),
      "dateModified" => Date.to_iso8601(report.updated_at),
      "publisher" => %{
        "@type" => "Organization",
        "name" => "Przetargowi.pl",
        "url" => "https://przetargowi.pl"
      },
      "author" => %{
        "@type" => "Organization",
        "name" => "Przetargowi.pl"
      }
    }
    |> maybe_add_image(report.cover_image_url)
  end

  defp maybe_add_image(json_ld, nil), do: json_ld
  defp maybe_add_image(json_ld, url), do: Map.put(json_ld, "image", url)
end
