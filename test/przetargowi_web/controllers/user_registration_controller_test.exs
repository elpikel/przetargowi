defmodule PrzetargowiWeb.UserRegistrationControllerTest do
  use PrzetargowiWeb.ConnCase, async: true

  import Przetargowi.AccountsFixtures

  describe "GET /rejestracja" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, ~p"/rejestracja")
      response = html_response(conn, 200)
      assert response =~ "Utwórz konto"
      assert response =~ ~p"/logowanie"
      assert response =~ ~p"/rejestracja"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(~p"/rejestracja")

      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "POST /rejestracja" do
    @tag :capture_log
    test "creates account but does not log in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, ~p"/rejestracja", %{
          "user" => valid_user_attributes(email: email)
        })

      assert redirected_to(conn) == ~p"/logowanie"

      assert conn.assigns.flash["info"] =~
               ~r/email/i
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, ~p"/rejestracja", %{
          "user" => %{"email" => "with spaces"}
        })

      response = html_response(conn, 200)
      assert response =~ "Utwórz konto"
      assert response =~ "must have the @ sign and no spaces"
    end
  end
end
