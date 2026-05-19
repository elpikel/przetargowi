defmodule Przetargowi.Watchlist do
  @moduledoc """
  Context module for managing user watchlist entries.
  Users can save tenders to track their deadlines.
  """

  import Ecto.Query

  alias Przetargowi.Payments
  alias Przetargowi.Repo
  alias Przetargowi.Watchlist.WatchlistEntry

  @free_limit 1

  @doc """
  Lists all watchlist entries for a user with preloaded tender data.
  Orders by deadline (closest first), then by added date.
  """
  def list_user_watchlist(user_id) do
    WatchlistEntry
    |> where([w], w.user_id == ^user_id)
    |> preload(:tender_notice)
    |> order_by([w], desc: w.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single watchlist entry by ID for a specific user.
  Returns nil if the entry doesn't belong to the user.
  """
  def get_entry(user_id, entry_id) do
    WatchlistEntry
    |> where([w], w.id == ^entry_id and w.user_id == ^user_id)
    |> preload(:tender_notice)
    |> Repo.one()
  end

  @doc """
  Gets a watchlist entry by tender object_id for a specific user.
  """
  def get_entry_by_tender(user_id, tender_object_id) do
    WatchlistEntry
    |> where([w], w.user_id == ^user_id and w.tender_object_id == ^tender_object_id)
    |> Repo.one()
  end

  @doc """
  Checks if a user is watching a specific tender.
  """
  def is_watching?(user_id, tender_object_id) do
    WatchlistEntry
    |> where([w], w.user_id == ^user_id and w.tender_object_id == ^tender_object_id)
    |> Repo.exists?()
  end

  @doc """
  Returns a list of tender object_ids that the user is watching.
  Useful for marking tenders in listing view.
  """
  def get_watched_tender_ids(user_id) do
    WatchlistEntry
    |> where([w], w.user_id == ^user_id)
    |> select([w], w.tender_object_id)
    |> Repo.all()
  end

  @doc """
  Adds a tender to the user's watchlist.
  """
  def add_to_watchlist(user_id, tender_object_id, attrs \\ %{}) do
    attrs = Map.merge(attrs, %{user_id: user_id, tender_object_id: tender_object_id})

    %WatchlistEntry{}
    |> WatchlistEntry.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Removes a tender from the user's watchlist by entry ID.
  """
  def remove_from_watchlist(user_id, entry_id) do
    case get_entry(user_id, entry_id) do
      nil -> {:error, :not_found}
      entry -> Repo.delete(entry)
    end
  end

  @doc """
  Removes a tender from the user's watchlist by tender object_id.
  """
  def remove_by_tender(user_id, tender_object_id) do
    case get_entry_by_tender(user_id, tender_object_id) do
      nil -> {:error, :not_found}
      entry -> Repo.delete(entry)
    end
  end

  @doc """
  Counts the number of watchlist entries for a user.
  """
  def count_user_watchlist(user_id) do
    WatchlistEntry
    |> where([w], w.user_id == ^user_id)
    |> select([w], count(w.id))
    |> Repo.one()
  end

  @doc """
  Checks if a user can add more items to their watchlist.
  Free users: max #{@free_limit} entries
  Premium users: unlimited
  """
  def can_add_to_watchlist?(user_id) do
    if Payments.has_alerts_access?(user_id) do
      true
    else
      count_user_watchlist(user_id) < @free_limit
    end
  end

  @doc """
  Returns the watchlist limit for a user.
  Returns nil for premium users (unlimited).
  """
  def get_limit(user_id) do
    if Payments.has_alerts_access?(user_id) do
      nil
    else
      @free_limit
    end
  end

  @doc """
  Gets watchlist entries that need 7-day reminders sent.
  Returns entries where:
  - reminder_7_day_sent is false
  - tender deadline is within 7 days (but more than 1 day)
  - tender is still active (deadline not passed)
  """
  def get_pending_7_day_reminders do
    now = DateTime.utc_now()
    seven_days = DateTime.add(now, 7, :day)
    one_day = DateTime.add(now, 1, :day)

    WatchlistEntry
    |> where([w], w.reminder_7_day_sent == false)
    |> join(:inner, [w], t in assoc(w, :tender_notice))
    |> where([w, t], t.submitting_offers_date > ^now)
    |> where([w, t], t.submitting_offers_date <= ^seven_days)
    |> where([w, t], t.submitting_offers_date > ^one_day)
    |> preload([:user, :tender_notice])
    |> Repo.all()
  end

  @doc """
  Gets watchlist entries that need 1-day reminders sent.
  Returns entries where:
  - reminder_1_day_sent is false
  - tender deadline is within 1 day
  - tender is still active (deadline not passed)
  """
  def get_pending_1_day_reminders do
    now = DateTime.utc_now()
    one_day = DateTime.add(now, 1, :day)

    WatchlistEntry
    |> where([w], w.reminder_1_day_sent == false)
    |> join(:inner, [w], t in assoc(w, :tender_notice))
    |> where([w, t], t.submitting_offers_date > ^now)
    |> where([w, t], t.submitting_offers_date <= ^one_day)
    |> preload([:user, :tender_notice])
    |> Repo.all()
  end

  @doc """
  Marks an entry's 7-day reminder as sent.
  """
  def mark_7_day_reminder_sent(%WatchlistEntry{} = entry) do
    entry
    |> WatchlistEntry.reminder_changeset(%{reminder_7_day_sent: true})
    |> Repo.update()
  end

  @doc """
  Marks an entry's 1-day reminder as sent.
  """
  def mark_1_day_reminder_sent(%WatchlistEntry{} = entry) do
    entry
    |> WatchlistEntry.reminder_changeset(%{reminder_1_day_sent: true})
    |> Repo.update()
  end
end
