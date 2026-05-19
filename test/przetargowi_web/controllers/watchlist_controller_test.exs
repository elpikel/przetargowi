defmodule PrzetargowiWeb.WatchlistControllerTest do
  use PrzetargowiWeb.ConnCase

  alias Przetargowi.Watchlist

  import Przetargowi.AccountsFixtures
  import Przetargowi.TendersFixtures
  import Przetargowi.WatchlistFixtures

  describe "GET /obserwowane (index)" do
    setup :register_and_log_in_user

    test "lists user's watchlist entries", %{conn: conn, user: user} do
      tender = tender_notice_fixture(order_object: "Watched tender")
      _entry = watchlist_entry_fixture(user: user, tender: tender)

      conn = get(conn, ~p"/obserwowane")

      response = html_response(conn, 200)
      assert response =~ "Obserwowane przetargi"
      assert response =~ "Watched tender"
    end

    test "shows empty state when watchlist is empty", %{conn: conn} do
      conn = get(conn, ~p"/obserwowane")

      response = html_response(conn, 200)
      assert response =~ "Obserwowane przetargi"
      assert response =~ "Nie obserwujesz jeszcze"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = get(conn, ~p"/obserwowane")

      assert redirected_to(conn) == ~p"/logowanie"
    end
  end

  describe "POST /obserwowane (create)" do
    setup :register_and_log_in_user

    test "adds tender to watchlist", %{conn: conn, user: user} do
      tender = tender_notice_fixture()

      conn = post(conn, ~p"/obserwowane", tender_object_id: tender.object_id)

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "dodany do obserwowanych"
      assert Watchlist.is_watching?(user.id, tender.object_id)
    end

    test "shows error when adding same tender twice", %{conn: conn, user: user} do
      tender = tender_notice_fixture()
      {:ok, _} = Watchlist.add_to_watchlist(user.id, tender.object_id)

      conn = post(conn, ~p"/obserwowane", tender_object_id: tender.object_id)

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Już obserwujesz"
    end

    test "shows error when quota exceeded", %{conn: conn, user: user} do
      # Add 1 tender (free user limit)
      tender = tender_notice_fixture()
      watchlist_entry_fixture(user: user, tender: tender)

      new_tender = tender_notice_fixture()

      conn = post(conn, ~p"/obserwowane", tender_object_id: new_tender.object_id)

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "limit"
      refute Watchlist.is_watching?(user.id, new_tender.object_id)
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      tender = tender_notice_fixture()

      conn = post(conn, ~p"/obserwowane", tender_object_id: tender.object_id)

      assert redirected_to(conn) == ~p"/logowanie"
    end
  end

  describe "DELETE /obserwowane/:id (delete)" do
    setup :register_and_log_in_user

    test "removes entry from watchlist", %{conn: conn, user: user} do
      tender = tender_notice_fixture()
      entry = watchlist_entry_fixture(user: user, tender: tender)

      conn = delete(conn, ~p"/obserwowane/#{entry.id}")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "usunięty z obserwowanych"
      refute Watchlist.is_watching?(user.id, tender.object_id)
    end

    test "shows error when entry not found", %{conn: conn} do
      conn = delete(conn, ~p"/obserwowane/999999")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Nie udało się"
    end

    test "cannot delete another user's entry", %{conn: conn} do
      other_user = user_fixture()
      tender = tender_notice_fixture()
      entry = watchlist_entry_fixture(user: other_user, tender: tender)

      conn = delete(conn, ~p"/obserwowane/#{entry.id}")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Nie udało się"
      assert Watchlist.is_watching?(other_user.id, tender.object_id)
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = delete(conn, ~p"/obserwowane/1")

      assert redirected_to(conn) == ~p"/logowanie"
    end
  end

  describe "DELETE /obserwowane/przetarg/:tender_object_id (delete_by_tender)" do
    setup :register_and_log_in_user

    test "removes entry by tender object_id", %{conn: conn, user: user} do
      tender = tender_notice_fixture()
      _entry = watchlist_entry_fixture(user: user, tender: tender)

      conn = delete(conn, ~p"/obserwowane/przetarg/#{tender.object_id}")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "usunięty z obserwowanych"
      refute Watchlist.is_watching?(user.id, tender.object_id)
    end

    test "shows error when not watching tender", %{conn: conn} do
      tender = tender_notice_fixture()

      conn = delete(conn, ~p"/obserwowane/przetarg/#{tender.object_id}")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Nie udało się"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      tender = tender_notice_fixture()

      conn = delete(conn, ~p"/obserwowane/przetarg/#{tender.object_id}")

      assert redirected_to(conn) == ~p"/logowanie"
    end
  end

  describe "redirect behavior" do
    setup :register_and_log_in_user

    test "redirects back to referer after adding to watchlist", %{conn: conn} do
      tender = tender_notice_fixture()

      conn =
        conn
        |> put_req_header("referer", "/przetargi")
        |> post(~p"/obserwowane", tender_object_id: tender.object_id)

      assert redirected_to(conn) == "/przetargi"
    end

    test "redirects to /obserwowane when no referer", %{conn: conn} do
      tender = tender_notice_fixture()

      conn = post(conn, ~p"/obserwowane", tender_object_id: tender.object_id)

      assert redirected_to(conn) == ~p"/obserwowane"
    end
  end
end
