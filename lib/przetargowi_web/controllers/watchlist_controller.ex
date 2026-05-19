defmodule PrzetargowiWeb.WatchlistController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Payments
  alias Przetargowi.Watchlist

  plug :require_can_add_to_watchlist when action in [:create]

  def index(conn, _params) do
    user = conn.assigns.current_scope.user
    entries = Watchlist.list_user_watchlist(user.id)
    is_premium = Payments.has_alerts_access?(user.id)
    count = length(entries)
    limit = Watchlist.get_limit(user.id)

    render(conn, :index,
      entries: entries,
      is_premium: is_premium,
      count: count,
      limit: limit
    )
  end

  def create(conn, %{"tender_object_id" => tender_object_id}) do
    user = conn.assigns.current_scope.user

    case Watchlist.add_to_watchlist(user.id, tender_object_id) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, "Przetarg dodany do obserwowanych.")
        |> redirect_back()

      {:error, changeset} ->
        message =
          if Keyword.has_key?(changeset.errors, :user_id) do
            "Już obserwujesz ten przetarg."
          else
            "Nie udało się dodać przetargu do obserwowanych."
          end

        conn
        |> put_flash(:error, message)
        |> redirect_back()
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_scope.user

    case Watchlist.remove_from_watchlist(user.id, id) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, "Przetarg usunięty z obserwowanych.")
        |> redirect_back()

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Nie udało się usunąć przetargu z obserwowanych.")
        |> redirect_back()
    end
  end

  def delete_by_tender(conn, %{"tender_object_id" => tender_object_id}) do
    user = conn.assigns.current_scope.user

    case Watchlist.remove_by_tender(user.id, tender_object_id) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, "Przetarg usunięty z obserwowanych.")
        |> redirect_back()

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Nie udało się usunąć przetargu z obserwowanych.")
        |> redirect_back()
    end
  end

  defp require_can_add_to_watchlist(conn, _opts) do
    user = conn.assigns.current_scope.user
    tender_object_id = conn.params["tender_object_id"]

    # Allow through if already watching (will fail with duplicate error)
    # or if user can add more to watchlist
    if Watchlist.is_watching?(user.id, tender_object_id) or
         Watchlist.can_add_to_watchlist?(user.id) do
      conn
    else
      conn
      |> put_flash(
        :error,
        "Osiągnąłeś limit obserwowanych przetargów. Wybierz plan premium, aby obserwować więcej."
      )
      |> redirect_back()
      |> halt()
    end
  end

  defp redirect_back(conn) do
    referer = get_req_header(conn, "referer") |> List.first()

    if referer do
      redirect(conn, external: referer)
    else
      redirect(conn, to: ~p"/obserwowane")
    end
  end
end
