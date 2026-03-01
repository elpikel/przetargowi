defmodule PrzetargowiWeb.UserSessionControllerTest do
  use PrzetargowiWeb.ConnCase, async: true

  import Przetargowi.AccountsFixtures

  setup do
    %{user: user_fixture() |> set_password()}
  end

  describe "GET /logowanie" do
    test "renders login page", %{conn: conn} do
      conn = get(conn, ~p"/logowanie")
      response = html_response(conn, 200)
      assert response =~ "Zaloguj"
    end

    test "renders login page even if already logged in", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/logowanie")
      response = html_response(conn, 200)
      assert response =~ "Zaloguj"
    end
  end

  describe "POST /logowanie" do
    test "logs the user in", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/logowanie", %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ ~p"/ustawienia"
      assert response =~ ~p"/wyloguj"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
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
        post(conn, ~p"/logowanie", %{
          "user" => %{"email" => user.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "Zaloguj"
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
