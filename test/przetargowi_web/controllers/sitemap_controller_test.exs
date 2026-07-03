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

  describe "GET /sitemap.xml" do
    test "returns sitemap index with sub-sitemaps", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")

      assert response_content_type(conn, :xml)
      assert response(conn, 200) =~ "sitemapindex"
      assert response(conn, 200) =~ "/sitemap-static.xml"
      assert response(conn, 200) =~ "/sitemap/judgements/1"
      # Individual tender pages are noindex, so they are not advertised here
      refute response(conn, 200) =~ "/sitemap/tenders/1"
    end

    test "sets cache-control header", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")

      assert get_resp_header(conn, "cache-control") == ["public, max-age=3600"]
    end
  end

  describe "GET /sitemap-static.xml" do
    test "returns static pages sitemap", %{conn: conn} do
      conn = get(conn, ~p"/sitemap-static.xml")

      assert response_content_type(conn, :xml)
      body = response(conn, 200)
      assert body =~ "<urlset"
      assert body =~ "https://przetargowi.pl</loc>"
      assert body =~ "https://przetargowi.pl/szukaj</loc>"
      assert body =~ "https://przetargowi.pl/przetargi</loc>"
      assert body =~ "https://przetargowi.pl/przetargi/mazowieckie</loc>"
      assert body =~ "https://przetargowi.pl/ustawa-pzp</loc>"
    end

    test "includes category hub pages", %{conn: conn} do
      conn = get(conn, ~p"/sitemap-static.xml")
      body = response(conn, 200)

      assert body =~ "/przetargi/rodzaj/roboty-budowlane</loc>"
      assert body =~ "/przetargi/branza/budowlane</loc>"
      assert body =~ "/przetargi/branza/medyczne</loc>"
    end

    test "includes all 16 regions", %{conn: conn} do
      conn = get(conn, ~p"/sitemap-static.xml")
      body = response(conn, 200)

      regions =
        ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

      for region <- regions do
        assert body =~ "/przetargi/#{region}</loc>"
      end
    end

    test "all static URLs return 200", %{conn: conn} do
      sitemap_conn = get(conn, ~p"/sitemap-static.xml")
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

  describe "GET /sitemap/judgements/:page" do
    test "returns judgements sitemap for page 1", %{conn: conn} do
      j1 = insert_judgement(%{signature: "KIO 123/24"})
      j2 = insert_judgement(%{signature: "KIO 456/24"})

      conn = get(conn, ~p"/sitemap/judgements/1")

      assert response_content_type(conn, :xml)
      body = response(conn, 200)
      assert body =~ "<urlset"
      assert body =~ "/orzeczenie/#{j1.slug}</loc>"
      assert body =~ "/orzeczenie/#{j2.slug}</loc>"
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
      document_type: "Wyrok"
    }

    %Judgement{}
    |> Judgement.changeset(Map.merge(base_attrs, attrs))
    |> Repo.insert!()
  end
end
