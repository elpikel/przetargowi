defmodule PrzetargowiWeb.UserRegistrationController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Accounts
  alias Przetargowi.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_email(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/logowanie/#{&1}")
          )

        conn
        |> put_flash(
          :info,
          "Email został wysłany na adres #{user.email}. Kliknij link w wiadomości, aby potwierdzić konto."
        )
        |> redirect(to: ~p"/logowanie")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
