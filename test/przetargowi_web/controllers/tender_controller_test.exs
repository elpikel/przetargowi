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

      conn = get(conn, ~p"/przetargi")

      response = html_response(conn, 200)
      assert response =~ "Dodaj do obserwowanych"
    end

    test "does not show watchlist buttons for anonymous users", %{conn: conn} do
      tender_notice_fixture(
        order_object: "Some tender",
        submitting_offers_date: future_deadline()
      )

      conn = get(conn, ~p"/przetargi")

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

      conn = get(conn, ~p"/przetargi")

      response = html_response(conn, 200)
      # Check pagination is present
      assert response =~ "Strona"
      assert response =~ "z 2"
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
end
