defmodule PrzetargowiWeb.UserSettingsController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Accounts
  alias Przetargowi.Alerts
  alias Przetargowi.Payments
  alias PrzetargowiWeb.UserAuth

  import PrzetargowiWeb.UserAuth, only: [require_sudo_mode: 2]

  plug :require_sudo_mode
  plug :assign_email_and_password_changesets
  plug :assign_subscription
  plug :assign_alerts

  def edit(conn, _params) do
    render(conn, :edit)
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"user" => user_params} = params
    user = conn.assigns.current_scope.user

    case Accounts.change_user_email(user, user_params) do
      %{valid?: true} = changeset ->
        Accounts.deliver_user_update_email_instructions(
          Ecto.Changeset.apply_action!(changeset, :insert),
          user.email,
          &url(~p"/ustawienia/potwierdz-email/#{&1}")
        )

        conn
        |> put_flash(
          :info,
          "Link potwierdzający zmianę email został wysłany na nowy adres."
        )
        |> redirect(to: ~p"/ustawienia")

      changeset ->
        render(conn, :edit, email_changeset: %{changeset | action: :insert})
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"user" => user_params} = params
    user = conn.assigns.current_scope.user

    case Accounts.update_user_password(user, user_params) do
      {:ok, {user, _}} ->
        conn
        |> put_flash(:info, "Hasło zostało zmienione.")
        |> put_session(:user_return_to, ~p"/ustawienia")
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, :edit, password_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_scope.user, token) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Email został zmieniony.")
        |> redirect(to: ~p"/ustawienia")

      {:error, _} ->
        conn
        |> put_flash(:error, "Link zmiany email jest nieprawidłowy lub wygasł.")
        |> redirect(to: ~p"/ustawienia")
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_scope.user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end

  defp assign_subscription(conn, _opts) do
    user = conn.assigns.current_scope.user
    subscription = Payments.get_user_subscription(user.id)
    assign(conn, :subscription, subscription)
  end

  defp assign_alerts(conn, _opts) do
    user = conn.assigns.current_scope.user
    has_alerts_access = Payments.has_alerts_access?(user.id)
    alerts = if has_alerts_access, do: Alerts.list_user_alerts(user.id), else: []

    conn
    |> assign(:has_alerts_access, has_alerts_access)
    |> assign(:alerts, alerts)
  end
end
