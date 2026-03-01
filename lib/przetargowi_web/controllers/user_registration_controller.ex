defmodule PrzetargowiWeb.UserRegistrationController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Accounts
  alias Przetargowi.Accounts.User
  alias PrzetargowiWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_confirmation_instructions(
            user,
            &url(~p"/rejestracja/potwierdz/#{&1}")
          )

        conn
        |> put_flash(:info, "Sprawdź swoją skrzynkę email i kliknij link, aby potwierdzić konto.")
        |> render(:confirmation_sent, email: user.email)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def confirm(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Konto zostało potwierdzone. Aktywuj Premium, aby korzystać ze wszystkich funkcji.")
        |> put_session(:user_return_to, ~p"/subskrypcja/nowa")
        |> UserAuth.log_in_user(user)

      :error ->
        conn
        |> put_flash(:error, "Link potwierdzający jest nieprawidłowy lub wygasł.")
        |> redirect(to: ~p"/rejestracja")
    end
  end
end
