defmodule Przetargowi.Alerts do
  @moduledoc """
  Context module for managing user alerts.
  """

  import Ecto.Query

  alias Przetargowi.Alerts.Alert
  alias Przetargowi.Repo

  require Logger

  @doc """
  Gets all alerts for a user.
  """
  def list_user_alerts(user_id) do
    Alert
    |> where([a], a.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single alert by ID.
  """
  def get_alert(id), do: Repo.get(Alert, id)

  @doc """
  Gets a single alert by ID for a specific user.
  Returns nil if the alert doesn't belong to the user.
  """
  def get_user_alert(user_id, alert_id) do
    Alert
    |> where([a], a.id == ^alert_id and a.user_id == ^user_id)
    |> Repo.one()
  end

  @doc """
  Creates an alert.

  ## Examples

      iex> create_alert(%{user_id: 1, rules: %{region: "mazowieckie", tender_category: "Dostawy"}})
      {:ok, %Alert{}}

      iex> create_alert(%{user_id: 1, rules: %{}})
      {:error, %Ecto.Changeset{}}
  """
  def create_alert(attrs) do
    %Alert{}
    |> Alert.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a simple alert for free plan users.
  """
  def create_simple_alert(attrs) do
    %Alert{}
    |> Alert.simple_alert_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a premium alert for paid plan users.
  """
  def create_premium_alert(attrs) do
    %Alert{}
    |> Alert.premium_alert_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an alert.

  ## Examples

      iex> update_alert(alert, %{rules: %{region: "malopolskie", tender_category: "Usługi"}})
      {:ok, %Alert{}}
  """
  def update_alert(%Alert{} = alert, attrs) do
    alert
    |> Alert.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an alert.

  ## Examples

      iex> delete_alert(alert)
      {:ok, %Alert{}}
  """
  def delete_alert(%Alert{} = alert) do
    Repo.delete(alert)
  end

  @doc """
  Deletes an alert by ID for a specific user.
  Returns {:ok, alert} if deleted, {:error, :not_found} if not found.
  """
  def delete_user_alert(user_id, alert_id) do
    case get_user_alert(user_id, alert_id) do
      nil -> {:error, :not_found}
      alert -> Repo.delete(alert)
    end
  end

  @doc """
  Deletes all premium alerts for a user.
  Premium alerts have the format: %{industries: [], regions: [], keywords: []}
  Simple alerts have the format: %{region: "...", tender_category: "..."}
  """
  def delete_premium_alerts(user_id) do
    alerts = list_user_alerts(user_id)

    deleted_count =
      alerts
      |> Enum.filter(&is_premium_alert?/1)
      |> Enum.reduce(0, fn alert, acc ->
        case Repo.delete(alert) do
          {:ok, _} -> acc + 1
          {:error, _} -> acc
        end
      end)

    {:ok, deleted_count}
  end

  @doc """
  Counts the number of alerts for a user.
  """
  def count_user_alerts(user_id) do
    Alert
    |> where([a], a.user_id == ^user_id)
    |> select([a], count(a.id))
    |> Repo.one()
  end

  @doc """
  Checks if a user can create a free alert (limit: 1).
  """
  def can_create_free_alert?(user_id) do
    count_user_alerts(user_id) < 1
  end

  @doc """
  Gets all alerts that need to be processed (for sending notifications).
  Returns alerts that haven't been sent today.
  """
  def get_pending_alerts do
    today = Date.utc_today()
    start_of_today = DateTime.new!(today, ~T[00:00:00], "Etc/UTC")

    Alert
    |> where([a], is_nil(a.last_sent_at) or a.last_sent_at < ^start_of_today)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Marks an alert as sent.
  """
  def mark_alert_sent(%Alert{} = alert) do
    alert
    |> Alert.changeset(%{last_sent_at: DateTime.utc_now()})
    |> Repo.update()
  end

  defp is_premium_alert?(%Alert{rules: rules}) do
    # Premium alerts have industries, regions, keywords structure
    Map.has_key?(rules, :industries) or Map.has_key?(rules, "industries") or
      Map.has_key?(rules, :keywords) or Map.has_key?(rules, "keywords")
  end
end
