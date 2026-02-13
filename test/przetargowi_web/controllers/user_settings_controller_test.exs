defmodule PrzetargowiWeb.UserSettingsControllerTest do
  use PrzetargowiWeb.ConnCase, async: true

  alias Przetargowi.Accounts
  import Przetargowi.AccountsFixtures

  setup :register_and_log_in_user

  describe "GET /ustawienia" do
    test "renders settings page", %{conn: conn} do
      conn = get(conn, ~p"/ustawienia")
      response = html_response(conn, 200)
      assert response =~ "Ustawienia konta"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = get(conn, ~p"/ustawienia")
      assert redirected_to(conn) == ~p"/logowanie"
    end

    @tag token_authenticated_at: DateTime.add(DateTime.utc_now(:second), -11, :minute)
    test "redirects if user is not in sudo mode", %{conn: conn} do
      conn = get(conn, ~p"/ustawienia")
      assert redirected_to(conn) == ~p"/logowanie"
    end
  end

  describe "PUT /ustawienia (change password form)" do
    test "updates the user password and resets tokens", %{conn: conn, user: user} do
      new_password_conn =
        put(conn, ~p"/ustawienia", %{
          "action" => "update_password",
          "user" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(new_password_conn) == ~p"/ustawienia"

      assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)

      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "does not update password on invalid data", %{conn: conn} do
      old_password_conn =
        put(conn, ~p"/ustawienia", %{
          "action" => "update_password",
          "user" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(old_password_conn, 200)
      assert response =~ "Ustawienia konta"
      assert response =~ "should be at least 12 character(s)"
      assert response =~ "does not match password"

      assert get_session(old_password_conn, :user_token) == get_session(conn, :user_token)
    end
  end

  describe "PUT /ustawienia (change email form)" do
    @tag :capture_log
    test "updates the user email", %{conn: conn, user: user} do
      conn =
        put(conn, ~p"/ustawienia", %{
          "action" => "update_email",
          "user" => %{"email" => unique_user_email()}
        })

      assert redirected_to(conn) == ~p"/ustawienia"

      assert Accounts.get_user_by_email(user.email)
    end

    test "does not update email on invalid data", %{conn: conn} do
      conn =
        put(conn, ~p"/ustawienia", %{
          "action" => "update_email",
          "user" => %{"email" => "with spaces"}
        })

      response = html_response(conn, 200)
      assert response =~ "Ustawienia konta"
      assert response =~ "must have the @ sign and no spaces"
    end
  end

  describe "GET /ustawienia/potwierdz-email/:token" do
    setup %{user: user} do
      email = unique_user_email()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_update_email_instructions(%{user | email: email}, user.email, url)
        end)

      %{token: token, email: email}
    end

    test "updates the user email once", %{conn: conn, user: user, token: token, email: email} do
      conn = get(conn, ~p"/ustawienia/potwierdz-email/#{token}")
      assert redirected_to(conn) == ~p"/ustawienia"

      refute Accounts.get_user_by_email(user.email)
      assert Accounts.get_user_by_email(email)

      conn = get(conn, ~p"/ustawienia/potwierdz-email/#{token}")

      assert redirected_to(conn) == ~p"/ustawienia"
    end

    test "does not update email with invalid token", %{conn: conn, user: user} do
      conn = get(conn, ~p"/ustawienia/potwierdz-email/oops")
      assert redirected_to(conn) == ~p"/ustawienia"

      assert Accounts.get_user_by_email(user.email)
    end

    test "redirects if user is not logged in", %{token: token} do
      conn = build_conn()
      conn = get(conn, ~p"/ustawienia/potwierdz-email/#{token}")
      assert redirected_to(conn) == ~p"/logowanie"
    end
  end
end
