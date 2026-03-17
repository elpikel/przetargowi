defmodule PrzetargowiWeb.UserPasswordResetController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Accounts

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_password_reset_instructions(
        user,
        &url(~p"/resetuj-haslo/#{&1}")
      )
    end

    # Always show success message to prevent email enumeration
    conn
    |> put_flash(
      :info,
      "Jeśli ten adres e-mail istnieje w naszym systemie, otrzymasz wkrótce instrukcje resetowania hasła."
    )
    |> render(:email_sent)
  end

  def edit(conn, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      changeset = Accounts.change_user_password(user)
      render(conn, :edit, changeset: changeset, token: token)
    else
      conn
      |> put_flash(:error, "Link do resetowania hasła jest nieprawidłowy lub wygasł.")
      |> redirect(to: ~p"/zapomnialem-hasla")
    end
  end

  def update(conn, %{"token" => token, "user" => user_params}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      case Accounts.reset_user_password(user, user_params) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "Hasło zostało zmienione. Możesz się teraz zalogować.")
          |> redirect(to: ~p"/logowanie")

        {:error, changeset} ->
          render(conn, :edit, changeset: changeset, token: token)
      end
    else
      conn
      |> put_flash(:error, "Link do resetowania hasła jest nieprawidłowy lub wygasł.")
      |> redirect(to: ~p"/zapomnialem-hasla")
    end
  end
end
