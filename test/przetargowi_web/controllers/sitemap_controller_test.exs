defmodule PrzetargowiWeb.SitemapControllerTest do
  use PrzetargowiWeb.ConnCase

  alias Przetargowi.Repo
  alias Przetargowi.Judgements.Judgement
  alias Przetargowi.SitemapCache

  # The sitemap cache is a global ETS table; clear it so generated XML from one
  # test never leaks into another (tests run in a shuffled, non-async order).
  setup do
    SitemapCache.clear()
    :ok
  end

  # Switches detail pages back into the index for one test (see PrzetargowiWeb.Indexing).
  defp index_detail_pages(kinds) do
    previous = Application.get_env(:przetargowi, :index_detail_pages)
    Application.put_env(:przetargowi, :index_detail_pages, kinds)
    on_exit(fn -> Application.put_env(:przetargowi, :index_detail_pages, previous) end)
  end

  describe "GET /sitemap.xml" do
    test "is one file listing only landing pages, hubs, blog and static pages", %{conn: conn} do
      ruling = insert_judgement(%{signature: "KIO 123/24"})

      conn = get(conn, ~p"/sitemap.xml")

      assert response_content_type(conn, :xml)
      body = response(conn, 200)

      assert body =~ "<urlset"
      refute body =~ "sitemapindex"
      assert body =~ "https://przetargowi.pl/orzecznictwo-kio</loc>"
      assert body =~ "/orzecznictwo-kio/razaco-niska-cena</loc>"
      assert body =~ "/przetargi/branza/budowlane</loc>"
      assert body =~ "/raporty/mazowieckie</loc>"
      assert body =~ "/blog/jak-odwolac-sie-do-kio</loc>"

      # Detail pages are noindex, so they are not advertised
      refute body =~ "/orzecznictwo-kio/#{ruling.slug}</loc>"
    end

    test "the old page-list URL redirects to the single sitemap", %{conn: conn} do
      assert conn |> get(~p"/sitemap-static.xml") |> redirected_to(301) == "/sitemap.xml"
    end

    test "becomes a sitemap index when rulings are indexable again", %{conn: conn} do
      index_detail_pages(rulings: true, reports: false)

      body = conn |> get(~p"/sitemap.xml") |> response(200)

      assert body =~ "sitemapindex"
      assert body =~ "/sitemap-static.xml"
      assert body =~ "/sitemap/judgements/1"
      refute body =~ "/sitemap/reports/1"
    end

    test "sets cache-control header", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")

      assert get_resp_header(conn, "cache-control") == ["public, max-age=3600"]
    end
  end

  describe "page list in /sitemap.xml" do
    test "returns static pages sitemap", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")

      assert response_content_type(conn, :xml)
      body = response(conn, 200)
      assert body =~ "<urlset"
      assert body =~ "https://przetargowi.pl</loc>"
      assert body =~ "https://przetargowi.pl/orzecznictwo-kio</loc>"
      # The bare search URL redirects to the pillar page, so it is not listed.
      refute body =~ "https://przetargowi.pl/szukaj</loc>"
      assert body =~ "https://przetargowi.pl/przetargi</loc>"
      assert body =~ "https://przetargowi.pl/przetargi/mazowieckie</loc>"
      assert body =~ "https://przetargowi.pl/ustawa-pzp</loc>"
    end

    test "includes category hub pages", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")
      body = response(conn, 200)

      assert body =~ "/przetargi/rodzaj/roboty-budowlane</loc>"
      assert body =~ "/przetargi/branza/budowlane</loc>"
      assert body =~ "/przetargi/branza/medyczne</loc>"
    end

    test "list pages carry the date of their newest data as last-modified", %{conn: conn} do
      insert_judgement(%{signature: "KIO 900/24"})

      body = conn |> get(~p"/sitemap.xml") |> response(200)
      today = Date.to_iso8601(Date.utc_today())

      assert body =~
               ~r{<loc>https://przetargowi.pl/orzecznictwo-kio/wadium</loc>\s*<lastmod>#{today}</lastmod>}
    end

    test "blog articles carry their own last-modified date, not today's", %{conn: conn} do
      body = conn |> get(~p"/sitemap.xml") |> response(200)

      article = Przetargowi.Blog.get_article_by_slug("jak-odwolac-sie-do-kio")
      date = Calendar.strftime(article.updated_at, "%Y-%m-%d")

      assert date != Date.to_iso8601(Date.utc_today())

      assert body =~
               ~r{<loc>https://przetargowi.pl/blog/jak-odwolac-sie-do-kio</loc>\s*<lastmod>#{date}</lastmod>}
    end

    test "includes KIO topic hubs", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")
      body = response(conn, 200)

      assert body =~ "/orzecznictwo-kio/razaco-niska-cena</loc>"
      assert body =~ "/orzecznictwo-kio/tajemnica-przedsiebiorstwa</loc>"
    end

    test "includes all 16 regions", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")
      body = response(conn, 200)

      regions =
        ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

      for region <- regions do
        assert body =~ "/przetargi/#{region}</loc>"
      end
    end

    test "all static URLs return 200", %{conn: conn} do
      sitemap_conn = get(conn, ~p"/sitemap.xml")
      body = response(sitemap_conn, 200)

      # Extract all URLs from the sitemap
      urls =
        Regex.scan(~r/<loc>https:\/\/przetargowi\.pl([^<]+)<\/loc>/, body)
        |> Enum.map(fn [_, path] -> path end)
        |> Enum.reject(&String.starts_with?(&1, "/blog/"))

      assert length(urls) > 0, "Expected to find URLs in sitemap"

      for path <- urls do
        page_conn = get(conn, path)

        assert page_conn.status == 200,
               "Expected #{path} to return 200, got #{page_conn.status}"
      end
    end
  end

  describe "GET /sitemap/judgements/:page when rulings are not indexable" do
    test "does not exist", %{conn: conn} do
      insert_judgement(%{signature: "KIO 123/24"})

      assert conn |> get(~p"/sitemap/judgements/1") |> response(404)
    end
  end

  describe "GET /sitemap/judgements/:page" do
    setup do
      index_detail_pages(rulings: true, reports: false)
    end

    test "returns judgements sitemap for page 1", %{conn: conn} do
      j1 = insert_judgement(%{signature: "KIO 123/24"})
      j2 = insert_judgement(%{signature: "KIO 456/24"})
      thin = insert_judgement(%{signature: "KIO 789/24", meritum: nil})

      conn = get(conn, ~p"/sitemap/judgements/1")

      assert response_content_type(conn, :xml)
      body = response(conn, 200)
      assert body =~ "<urlset"
      assert body =~ "/orzecznictwo-kio/#{j1.slug}</loc>"
      assert body =~ "/orzecznictwo-kio/#{j2.slug}</loc>"
      # Rulings without content are noindex on the page, so not advertised here.
      refute body =~ "/orzecznictwo-kio/#{thin.slug}</loc>"
    end

    test "returns 404 for invalid page", %{conn: conn} do
      conn = get(conn, "/sitemap/judgements/invalid")
      assert response(conn, 404)
    end

    test "returns 404 for page 0", %{conn: conn} do
      conn = get(conn, "/sitemap/judgements/0")
      assert response(conn, 404)
    end

    test "returns empty urlset for page beyond data", %{conn: conn} do
      conn = get(conn, ~p"/sitemap/judgements/999")

      assert response_content_type(conn, :xml)
      body = response(conn, 200)
      assert body =~ "<urlset"
      refute body =~ "<url>"
    end
  end

  # Helper functions to insert test data

  defp insert_judgement(attrs) do
    base_attrs = %{
      uzp_id: "UZP-#{System.unique_integer([:positive])}",
      signature: "KIO #{System.unique_integer([:positive])}/24",
      issuing_authority: "Krajowa Izba Odwoławcza",
      document_type: "Wyrok",
      meritum: String.duplicate("istota sprawy ", 10)
    }

    %Judgement{}
    |> Judgement.changeset(Map.merge(base_attrs, attrs))
    |> Repo.insert!()
  end
end
