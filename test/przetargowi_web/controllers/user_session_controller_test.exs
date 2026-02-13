defmodule PrzetargowiWeb.UserSessionControllerTest do
  use PrzetargowiWeb.ConnCase, async: true

  import Przetargowi.AccountsFixtures
  alias Przetargowi.Accounts

  setup do
    %{unconfirmed_user: unconfirmed_user_fixture(), user: user_fixture()}
  end

  describe "GET /logowanie" do
    test "renders login page", %{conn: conn} do
      conn = get(conn, ~p"/logowanie")
      response = html_response(conn, 200)
      assert response =~ "Zaloguj się"
      assert response =~ ~p"/rejestracja"
      assert response =~ "Wyślij link do logowania"
    end

    test "renders login page with email filled in (sudo mode)", %{conn: conn, user: user} do
      html =
        conn
        |> log_in_user(user)
        |> get(~p"/logowanie")
        |> html_response(200)

      assert html =~ "ponowne uwierzytelnienie"
      refute html =~ "Zarejestruj się"
      assert html =~ "Wyślij link do logowania"
    end

    test "renders login page (email + password)", %{conn: conn} do
      conn = get(conn, ~p"/logowanie?mode=password")
      response = html_response(conn, 200)
      assert response =~ "Zaloguj się"
      assert response =~ ~p"/rejestracja"
      assert response =~ "Wyślij link do logowania"
    end
  end

  describe "GET /logowanie/:token" do
    test "renders confirmation page for unconfirmed user", %{conn: conn, unconfirmed_user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_login_instructions(user, url)
        end)

      conn = get(conn, ~p"/logowanie/#{token}")
      assert html_response(conn, 200) =~ "Potwierdź i pozostań zalogowany"
    end

    test "renders login page for confirmed user", %{conn: conn, user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_login_instructions(user, url)
        end)

      conn = get(conn, ~p"/logowanie/#{token}")
      html = html_response(conn, 200)
      refute html =~ "Potwierdź moje konto"
      assert html =~ "Zaloguj"
    end

    test "raises error for invalid token", %{conn: conn} do
      conn = get(conn, ~p"/logowanie/invalid-token")
      assert redirected_to(conn) == ~p"/logowanie"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "logowania"
    end
  end

  describe "POST /logowanie - email and password" do
    test "logs the user in", %{conn: conn, user: user} do
      user = set_password(user)

      conn =
        post(conn, ~p"/logowanie", %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ user.email
      assert response =~ ~p"/ustawienia"
      assert response =~ ~p"/wyloguj"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      user = set_password(user)

      conn =
        post(conn, ~p"/logowanie", %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_przetargowi_web_user_remember_me"]
      assert redirected_to(conn) == ~p"/"
    end

    test "logs the user in with return to", %{conn: conn, user: user} do
      user = set_password(user)

      conn =
        conn
        |> init_test_session(user_return_to: "/foo/bar")
        |> post(~p"/logowanie", %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
    end

    test "emits error message with invalid credentials", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/logowanie?mode=password", %{
          "user" => %{"email" => user.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "Zaloguj się"
    end
  end

  describe "POST /logowanie - magic link" do
    test "sends magic link email when user exists", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/logowanie", %{
          "user" => %{"email" => user.email}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "email"
      assert Przetargowi.Repo.get_by!(Accounts.UserToken, user_id: user.id).context == "login"
    end

    test "logs the user in", %{conn: conn, user: user} do
      {token, _hashed_token} = generate_user_magic_link_token(user)

      conn =
        post(conn, ~p"/logowanie", %{
          "user" => %{"token" => token}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ user.email
      assert response =~ ~p"/ustawienia"
      assert response =~ ~p"/wyloguj"
    end

    test "confirms unconfirmed user", %{conn: conn, unconfirmed_user: user} do
      {token, _hashed_token} = generate_user_magic_link_token(user)
      refute user.confirmed_at

      conn =
        post(conn, ~p"/logowanie", %{
          "user" => %{"token" => token},
          "_action" => "confirmed"
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/"

      assert Accounts.get_user!(user.id).confirmed_at

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ user.email
      assert response =~ ~p"/ustawienia"
      assert response =~ ~p"/wyloguj"
    end

    test "emits error message when magic link is invalid", %{conn: conn} do
      conn =
        post(conn, ~p"/logowanie", %{
          "user" => %{"token" => "invalid"}
        })

      assert html_response(conn, 200) =~ "link"
    end
  end

  describe "DELETE /wyloguj" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(~p"/wyloguj")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :user_token)
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/wyloguj")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :user_token)
    end
  end
end
