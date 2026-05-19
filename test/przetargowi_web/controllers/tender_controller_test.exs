defmodule PrzetargowiWeb.TenderControllerTest do
  use PrzetargowiWeb.ConnCase

  import Przetargowi.TendersFixtures
  import Przetargowi.AccountsFixtures

  # Helper to set future deadline
  defp future_deadline, do: DateTime.add(DateTime.utc_now(), 30, :day)

  describe "GET /przetargi (index)" do
    test "lists tenders", %{conn: conn} do
      tender = tender_notice_fixture(
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

    test "shows watchlist button for logged-in users", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      tender = tender_notice_fixture(
        order_object: "Watchable tender detail",
        submitting_offers_date: future_deadline()
      )

      conn = get(conn, ~p"/przetargi/#{tender.slug}")

      response = html_response(conn, 200)
      assert response =~ "Dodaj do obserwowanych"
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
      regions = ~w(dolnoslaskie kujawsko-pomorskie lubelskie lubuskie lodzkie malopolskie mazowieckie opolskie podkarpackie podlaskie pomorskie slaskie swietokrzyskie warminsko-mazurskie wielkopolskie zachodniopomorskie)

      for region <- regions do
        conn = get(conn, ~p"/przetargi/#{region}")
        assert html_response(conn, 200) =~ "Przetargi"
      end
    end
  end
end
