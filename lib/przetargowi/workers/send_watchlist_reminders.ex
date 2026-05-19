defmodule Przetargowi.Workers.SendWatchlistReminders do
  @moduledoc """
  Oban worker that sends deadline reminder emails for watched tenders.
  Sends reminders at two stages:
  - 7 days before deadline
  - 1 day before deadline
  """
  use Oban.Worker,
    queue: :alerts,
    max_attempts: 3,
    unique: [period: 3600]

  alias Przetargowi.Mailer
  alias Przetargowi.Watchlist
  alias Przetargowi.Watchlist.WatchlistReminderEmail

  require Logger

  @impl Oban.Worker
  def perform(_) do
    send_7_day_reminders()
    send_1_day_reminders()
    :ok
  end

  defp send_7_day_reminders do
    entries = Watchlist.get_pending_7_day_reminders()
    Logger.info("Found #{length(entries)} entries needing 7-day reminders")

    entries
    |> group_by_user()
    |> Enum.each(fn {user, user_entries} ->
      send_reminder_email(user, user_entries, :seven_day)
      mark_entries_as_sent(user_entries, :seven_day)
    end)
  end

  defp send_1_day_reminders do
    entries = Watchlist.get_pending_1_day_reminders()
    Logger.info("Found #{length(entries)} entries needing 1-day reminders")

    entries
    |> group_by_user()
    |> Enum.each(fn {user, user_entries} ->
      send_reminder_email(user, user_entries, :one_day)
      mark_entries_as_sent(user_entries, :one_day)
    end)
  end

  defp group_by_user(entries) do
    entries
    |> Enum.group_by(& &1.user)
    |> Enum.to_list()
  end

  defp send_reminder_email(user, entries, reminder_type) do
    Logger.info(
      "Sending #{reminder_type} reminder to #{user.email} for #{length(entries)} tenders"
    )

    user.email
    |> WatchlistReminderEmail.compose(entries, reminder_type)
    |> Mailer.deliver()
    |> case do
      {:ok, _} ->
        Logger.info("Reminder email sent successfully to #{user.email}")

      {:error, reason} ->
        Logger.error("Failed to send reminder email to #{user.email}: #{inspect(reason)}")
    end
  end

  defp mark_entries_as_sent(entries, :seven_day) do
    Enum.each(entries, fn entry ->
      case Watchlist.mark_7_day_reminder_sent(entry) do
        {:ok, _} -> :ok
        {:error, reason} -> Logger.error("Failed to mark entry #{entry.id} as sent: #{inspect(reason)}")
      end
    end)
  end

  defp mark_entries_as_sent(entries, :one_day) do
    Enum.each(entries, fn entry ->
      case Watchlist.mark_1_day_reminder_sent(entry) do
        {:ok, _} -> :ok
        {:error, reason} -> Logger.error("Failed to mark entry #{entry.id} as sent: #{inspect(reason)}")
      end
    end)
  end
end
