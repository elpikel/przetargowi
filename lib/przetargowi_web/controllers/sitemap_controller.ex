defmodule PrzetargowiWeb.SitemapController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Blog
  alias Przetargowi.Judgements
  alias Przetargowi.Reports
  alias Przetargowi.SitemapCache
  alias Przetargowi.Tenders.Hubs

  @base_url "https://przetargowi.pl"
  @urls_per_sitemap 2_000

  @regions ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

  # Sitemap index - lists all sub-sitemaps
  def index(conn, _params) do
    xml = cached("index", 3600, &build_sitemap_index/0)

    conn
    |> put_resp_content_type("application/xml")
    |> put_resp_header("cache-control", "public, max-age=3600")
    |> send_resp(200, xml)
  end

  # Static pages sitemap
  def static(conn, _params) do
    xml = cached("static", 86_400, &build_static_sitemap/0)

    conn
    |> put_resp_content_type("application/xml")
    |> put_resp_header("cache-control", "public, max-age=86400")
    |> send_resp(200, xml)
  end

  # Judgements sitemap (paginated)
  def judgements(conn, %{"page" => page_str}) do
    case Integer.parse(page_str) do
      {page, ""} when page >= 1 ->
        xml = cached("judgements:#{page}", 3600, fn -> build_judgements_sitemap(page) end)

        conn
        |> put_resp_content_type("application/xml")
        |> put_resp_header("cache-control", "public, max-age=3600")
        |> send_resp(200, xml)

      _ ->
        send_resp(conn, 404, "Not found")
    end
  end

  # Reports sitemap (paginated)
  def reports(conn, %{"page" => page_str}) do
    case Integer.parse(page_str) do
      {page, ""} when page >= 1 ->
        xml = cached("reports:#{page}", 3600, fn -> build_reports_sitemap(page) end)

        conn
        |> put_resp_content_type("application/xml")
        |> put_resp_header("cache-control", "public, max-age=3600")
        |> send_resp(200, xml)

      _ ->
        send_resp(conn, 404, "Not found")
    end
  end

  # Cache helper - returns cached XML or generates and caches it
  defp cached(key, ttl, generator) do
    case SitemapCache.get(key) do
      {:ok, xml} ->
        xml

      :miss ->
        xml = generator.()
        SitemapCache.put(key, xml, ttl)
        xml
    end
  end

  # Build sitemap index listing all sub-sitemaps
  defp build_sitemap_index do
    judgement_pages = ceil(Judgements.count_sitemap_entries() / @urls_per_sitemap)
    report_pages = ceil(Reports.count_sitemap_entries() / @urls_per_sitemap)

    judgement_lastmods = Judgements.sitemap_lastmods(@urls_per_sitemap)
    report_lastmods = Reports.sitemap_lastmods(@urls_per_sitemap)

    today = Date.to_iso8601(Date.utc_today())

    # Individual tender pages are intentionally excluded — they are noindex, so
    # advertising them in the sitemap sends Google a contradictory signal.
    # Category hubs and regions (in sitemap-static.xml) are the tender surface.
    sitemaps =
      [{"#{@base_url}/sitemap-static.xml", Date.utc_today()}] ++
        for(
          page <- 1..max(judgement_pages, 1),
          do:
            {"#{@base_url}/sitemap/judgements/#{page}",
             format_date(judgement_lastmods[page]) || today}
        ) ++
        for(
          page <- 1..max(report_pages, 1),
          do:
            {"#{@base_url}/sitemap/reports/#{page}", format_date(report_lastmods[page]) || today}
        )

    """
    <?xml version="1.0" encoding="UTF-8"?>
    <sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    #{Enum.map_join(sitemaps, "\n", &sitemap_entry/1)}
    </sitemapindex>
    """
  end

  defp sitemap_entry({loc, %Date{} = lastmod}) do
    sitemap_entry({loc, Date.to_iso8601(lastmod)})
  end

  defp sitemap_entry({loc, lastmod}) when is_binary(lastmod) do
    """
      <sitemap>
        <loc>#{loc}</loc>
        <lastmod>#{lastmod}</lastmod>
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
      %{loc: "#{@base_url}/analiza-rynku", priority: "0.8", changefreq: "weekly"},
      %{loc: "#{@base_url}/ustawa-pzp", priority: "0.8", changefreq: "yearly"},
      %{loc: "#{@base_url}/blog", priority: "0.8", changefreq: "weekly"},
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

    hub_urls =
      Enum.map(Hubs.all_paths(), fn path ->
        %{loc: "#{@base_url}#{path}", priority: "0.8", changefreq: "daily"}
      end)

    blog_urls =
      Blog.list_sitemap_entries()
      |> Enum.map(fn entry ->
        %{
          loc: "#{@base_url}/blog/#{entry.slug}",
          lastmod: format_date(entry.updated_at),
          priority: "0.7",
          changefreq: "monthly"
        }
      end)

    urls = static_urls ++ region_urls ++ hub_urls ++ blog_urls
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
