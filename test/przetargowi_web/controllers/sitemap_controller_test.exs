defmodule PrzetargowiWeb.SitemapControllerTest do
  use PrzetargowiWeb.ConnCase

  alias Przetargowi.Repo
  alias Przetargowi.Judgements.Judgement
  alias Przetargowi.Tenders.TenderNotice

  describe "GET /sitemap.xml" do
    test "returns sitemap index with sub-sitemaps", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")

      assert response_content_type(conn, :xml)
      assert response(conn, 200) =~ "sitemapindex"
      assert response(conn, 200) =~ "/sitemap-static.xml"
      assert response(conn, 200) =~ "/sitemap/judgements/1"
      assert response(conn, 200) =~ "/sitemap/tenders/1"
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

  describe "GET /sitemap/tenders/:page" do
    test "returns tenders sitemap for page 1", %{conn: conn} do
      insert_tender_notice(%{slug: "test-tender-1"})
      insert_tender_notice(%{slug: "test-tender-2"})

      conn = get(conn, ~p"/sitemap/tenders/1")

      assert response_content_type(conn, :xml)
      body = response(conn, 200)
      assert body =~ "<urlset"
      assert body =~ "/przetargi/test-tender-1</loc>"
      assert body =~ "/przetargi/test-tender-2</loc>"
    end

    test "returns 404 for invalid page", %{conn: conn} do
      conn = get(conn, "/sitemap/tenders/invalid")
      assert response(conn, 404)
    end

    test "includes lastmod from updated_at", %{conn: conn} do
      insert_tender_notice(%{slug: "tender-with-date"})

      conn = get(conn, ~p"/sitemap/tenders/1")
      body = response(conn, 200)

      assert body =~ "<lastmod>"
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

  defp insert_tender_notice(attrs) do
    object_id = "OBJ-#{System.unique_integer([:positive])}"

    base_attrs = %{
      object_id: object_id,
      notice_type: "ContractNotice",
      notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
      bzp_number: "BZP-#{System.unique_integer([:positive])}",
      is_tender_amount_below_eu: true,
      publication_date: DateTime.utc_now(),
      cpv_codes: ["45000000-7"],
      organization_name: "Test Organization",
      organization_city: "Warszawa",
      organization_country: "Polska",
      organization_national_id: "1234567890",
      organization_id: "ORG-#{System.unique_integer([:positive])}",
      html_body: "<html>Test</html>"
    }

    %TenderNotice{}
    |> TenderNotice.changeset(Map.merge(base_attrs, attrs))
    |> Repo.insert!()
  end
end
