defmodule PrzetargowiWeb.TenderControllerTest do
  use PrzetargowiWeb.ConnCase

  import Przetargowi.TendersFixtures
  import Przetargowi.AccountsFixtures

  # Helper to set future deadline
  defp future_deadline, do: DateTime.add(DateTime.utc_now(), 30, :day)

  describe "GET /przetargi (index)" do
    test "lists tenders", %{conn: conn} do
      tender =
        tender_notice_fixture(
          order_object: "Test tender for listing",
          submitting_offers_date: future_deadline()
        )

      conn = get(conn, ~p"/przetargi")

      response = html_response(conn, 200)
      assert response =~ "Przetargi publiczne"
      assert response =~ "Test tender for listing"
      assert response =~ tender.bzp_number
    end

    test "filters tenders by search query", %{conn: conn} do
      tender_notice_fixture(
        order_object: "Budowa drogi ekspresowej",
        submitting_offers_date: future_deadline()
      )

      tender_notice_fixture(
        order_object: "Dostawa komputerów",
        submitting_offers_date: future_deadline()
      )

      conn = get(conn, ~p"/przetargi", q: "drogi")

      response = html_response(conn, 200)
      assert response =~ "Budowa drogi ekspresowej"
      refute response =~ "Dostawa komputerów"
    end

    test "filters tenders by region", %{conn: conn} do
      # Region filtering uses province codes like "PL14" for "mazowieckie"
      tender_notice_fixture(
        order_object: "Tender in Mazowieckie",
        organization_province: "PL14",
        submitting_offers_date: future_deadline()
      )

      tender_notice_fixture(
        order_object: "Tender in Pomorskie",
        organization_province: "PL22",
        submitting_offers_date: future_deadline()
      )

      conn = get(conn, ~p"/przetargi", regions: ["mazowieckie"])

      response = html_response(conn, 200)
      assert response =~ "Tender in Mazowieckie"
      refute response =~ "Tender in Pomorskie"
    end

    test "shows watchlist buttons for logged-in users", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      tender_notice_fixture(
        order_object: "Watchable tender",
        submitting_offers_date: future_deadline()
      )

      conn = get(conn, "/przetargi?q=")

      response = html_response(conn, 200)
      assert response =~ "Dodaj do obserwowanych"
    end

    test "does not show watchlist buttons for anonymous users", %{conn: conn} do
      tender_notice_fixture(
        order_object: "Some tender",
        submitting_offers_date: future_deadline()
      )

      conn = get(conn, "/przetargi?q=")

      response = html_response(conn, 200)
      refute response =~ "Dodaj do obserwowanych"
    end

    test "shows empty state when no tenders match", %{conn: conn} do
      conn = get(conn, ~p"/przetargi", q: "nonexistent search term xyz123")

      response = html_response(conn, 200)
      assert response =~ "Brak wyników dla podanych kryteriów"
    end

    test "paginates results when more than one page", %{conn: conn} do
      # Create 25 tenders (more than one page of 20)
      for i <- 1..25 do
        tender_notice_fixture(
          order_object: "Tender number #{i}",
          submitting_offers_date: future_deadline()
        )
      end

      conn = get(conn, "/przetargi?q=")

      response = html_response(conn, 200)
      # Check pagination is present
      assert response =~ "Strona"
      assert response =~ "z 2"
    end
  end

  describe "GET /przetargi category hubs" do
    test "order-type hub filters by order type and shows its H1", %{conn: conn} do
      tender_notice_fixture(
        order_object: "Budowa hali sportowej",
        order_type: "Works",
        submitting_offers_date: future_deadline()
      )

      tender_notice_fixture(
        order_object: "Dostawa laptopow do urzedu",
        order_type: "Delivery",
        submitting_offers_date: future_deadline()
      )

      response = conn |> get(~p"/przetargi/rodzaj/roboty-budowlane") |> html_response(200)

      assert response =~ "Przetargi na roboty budowlane"
      assert response =~ "Budowa hali sportowej"
      refute response =~ "Dostawa laptopow do urzedu"
    end

    test "category hub filters by CPV prefix", %{conn: conn} do
      tender_notice_fixture(
        order_object: "Przebudowa budynku szkoly",
        cpv_main: "45000000-7",
        submitting_offers_date: future_deadline()
      )

      tender_notice_fixture(
        order_object: "Zakup aparatury medycznej",
        cpv_main: "33100000-1",
        submitting_offers_date: future_deadline()
      )

      response = conn |> get(~p"/przetargi/branza/budowlane") |> html_response(200)

      assert response =~ "Przetargi budowlane"
      assert response =~ "Przebudowa budynku szkoly"
      refute response =~ "Zakup aparatury medycznej"
    end

    test "unknown hub slug returns 404", %{conn: conn} do
      assert conn |> get(~p"/przetargi/rodzaj/nieistniejacy-typ") |> html_response(404)
    end
  end

  describe "GET /przetargi/:slug (show tender)" do
    test "shows tender details", %{conn: conn} do
      tender =
        tender_notice_fixture(
          order_object: "Detailed tender description",
          organization_name: "Test Organization",
          submitting_offers_date: future_deadline()
        )

      conn = get(conn, ~p"/przetargi/#{tender.slug}")

      response = html_response(conn, 200)
      assert response =~ "Detailed tender description"
      assert response =~ "Test Organization"
    end

    test "returns 404 for non-existent tender", %{conn: conn} do
      conn = get(conn, ~p"/przetargi/non-existent-slug-12345")

      assert html_response(conn, 404)
    end

    test "individual tender page is noindex, follow", %{conn: conn} do
      tender = tender_notice_fixture(submitting_offers_date: future_deadline())

      response = conn |> get(~p"/przetargi/#{tender.slug}") |> html_response(200)

      assert response =~ ~s(name="robots" content="noindex, follow")
    end

    test "shows a lifecycle status instead of the raw notice type", %{conn: conn} do
      tender =
        tender_notice_fixture(
          order_object: "Aktywny przetarg",
          notice_type: "ContractNotice",
          tender_id: unique_tender_id(),
          submitting_offers_date: future_deadline()
        )

      conn = get(conn, ~p"/przetargi/#{tender.slug}")

      response = html_response(conn, 200)
      assert response =~ "Aktywny"
      assert response =~ "Aktywne ogłoszenie"
      # The raw BZP notice type is no longer displayed on the tender page
      refute response =~ "Ogłoszenie o zamówieniu"
    end

    test "301-redirects a result notice to its contract notice and merges the award", %{
      conn: conn
    } do
      tender_id = unique_tender_id()

      contract =
        tender_notice_fixture(
          order_object: "Budowa przedszkola",
          notice_type: "ContractNotice",
          tender_id: tender_id,
          submitting_offers_date: future_deadline()
        )

      result =
        tender_notice_fixture(
          order_object: "Budowa przedszkola",
          notice_type: "TenderResultNotice",
          tender_id: tender_id,
          contractors: [%{contractor_name: "Firma Budowlana Sp. z o.o."}],
          contractors_contract_details: [
            %{
              part: 1,
              status: :contract_signed,
              contractor_name: "Firma Budowlana Sp. z o.o.",
              contract_value: "1000000"
            }
          ]
        )

      # The result-notice URL permanently redirects to the contract-notice URL
      redirected = get(conn, ~p"/przetargi/#{result.slug}")
      assert redirected.status == 301
      assert redirected_to(redirected, 301) == ~p"/przetargi/#{contract.slug}"

      # The contract-notice page now shows the award data from the result notice
      shown = get(conn, ~p"/przetargi/#{contract.slug}")
      response = html_response(shown, 200)
      assert response =~ "Firma Budowlana Sp. z o.o."
      assert response =~ "Rozstrzygnięty"
      assert response =~ "Postępowanie zostało rozstrzygnięte"
    end

    test "canonical contract-notice URL does not redirect even with a result sibling", %{
      conn: conn
    } do
      tender_id = unique_tender_id()

      contract =
        tender_notice_fixture(
          notice_type: "ContractNotice",
          tender_id: tender_id,
          submitting_offers_date: future_deadline()
        )

      _result =
        tender_notice_fixture(
          notice_type: "TenderResultNotice",
          tender_id: tender_id,
          contractors_contract_details: [
            %{part: 1, status: :contract_signed, contractor_name: "Wykonawca A"}
          ]
        )

      conn = get(conn, ~p"/przetargi/#{contract.slug}")

      assert html_response(conn, 200)
    end

    test "contract notice without a result notice renders without the award section", %{
      conn: conn
    } do
      tender =
        tender_notice_fixture(
          order_object: "Przetarg bez rozstrzygnięcia",
          notice_type: "ContractNotice",
          tender_id: unique_tender_id(),
          submitting_offers_date: future_deadline()
        )

      conn = get(conn, ~p"/przetargi/#{tender.slug}")

      response = html_response(conn, 200)
      assert response =~ "Przetarg bez rozstrzygnięcia"
      refute response =~ "Rozstrzygnięty"
      refute response =~ "Wynik postępowania"
    end

    test "standalone result notice (no tender_id) renders its own award without redirecting", %{
      conn: conn
    } do
      result =
        tender_notice_fixture(
          order_object: "Samodzielny wynik",
          notice_type: "TenderResultNotice",
          contractors: [%{contractor_name: "Zwycięzca S.A."}],
          contractors_contract_details: [
            %{part: 1, status: :contract_signed, contractor_name: "Zwycięzca S.A."}
          ]
        )

      conn = get(conn, ~p"/przetargi/#{result.slug}")

      response = html_response(conn, 200)
      assert response =~ "Zwycięzca S.A."
      assert response =~ "Rozstrzygnięty"
    end

    test "shows watchlist button for logged-in users", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      tender =
        tender_notice_fixture(
          order_object: "Watchable tender detail",
          submitting_offers_date: future_deadline()
        )

      conn = get(conn, ~p"/przetargi/#{tender.slug}")

      response = html_response(conn, 200)
      assert response =~ "Obserwuj"
    end

    test "shows watching status when tender is watched", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      tender = tender_notice_fixture(submitting_offers_date: future_deadline())

      # Add to watchlist
      {:ok, _} = Przetargowi.Watchlist.add_to_watchlist(user.id, tender.object_id)

      conn = get(conn, ~p"/przetargi/#{tender.slug}")

      response = html_response(conn, 200)
      # Button shows "Obserwujesz" with filled star when watching
      assert response =~ "Obserwujesz"
    end
  end

  describe "GET /przetargi/:region (regional tenders)" do
    test "shows tenders filtered by region", %{conn: conn} do
      # Region filtering uses province codes like "PL14" for "mazowieckie"
      tender_notice_fixture(
        order_object: "Mazowieckie tender",
        organization_province: "PL14",
        submitting_offers_date: future_deadline()
      )

      tender_notice_fixture(
        order_object: "Other region tender",
        organization_province: "PL22",
        submitting_offers_date: future_deadline()
      )

      conn = get(conn, ~p"/przetargi/mazowieckie")

      response = html_response(conn, 200)
      assert response =~ "Przetargi mazowieckie"
      assert response =~ "Mazowieckie tender"
      refute response =~ "Other region tender"
    end

    test "all valid regions are accessible", %{conn: conn} do
      regions =
        ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

      for region <- regions do
        conn = get(conn, ~p"/przetargi/#{region}")
        assert html_response(conn, 200) =~ "Przetargi"
      end
    end
  end

  describe "breadcrumbs on hub and region pages" do
    test "region page has its own heading and a breadcrumb trail", %{conn: conn} do
      conn = get(conn, "/przetargi/mazowieckie")
      document = conn |> html_response(200) |> LazyHTML.from_document()

      assert document
             |> LazyHTML.query("nav[aria-label=Okruszki] a")
             |> LazyHTML.attribute("href") ==
               ["/", "/przetargi"]

      assert conn.assigns.hub.name == "Przetargi — województwo mazowieckie"

      assert List.last(conn.assigns.breadcrumbs).url ==
               "https://przetargowi.pl/przetargi/mazowieckie"
    end

    test "category hub exposes breadcrumb structured data", %{conn: conn} do
      conn = get(conn, "/przetargi/branza/budowlane")
      response = html_response(conn, 200)

      assert response =~ ~s("@type":"BreadcrumbList")

      assert List.last(conn.assigns.breadcrumbs).url ==
               "https://przetargowi.pl/przetargi/branza/budowlane"
    end
  end

  describe "hub navigation and content" do
    setup do
      Przetargowi.SitemapCache.clear()
      on_exit(&Przetargowi.SitemapCache.clear/0)
    end

    defp page(conn, path), do: conn |> get(path) |> html_response(200) |> LazyHTML.from_document()

    defp hrefs(document, selector),
      do: document |> LazyHTML.query(selector) |> LazyHTML.attribute("href")

    test "the tender index links to every industry, order-type and region hub", %{conn: conn} do
      document = page(conn, "/przetargi")

      assert hrefs(document, "#browse-categories a") ==
               Enum.map(Przetargowi.Tenders.Hubs.category_hubs(), &"/przetargi/branza/#{&1.slug}")

      assert document
             |> hrefs("#browse-order-types a")
             |> Enum.filter(&String.starts_with?(&1, "/przetargi/rodzaj/")) ==
               Enum.map(
                 Przetargowi.Tenders.Hubs.order_type_hubs(),
                 &"/przetargi/rodzaj/#{&1.slug}"
               )

      assert length(hrefs(document, "#browse-regions a")) == 16
    end

    test "a hub marks itself as the current page in the navigation", %{conn: conn} do
      document = page(conn, "/przetargi/branza/budowlane")

      refute "/przetargi/branza/budowlane" in hrefs(document, "#browse-categories a")
      assert Enum.count(LazyHTML.query(document, "#browse-categories [aria-current=page]")) == 1
    end

    test "every hub has copy, FAQ and related KIO topics", %{conn: conn} do
      for path <- Przetargowi.Tenders.Hubs.all_paths() do
        document = page(conn, path)

        assert Enum.count(LazyHTML.query(document, "#hub-overview p")) >= 2, path
        assert Enum.count(LazyHTML.query(document, "#hub-faq details")) >= 3, path

        kio_links = hrefs(document, "#hub-kio-topics a")
        assert kio_links != [], path
        assert Enum.all?(kio_links, &String.starts_with?(&1, "/orzecznictwo-kio/")), path
      end
    end

    test "hub figures count the open tenders it lists, by region and order type", %{conn: conn} do
      for {province, deadline_days} <- [{"PL14", 3}, {"PL14", 30}, {"PL12", 30}] do
        tender_notice_fixture(
          order_type: "Works",
          cpv_main: "45000000-7",
          organization_province: province,
          organization_name: "Gmina Testowa",
          notice_type: "ContractNotice",
          publication_date: DateTime.utc_now(),
          submitting_offers_date: DateTime.add(DateTime.utc_now(), deadline_days, :day)
        )
      end

      # Different industry: must not be counted
      tender_notice_fixture(
        order_type: "Delivery",
        cpv_main: "33000000-0",
        organization_province: "PL14",
        submitting_offers_date: future_deadline()
      )

      conn = get(conn, "/przetargi/branza/budowlane")
      document = conn |> html_response(200) |> LazyHTML.from_document()
      stats = conn.assigns.hub.stats

      assert conn.assigns.total_count == 3
      assert stats.closing_soon == 1
      assert stats.published_last_year == 3
      assert stats.by_region == [{"mazowieckie", 2}, {"malopolskie", 1}]
      assert stats.by_order_type == [{"Works", 3}]
      assert stats.top_authorities == [{"Gmina Testowa", 3}]

      assert hrefs(document, "#hub-by-region a") == [
               "/przetargi/mazowieckie",
               "/przetargi/malopolskie"
             ]

      assert hrefs(document, "#hub-by-order-type a") == ["/przetargi/rodzaj/roboty-budowlane"]
    end

    test "region page shows figures and a description but no templated FAQ", %{conn: conn} do
      document = page(conn, "/przetargi/mazowieckie")

      assert Enum.count(LazyHTML.query(document, "#hub-figures")) == 1
      assert Enum.count(LazyHTML.query(document, "#hub-overview p")) == 1
      assert Enum.count(LazyHTML.query(document, "#hub-faq")) == 0
    end

    test "filtered and deeper pages stay plain result lists", %{conn: conn} do
      document = page(conn, "/przetargi/branza/budowlane?page=2")

      assert Enum.count(LazyHTML.query(document, "#hub-editorial")) == 0
      assert Enum.count(LazyHTML.query(document, "#tender-browse")) == 1
    end

    test "footer links to tender hubs on every page", %{conn: conn} do
      document = page(conn, "/o-nas")

      assert "/przetargi/branza/budowlane" in hrefs(document, "#footer-tender-hubs a")
    end
  end

  describe "landing, hub and search share one layout" do
    setup do
      Przetargowi.SitemapCache.clear()
      on_exit(&Przetargowi.SitemapCache.clear/0)
    end

    test "bare /przetargi is a landing page with search, industry grid and newest tenders", %{
      conn: conn
    } do
      tender = tender_notice_fixture(submitting_offers_date: future_deadline())

      document = page(conn, "/przetargi")

      assert LazyHTML.attribute(LazyHTML.query(document, "#tender-search"), "action") ==
               ["/przetargi"]

      assert length(hrefs(document, "#tender-categories a")) == 12
      assert "/przetargi/#{tender.slug}" in hrefs(document, "#tender-latest a")
      assert Enum.count(LazyHTML.query(document, "#tender-faq details")) > 0
    end

    test "any query string switches /przetargi to the filter form and result list", %{conn: conn} do
      tender = tender_notice_fixture(submitting_offers_date: future_deadline())

      document = page(conn, "/przetargi?q=")

      assert Enum.count(LazyHTML.query(document, "#tender-categories")) == 0
      assert "/przetargi/#{tender.slug}" in hrefs(document, "#tender-results h3 a")
    end

    test "a hub with no open tenders lists recently closed ones instead of an empty box", %{
      conn: conn
    } do
      closed =
        tender_notice_fixture(
          cpv_main: "45000000-7",
          submitting_offers_date: DateTime.add(DateTime.utc_now(), -5, :day)
        )

      conn = get(conn, "/przetargi/branza/budowlane")
      document = conn |> html_response(200) |> LazyHTML.from_document()

      refute conn.assigns.open?
      assert conn.assigns.total_count == 0
      assert hrefs(document, "#hub-tenders h3 a") == ["/przetargi/#{closed.slug}"]
    end

    test "a hub's search box keeps the hub's own filter where the search supports it", %{
      conn: conn
    } do
      region = page(conn, "/przetargi/mazowieckie")

      assert region
             |> LazyHTML.query(~s(#hub-search input[type=hidden]))
             |> LazyHTML.attribute("value") == ["mazowieckie"]
    end

    test "a filtered region is rendered as a search, not as a hub", %{conn: conn} do
      document = page(conn, "/przetargi/mazowieckie?q=droga")

      assert Enum.count(LazyHTML.query(document, "#hub-figures")) == 0
      assert Enum.count(LazyHTML.query(document, "#tender-browse")) == 1
    end
  end
end
