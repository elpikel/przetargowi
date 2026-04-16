defmodule PrzetargowiWeb.SitemapController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements
  alias Przetargowi.Reports
  alias Przetargowi.Tenders

  @base_url "https://przetargowi.pl"
  @urls_per_sitemap 200

  @regions ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

  # Sitemap index - lists all sub-sitemaps
  def index(conn, _params) do
    conn
    |> put_resp_content_type("application/xml")
    |> put_resp_header("cache-control", "public, max-age=3600")
    |> send_resp(200, build_sitemap_index())
  end

  # Static pages sitemap
  def static(conn, _params) do
    conn
    |> put_resp_content_type("application/xml")
    |> put_resp_header("cache-control", "public, max-age=86400")
    |> send_resp(200, build_static_sitemap())
  end

  # Judgements sitemap (paginated)
  def judgements(conn, %{"page" => page_str}) do
    case Integer.parse(page_str) do
      {page, ""} when page >= 1 ->
        conn
        |> put_resp_content_type("application/xml")
        |> put_resp_header("cache-control", "public, max-age=3600")
        |> send_resp(200, build_judgements_sitemap(page))

      _ ->
        send_resp(conn, 404, "Not found")
    end
  end

  # Tenders sitemap (paginated)
  def tenders(conn, %{"page" => page_str}) do
    case Integer.parse(page_str) do
      {page, ""} when page >= 1 ->
        conn
        |> put_resp_content_type("application/xml")
        |> put_resp_header("cache-control", "public, max-age=3600")
        |> send_resp(200, build_tenders_sitemap(page))

      _ ->
        send_resp(conn, 404, "Not found")
    end
  end

  # Reports sitemap (paginated)
  def reports(conn, %{"page" => page_str}) do
    case Integer.parse(page_str) do
      {page, ""} when page >= 1 ->
        conn
        |> put_resp_content_type("application/xml")
        |> put_resp_header("cache-control", "public, max-age=3600")
        |> send_resp(200, build_reports_sitemap(page))

      _ ->
        send_resp(conn, 404, "Not found")
    end
  end

  # Build sitemap index listing all sub-sitemaps
  defp build_sitemap_index do
    judgement_pages = ceil(Judgements.count_sitemap_entries() / @urls_per_sitemap)
    tender_pages = ceil(Tenders.count_sitemap_entries() / @urls_per_sitemap)
    report_pages = ceil(Reports.count_sitemap_entries() / @urls_per_sitemap)

    sitemaps =
      [{"#{@base_url}/sitemap-static.xml", Date.utc_today()}] ++
        for(page <- 1..max(judgement_pages, 1), do: {"#{@base_url}/sitemap/judgements/#{page}", Date.utc_today()}) ++
        for(page <- 1..max(tender_pages, 1), do: {"#{@base_url}/sitemap/tenders/#{page}", Date.utc_today()}) ++
        for(page <- 1..max(report_pages, 1), do: {"#{@base_url}/sitemap/reports/#{page}", Date.utc_today()})

    """
    <?xml version="1.0" encoding="UTF-8"?>
    <sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    #{Enum.map_join(sitemaps, "\n", &sitemap_entry/1)}
    </sitemapindex>
    """
  end

  defp sitemap_entry({loc, lastmod}) do
    """
      <sitemap>
        <loc>#{loc}</loc>
        <lastmod>#{Date.to_iso8601(lastmod)}</lastmod>
      </sitemap>
    """
  end

  # Build static pages sitemap
  defp build_static_sitemap do
    static_urls = [
      %{loc: @base_url, priority: "1.0", changefreq: "daily"},
      %{loc: "#{@base_url}/orzecznictwo-kio", priority: "0.9", changefreq: "weekly"},
      %{loc: "#{@base_url}/szukaj", priority: "0.9", changefreq: "daily"},
      %{loc: "#{@base_url}/przetargi", priority: "0.9", changefreq: "daily"},
      %{loc: "#{@base_url}/raporty", priority: "0.7", changefreq: "weekly"},
      %{loc: "#{@base_url}/o-nas", priority: "0.5", changefreq: "monthly"},
      %{loc: "#{@base_url}/kontakt", priority: "0.5", changefreq: "monthly"},
      %{loc: "#{@base_url}/regulamin", priority: "0.3", changefreq: "yearly"},
      %{loc: "#{@base_url}/polityka-prywatnosci", priority: "0.3", changefreq: "yearly"}
    ]

    region_urls =
      Enum.map(@regions, fn region ->
        %{loc: "#{@base_url}/przetargi/#{region}", priority: "0.7", changefreq: "daily"}
      end)

    urls = static_urls ++ region_urls
    build_urlset(urls)
  end

  # Build judgements sitemap for a specific page
  defp build_judgements_sitemap(page) do
    offset = (page - 1) * @urls_per_sitemap

    urls =
      Judgements.list_sitemap_entries(@urls_per_sitemap, offset)
      |> Enum.map(fn entry ->
        %{
          loc: "#{@base_url}/orzeczenie/#{entry.slug}",
          lastmod: format_date(entry.updated_at),
          priority: "0.8",
          changefreq: "monthly"
        }
      end)

    build_urlset(urls)
  end

  # Build tenders sitemap for a specific page
  defp build_tenders_sitemap(page) do
    offset = (page - 1) * @urls_per_sitemap

    urls =
      Tenders.list_sitemap_entries(@urls_per_sitemap, offset)
      |> Enum.map(fn entry ->
        %{
          loc: "#{@base_url}/przetargi/#{entry.slug}",
          lastmod: format_date(entry.updated_at),
          priority: "0.7",
          changefreq: "weekly"
        }
      end)

    build_urlset(urls)
  end

  # Build reports sitemap for a specific page
  defp build_reports_sitemap(page) do
    offset = (page - 1) * @urls_per_sitemap

    urls =
      Reports.list_sitemap_entries(@urls_per_sitemap, offset)
      |> Enum.map(fn entry ->
        %{
          loc: "#{@base_url}/raporty/#{entry.slug}",
          lastmod: format_date(entry.updated_at),
          priority: "0.6",
          changefreq: "monthly"
        }
      end)

    build_urlset(urls)
  end

  defp build_urlset(urls) do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    #{Enum.map_join(urls, "\n", &url_entry/1)}
    </urlset>
    """
  end

  defp url_entry(entry) do
    lastmod = if entry[:lastmod], do: "    <lastmod>#{entry.lastmod}</lastmod>\n", else: ""

    """
      <url>
        <loc>#{entry.loc}</loc>
    #{lastmod}    <changefreq>#{entry.changefreq}</changefreq>
        <priority>#{entry.priority}</priority>
      </url>
    """
  end

  defp format_date(nil), do: nil

  defp format_date(%DateTime{} = dt) do
    Calendar.strftime(dt, "%Y-%m-%d")
  end

  defp format_date(%NaiveDateTime{} = dt) do
    Calendar.strftime(dt, "%Y-%m-%d")
  end
end
