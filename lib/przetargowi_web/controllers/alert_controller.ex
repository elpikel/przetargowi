defmodule PrzetargowiWeb.AlertController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Alerts

  def index(conn, _params) do
    user = conn.assigns.current_scope.user
    alerts = Alerts.list_user_alerts(user.id)

    render(conn, :index, alerts: alerts)
  end

  def create(conn, %{"alert" => alert_params}) do
    user = conn.assigns.current_scope.user

    # Transform form params to match changeset expectations
    regions = alert_params["regions"] || []
    order_types = alert_params["order_types"] || []

    attrs = %{
      "user_id" => user.id,
      "region" => List.first(regions),
      "tender_category" => List.first(order_types)
    }

    case Alerts.create_simple_alert(attrs) do
      {:ok, _alert} ->
        conn
        |> put_flash(:info, "Alert został utworzony!")
        |> redirect(to: ~p"/przetargi")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Nie udało się utworzyć alertu.")
        |> redirect(to: ~p"/przetargi")
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
end
