defmodule PrzetargowiWeb.SitemapController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements
  alias Przetargowi.Repo

  @base_url "https://przetargowi.pl"

  def index(conn, _params) do
    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, build_sitemap())
  end

  defp build_sitemap do
    static_urls = [
      %{loc: @base_url, priority: "1.0", changefreq: "daily"},
      %{loc: "#{@base_url}/szukaj", priority: "0.9", changefreq: "daily"},
      %{loc: "#{@base_url}/o-nas", priority: "0.5", changefreq: "monthly"},
      %{loc: "#{@base_url}/kontakt", priority: "0.5", changefreq: "monthly"},
      %{loc: "#{@base_url}/regulamin", priority: "0.3", changefreq: "yearly"},
      %{loc: "#{@base_url}/polityka-prywatnosci", priority: "0.3", changefreq: "yearly"}
    ]

    judgement_urls =
      Repo.transaction(fn ->
        Judgements.stream_sitemap_entries()
        |> Enum.map(fn entry ->
          %{
            loc: "#{@base_url}/orzeczenie/#{entry.id}",
            lastmod: format_date(entry.updated_at),
            priority: "0.8",
            changefreq: "monthly"
          }
        end)
      end)
      |> elem(1)

    urls = static_urls ++ judgement_urls

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
