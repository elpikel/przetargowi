defmodule PrzetargowiWeb.SitemapController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Blog
  alias Przetargowi.Judgements
  alias Przetargowi.Judgements.Topics
  alias Przetargowi.Reports
  alias Przetargowi.SitemapCache
  alias Przetargowi.Tenders
  alias Przetargowi.Tenders.Hubs
  alias PrzetargowiWeb.Indexing

  @base_url "https://przetargowi.pl"
  @urls_per_sitemap 2_000

  @regions ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

  # /sitemap.xml. With detail pages out of the index (the default, see
  # PrzetargowiWeb.Indexing) every indexable URL fits in one file, so this is
  # the whole sitemap. If rulings or reports are switched back on it becomes a
  # sitemap index pointing at the page list plus their paginated sitemaps.
  def index(conn, _params) do
    xml =
      if Indexing.any_detail_pages?(),
        do: cached("index", 3600, &build_sitemap_index/0),
        else: cached("static", 3600, &build_static_sitemap/0)

    send_xml(conn, xml, 3600)
  end

  # The page list as its own file — only needed while /sitemap.xml is an index.
  def static(conn, _params) do
    if Indexing.any_detail_pages?(),
      do: send_xml(conn, cached("static", 3600, &build_static_sitemap/0), 3600),
      else: conn |> put_status(:moved_permanently) |> redirect(to: ~p"/sitemap.xml")
  end

  # Rulings sitemap (paginated) — exists only while rulings are indexable
  def judgements(conn, %{"page" => page_str}) do
    with true <- Indexing.detail_pages?(:rulings),
         {page, ""} when page >= 1 <- Integer.parse(page_str) do
      send_xml(
        conn,
        cached("judgements:#{page}", 3600, fn -> build_judgements_sitemap(page) end),
        3600
      )
    else
      _ -> send_resp(conn, 404, "Not found")
    end
  end

  # Reports sitemap (paginated) — exists only while reports are indexable
  def reports(conn, %{"page" => page_str}) do
    with true <- Indexing.detail_pages?(:reports),
         {page, ""} when page >= 1 <- Integer.parse(page_str) do
      send_xml(conn, cached("reports:#{page}", 3600, fn -> build_reports_sitemap(page) end), 3600)
    else
      _ -> send_resp(conn, 404, "Not found")
    end
  end

  defp send_xml(conn, xml, max_age) do
    conn
    |> put_resp_content_type("application/xml")
    |> put_resp_header("cache-control", "public, max-age=#{max_age}")
    |> send_resp(200, xml)
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

  # Sitemap index: the page list plus the paginated sitemaps of whichever
  # detail pages are indexable.
  defp build_sitemap_index do
    today = Date.to_iso8601(Date.utc_today())

    judgement_sitemaps =
      if Indexing.detail_pages?(:rulings) do
        pages = ceil(Judgements.count_sitemap_entries() / @urls_per_sitemap)
        lastmods = Judgements.sitemap_lastmods(@urls_per_sitemap)

        for page <- 1..max(pages, 1) do
          {"#{@base_url}/sitemap/judgements/#{page}", format_date(lastmods[page]) || today}
        end
      else
        []
      end

    report_sitemaps =
      if Indexing.detail_pages?(:reports) do
        pages = ceil(Reports.count_sitemap_entries() / @urls_per_sitemap)
        lastmods = Reports.sitemap_lastmods(@urls_per_sitemap)

        for page <- 1..max(pages, 1) do
          {"#{@base_url}/sitemap/reports/#{page}", format_date(lastmods[page]) || today}
        end
      else
        []
      end

    sitemaps =
      [{"#{@base_url}/sitemap-static.xml", Date.utc_today()}] ++
        judgement_sitemaps ++ report_sitemaps

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
    # List pages change when their data does, so their last-modified date is
    # the date of the newest ruling or tender notice — not "today".
    kio_lastmod = format_date(Judgements.latest_update())
    tender_lastmod = format_date(Tenders.latest_publication())

    kio = fn path, priority ->
      %{loc: "#{@base_url}#{path}", lastmod: kio_lastmod, priority: priority, changefreq: "daily"}
    end

    tender = fn path, priority ->
      %{
        loc: "#{@base_url}#{path}",
        lastmod: tender_lastmod,
        priority: priority,
        changefreq: "daily"
      }
    end

    static_urls = [
      %{loc: @base_url, priority: "1.0", changefreq: "daily"},
      kio.("/orzecznictwo-kio", "0.9"),
      kio.("/orzecznictwo-kio/statystyki", "0.8"),
      tender.("/przetargi", "0.9"),
      %{loc: "#{@base_url}/analiza-rynku", priority: "0.8", changefreq: "weekly"},
      %{loc: "#{@base_url}/ustawa-pzp", priority: "0.8", changefreq: "yearly"},
      %{loc: "#{@base_url}/blog", priority: "0.8", changefreq: "weekly"},
      %{loc: "#{@base_url}/raporty", priority: "0.7", changefreq: "weekly"},
      %{loc: "#{@base_url}/o-nas", priority: "0.5", changefreq: "monthly"},
      %{loc: "#{@base_url}/kontakt", priority: "0.5", changefreq: "monthly"},
      %{loc: "#{@base_url}/regulamin", priority: "0.3", changefreq: "yearly"},
      %{loc: "#{@base_url}/polityka-prywatnosci", priority: "0.3", changefreq: "yearly"}
    ]

    region_urls = Enum.map(@regions, &tender.("/przetargi/#{&1}", "0.7"))

    # Report hubs: the landing page is in the list above, one page per region here
    report_region_urls =
      Enum.map(@regions, fn region ->
        %{loc: "#{@base_url}/raporty/#{region}", priority: "0.6", changefreq: "monthly"}
      end)

    hub_urls = Enum.map(Hubs.all_paths(), &tender.(&1, "0.8"))
    topic_urls = Enum.map(Topics.all_paths(), &kio.(&1, "0.9"))

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

    urls = static_urls ++ topic_urls ++ region_urls ++ hub_urls ++ report_region_urls ++ blog_urls
    build_urlset(urls)
  end

  # Build judgements sitemap for a specific page
  defp build_judgements_sitemap(page) do
    offset = (page - 1) * @urls_per_sitemap

    urls =
      Judgements.list_sitemap_entries(@urls_per_sitemap, offset)
      |> Enum.map(fn entry ->
        %{
          loc: "#{@base_url}/orzecznictwo-kio/#{entry.slug}",
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
