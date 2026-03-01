defmodule PrzetargowiWeb.AlertController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Alerts
  alias Przetargowi.Payments

  plug :require_can_create_alert when action in [:new, :create]

  def index(conn, _params) do
    user = conn.assigns.current_scope.user
    alerts = Alerts.list_user_alerts(user.id)
    is_premium = Payments.has_alerts_access?(user.id)
    can_create = is_premium or Alerts.can_create_free_alert?(user.id)

    render(conn, :index, alerts: alerts, is_premium: is_premium, can_create: can_create)
  end

  def new(conn, params) do
    user = conn.assigns.current_scope.user
    is_premium = Payments.has_alerts_access?(user.id)

    render(conn, :new,
      is_premium: is_premium,
      keywords: params["keywords"] || "",
      regions: params["regions"] || [],
      order_types: params["order_types"] || []
    )
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

  defp require_can_create_alert(conn, _opts) do
    user = conn.assigns.current_scope.user
    is_premium = Payments.has_alerts_access?(user.id)
    can_create_free = Alerts.can_create_free_alert?(user.id)

    if is_premium or can_create_free do
      conn
    else
      conn
      |> put_flash(
        :error,
        "Osiągnąłeś limit darmowych alertów. Wybierz plan Alerty lub Razem, aby tworzyć więcej."
      )
      |> redirect(to: ~p"/alerty")
      |> halt()
    end
  end
end
