defmodule PrzetargowiWeb.ReportControllerTest do
  use PrzetargowiWeb.ConnCase

  alias Przetargowi.Reports

  defp create_report(attrs \\ %{}) do
    region = Map.get(attrs, :region, "mazowieckie")
    order_type = Map.get(attrs, :order_type, "Works")
    month = Map.get(attrs, :report_month, ~D[2026-10-31])

    {:ok, report} =
      Reports.upsert_report(
        Map.merge(
          %{
            title: "Raport #{region} #{order_type} #{month}",
            slug: "#{region}-#{String.downcase(order_type)}-#{month}",
            region: region,
            order_type: order_type,
            report_month: month,
            report_type: "detailed",
            report_data: %{},
            introduction_html: "<p>Wstęp</p>",
            analysis_html: "<p>Analiza</p>",
            meta_description: "Opis raportu"
          },
          attrs
        )
      )

    report
  end

  defp page(conn, path), do: conn |> get(path) |> html_response(200) |> LazyHTML.from_document()

  defp hrefs(document, selector),
    do: document |> LazyHTML.query(selector) |> LazyHTML.attribute("href")

  describe "GET /raporty (landing)" do
    test "links to all 16 region hubs and lists the newest reports", %{conn: conn} do
      report = create_report()

      document = page(conn, "/raporty")

      assert length(hrefs(document, "#report-regions a")) == 16
      assert "/raporty/mazowieckie" in hrefs(document, "#report-regions a")
      assert "/raporty/#{report.slug}" in hrefs(document, "#report-latest a")

      assert LazyHTML.attribute(LazyHTML.query(document, "#report-search"), "action") == [
               "/raporty"
             ]

      assert Enum.count(LazyHTML.query(document, "#report-faq details")) > 0
    end

    test "is indexable with a self-referencing canonical", %{conn: conn} do
      document = page(conn, "/raporty")

      assert hrefs(document, ~s(link[rel="canonical"])) == ["https://przetargowi.pl/raporty"]

      assert document |> LazyHTML.query(~s(meta[name="robots"])) |> LazyHTML.attribute("content") ==
               ["index, follow"]
    end

    test "any query string switches to the filter form and result list, which is noindex", %{
      conn: conn
    } do
      report = create_report()

      conn = get(conn, "/raporty?q=")
      document = conn |> html_response(200) |> LazyHTML.from_document()

      assert Enum.count(LazyHTML.query(document, "#report-regions")) == 0
      assert "/raporty/#{report.slug}" in hrefs(document, "#report-results h3 a")
      assert conn.assigns.meta_robots == "noindex, follow"
    end
  end

  describe "report filters" do
    test "are all present even when there are no reports yet", %{conn: conn} do
      document = page(conn, "/raporty?q=")

      for name <- ~w(region report_type year month order_type) do
        assert Enum.count(LazyHTML.query(document, ~s(select[name="#{name}"]))) == 1, name
      end

      assert Enum.count(LazyHTML.query(document, ~s(select[name="region"] option))) == 17
      assert Enum.count(LazyHTML.query(document, ~s(select[name="month"] option))) == 13
    end

    test "narrow the list", %{conn: conn} do
      wanted = create_report(%{region: "mazowieckie", order_type: "Works"})
      other = create_report(%{region: "mazowieckie", order_type: "Delivery"})

      document = page(conn, "/raporty?region=mazowieckie&order_type=Works")
      links = hrefs(document, "#report-results h3 a")

      assert "/raporty/#{wanted.slug}" in links
      refute "/raporty/#{other.slug}" in links
    end
  end

  describe "GET /raporty/:region (hub)" do
    test "lists only that region's reports, newest first", %{conn: conn} do
      older = create_report(%{report_month: ~D[2026-09-30]})
      newer = create_report(%{report_month: ~D[2026-10-31]})
      other = create_report(%{region: "pomorskie"})

      document = page(conn, "/raporty/mazowieckie")

      assert hrefs(document, "#hub-reports h3 a") == [
               "/raporty/#{newer.slug}",
               "/raporty/#{older.slug}"
             ]

      refute "/raporty/#{other.slug}" in hrefs(document, "#hub-reports h3 a")
    end

    test "uses the same blocks, in the same order, as the KIO and tender hubs", %{conn: conn} do
      create_report()

      ids =
        conn
        |> page("/raporty/mazowieckie")
        |> LazyHTML.query("main [id]")
        |> LazyHTML.attribute("id")

      wanted = ~w(hub-figures hub-search hub-reports hub-overview report-browse)
      assert Enum.filter(ids, &(&1 in wanted)) == wanted
    end

    test "links to the region's current tenders and marks itself in the browse block", %{
      conn: conn
    } do
      document = page(conn, "/raporty/mazowieckie")

      assert "/przetargi/mazowieckie" in hrefs(document, "#hub-related a")
      refute "/raporty/mazowieckie" in hrefs(document, "#report-browse a")
      assert "/raporty/pomorskie" in hrefs(document, "#report-browse a")
    end

    test "a filtered region is rendered as a search, not as a hub", %{conn: conn} do
      create_report()

      conn = get(conn, "/raporty/mazowieckie?year=2026")
      document = conn |> html_response(200) |> LazyHTML.from_document()

      assert Enum.count(LazyHTML.query(document, "#hub-figures")) == 0
      assert conn.assigns.meta_robots == "noindex, follow"
    end

    test "every region renders", %{conn: conn} do
      for region <- Przetargowi.Tenders.Hubs.regions() do
        assert conn |> get("/raporty/#{region.slug}") |> html_response(200)
      end
    end
  end

  describe "GET /raporty/:slug (single report)" do
    test "is kept out of the index by default", %{conn: conn} do
      report = create_report()

      conn = get(conn, "/raporty/#{report.slug}")

      assert html_response(conn, 200) =~ ~s(<meta name="robots" content="noindex, follow">)
    end

    test "is indexable when the policy allows reports", %{conn: conn} do
      previous = Application.get_env(:przetargowi, :index_detail_pages)
      Application.put_env(:przetargowi, :index_detail_pages, rulings: false, reports: true)
      on_exit(fn -> Application.put_env(:przetargowi, :index_detail_pages, previous) end)

      report = create_report()

      assert conn |> get("/raporty/#{report.slug}") |> html_response(200) =~
               ~s(<meta name="robots" content="index, follow">)
    end

    test "returns 404 for an unknown report", %{conn: conn} do
      assert conn |> get("/raporty/nie-ma-takiego-raportu") |> html_response(404)
    end
  end
end
