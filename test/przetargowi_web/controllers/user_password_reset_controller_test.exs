defmodule PrzetargowiWeb.UserPasswordResetControllerTest do
  use PrzetargowiWeb.ConnCase, async: true

  alias Przetargowi.Accounts

  import Przetargowi.AccountsFixtures

  describe "GET /zapomnialem-hasla" do
    test "renders the forgot password page", %{conn: conn} do
      conn = get(conn, ~p"/zapomnialem-hasla")
      response = html_response(conn, 200)
      assert response =~ "Zapomniałeś hasła?"
      assert response =~ "Wyślij link do resetowania hasła"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(~p"/zapomnialem-hasla")
      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "POST /zapomnialem-hasla" do
    @tag :capture_log
    test "sends a password reset email for existing user", %{conn: conn} do
      user = user_fixture()

      conn =
        post(conn, ~p"/zapomnialem-hasla", %{
          "user" => %{"email" => user.email}
        })

      response = html_response(conn, 200)
      assert response =~ "Sprawdź swoją skrzynkę"
    end

    test "does not reveal if email exists", %{conn: conn} do
      conn =
        post(conn, ~p"/zapomnialem-hasla", %{
          "user" => %{"email" => "unknown@example.com"}
        })

      response = html_response(conn, 200)
      assert response =~ "Sprawdź swoją skrzynkę"
    end
  end

  describe "GET /resetuj-haslo/:token" do
    setup do
      user = user_fixture() |> set_password()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_password_reset_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "renders reset password page", %{conn: conn, token: token} do
      conn = get(conn, ~p"/resetuj-haslo/#{token}")
      response = html_response(conn, 200)
      assert response =~ "Ustaw nowe hasło"
    end

    test "redirects for invalid token", %{conn: conn} do
      conn = get(conn, ~p"/resetuj-haslo/invalid-token")
      assert redirected_to(conn) == ~p"/zapomnialem-hasla"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "nieprawidłowy lub wygasł"
    end
  end

  describe "PUT /resetuj-haslo/:token" do
    setup do
      user = user_fixture() |> set_password()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_password_reset_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "resets password with valid token and params", %{conn: conn, user: user, token: token} do
      conn =
        put(conn, ~p"/resetuj-haslo/#{token}", %{
          "user" => %{
            "password" => "new password123",
            "password_confirmation" => "new password123"
          }
        })

      assert redirected_to(conn) == ~p"/logowanie"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Hasło zostało zmienione"
      assert Accounts.get_user_by_email_and_password(user.email, "new password123")
    end

    test "renders errors for invalid params", %{conn: conn, token: token} do
      conn =
        put(conn, ~p"/resetuj-haslo/#{token}", %{
          "user" => %{
            "password" => "short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "Ustaw nowe hasło"
      # Error messages are displayed
      assert response =~ "text-error"
    end

    test "redirects for invalid token", %{conn: conn} do
      conn =
        put(conn, ~p"/resetuj-haslo/invalid-token", %{
          "user" => %{
            "password" => "new password123",
            "password_confirmation" => "new password123"
          }
        })

      assert redirected_to(conn) == ~p"/zapomnialem-hasla"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "nieprawidłowy lub wygasł"
    end
  end
end
