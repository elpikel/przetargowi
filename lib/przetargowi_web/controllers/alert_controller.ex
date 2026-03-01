defmodule PrzetargowiWeb.AlertController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Alerts
  alias Przetargowi.Payments

  plug :require_alerts_access when action in [:index, :new, :create, :delete]

  def index(conn, _params) do
    user = conn.assigns.current_scope.user
    alerts = Alerts.list_user_alerts(user.id)
    is_premium = Payments.has_alerts_access?(user.id)

    render(conn, :index, alerts: alerts, is_premium: is_premium)
  end

  def new(conn, _params) do
    user = conn.assigns.current_scope.user
    is_premium = Payments.has_alerts_access?(user.id)

    render(conn, :new, is_premium: is_premium)
  end

  def create(conn, %{"alert" => alert_params}) do
    user = conn.assigns.current_scope.user
    is_premium = Payments.has_alerts_access?(user.id)

    attrs = Map.put(alert_params, "user_id", user.id)

    result =
      if is_premium do
        Alerts.create_premium_alert(attrs)
      else
        Alerts.create_simple_alert(attrs)
      end

    case result do
      {:ok, _alert} ->
        conn
        |> put_flash(:info, "Alert został utworzony pomyślnie!")
        |> redirect(to: ~p"/alerty")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Nie udało się utworzyć alertu. Sprawdź wymagane pola.")
        |> redirect(to: ~p"/alerty/nowy")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_scope.user

    case Alerts.delete_user_alert(user.id, id) do
      {:ok, _alert} ->
        conn
        |> put_flash(:info, "Alert został usunięty.")
        |> redirect(to: ~p"/alerty")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Nie udało się usunąć alertu.")
        |> redirect(to: ~p"/alerty")
    end
  end

  defp require_alerts_access(conn, _opts) do
    user = conn.assigns.current_scope.user

    if Payments.has_alerts_access?(user.id) do
      conn
    else
      conn
      |> put_flash(:error, "Aby korzystać z alertów, wybierz plan Alerty lub Razem.")
      |> redirect(to: ~p"/subskrypcja/nowa")
      |> halt()
    end
  end
end
