defmodule Przetargowi.Workers.SendWatchlistRemindersTest do
  use Przetargowi.DataCase
  use Oban.Testing, repo: Przetargowi.Repo

  alias Przetargowi.Workers.SendWatchlistReminders
  alias Przetargowi.Watchlist

  import Przetargowi.AccountsFixtures
  import Przetargowi.TendersFixtures
  import Przetargowi.WatchlistFixtures

  # Drain all emails from mailbox
  defp flush_emails do
    receive do
      {:email, _} -> flush_emails()
    after
      0 -> :ok
    end
  end

  # Check if an email with subject was sent
  defp email_sent_with_subject?(subject) do
    receive do
      {:email, %{subject: ^subject}} -> true
    after
      100 -> false
    end
  end

  describe "perform/1" do
    test "sends 7-day reminders for entries with deadlines in 7 days" do
      user = user_fixture()
      seven_days_from_now = DateTime.add(DateTime.utc_now(), 5, :day)

      tender = tender_notice_fixture(submitting_offers_date: seven_days_from_now)
      _entry = watchlist_entry_fixture(user: user, tender: tender)

      flush_emails()

      assert :ok = perform_job(SendWatchlistReminders, %{})

      assert email_sent_with_subject?("Przypomnienie: terminy przetargów za 7 dni - Przetargowi")
    end

    test "sends 1-day reminders for entries with deadlines in 1 day" do
      user = user_fixture()
      one_day_from_now = DateTime.add(DateTime.utc_now(), 12, :hour)

      tender = tender_notice_fixture(submitting_offers_date: one_day_from_now)
      _entry = watchlist_entry_fixture(user: user, tender: tender)

      flush_emails()

      assert :ok = perform_job(SendWatchlistReminders, %{})

      assert email_sent_with_subject?("PILNE: terminy przetargów jutro! - Przetargowi")
    end

    test "marks 7-day reminder as sent after sending" do
      user = user_fixture()
      seven_days_from_now = DateTime.add(DateTime.utc_now(), 5, :day)

      tender = tender_notice_fixture(submitting_offers_date: seven_days_from_now)
      entry = watchlist_entry_fixture(user: user, tender: tender)

      refute entry.reminder_7_day_sent

      assert :ok = perform_job(SendWatchlistReminders, %{})

      updated_entry = Watchlist.get_entry(user.id, entry.id)
      assert updated_entry.reminder_7_day_sent
    end

    test "marks 1-day reminder as sent after sending" do
      user = user_fixture()
      one_day_from_now = DateTime.add(DateTime.utc_now(), 12, :hour)

      tender = tender_notice_fixture(submitting_offers_date: one_day_from_now)
      entry = watchlist_entry_fixture(user: user, tender: tender)

      refute entry.reminder_1_day_sent

      assert :ok = perform_job(SendWatchlistReminders, %{})

      updated_entry = Watchlist.get_entry(user.id, entry.id)
      assert updated_entry.reminder_1_day_sent
    end

    test "does not send reminder if already sent" do
      user = user_fixture()
      seven_days_from_now = DateTime.add(DateTime.utc_now(), 5, :day)

      tender = tender_notice_fixture(submitting_offers_date: seven_days_from_now)
      entry = watchlist_entry_fixture(user: user, tender: tender)

      # Mark as already sent
      {:ok, _} = Watchlist.mark_7_day_reminder_sent(entry)

      flush_emails()

      assert :ok = perform_job(SendWatchlistReminders, %{})

      # No 7-day reminder email should be sent
      refute email_sent_with_subject?("Przypomnienie: terminy przetargów za 7 dni - Przetargowi")
    end

    test "groups multiple entries by user and sends single email" do
      user = user_fixture()
      seven_days_from_now = DateTime.add(DateTime.utc_now(), 5, :day)

      tender1 = tender_notice_fixture(submitting_offers_date: seven_days_from_now)
      tender2 = tender_notice_fixture(submitting_offers_date: seven_days_from_now)
      _entry1 = watchlist_entry_fixture(user: user, tender: tender1)
      _entry2 = watchlist_entry_fixture(user: user, tender: tender2)

      flush_emails()

      assert :ok = perform_job(SendWatchlistReminders, %{})

      # One reminder email should be sent
      assert email_sent_with_subject?("Przypomnienie: terminy przetargów za 7 dni - Przetargowi")

      # No second reminder email (entries grouped by user)
      refute email_sent_with_subject?("Przypomnienie: terminy przetargów za 7 dni - Przetargowi")
    end

    test "sends separate emails to different users" do
      user1 = user_fixture()
      user2 = user_fixture()
      seven_days_from_now = DateTime.add(DateTime.utc_now(), 5, :day)

      tender = tender_notice_fixture(submitting_offers_date: seven_days_from_now)
      _entry1 = watchlist_entry_fixture(user: user1, tender: tender)

      tender2 = tender_notice_fixture(submitting_offers_date: seven_days_from_now)
      _entry2 = watchlist_entry_fixture(user: user2, tender: tender2)

      flush_emails()

      assert :ok = perform_job(SendWatchlistReminders, %{})

      # Two separate reminder emails should be sent
      assert email_sent_with_subject?("Przypomnienie: terminy przetargów za 7 dni - Przetargowi")
      assert email_sent_with_subject?("Przypomnienie: terminy przetargów za 7 dni - Przetargowi")
    end

    test "returns :ok even when no entries to process" do
      flush_emails()

      assert :ok = perform_job(SendWatchlistReminders, %{})

      # No reminder emails should be sent
      refute email_sent_with_subject?("Przypomnienie: terminy przetargów za 7 dni - Przetargowi")
      refute email_sent_with_subject?("PILNE: terminy przetargów jutro! - Przetargowi")
    end

    test "does not process entries with past deadlines" do
      user = user_fixture()
      past_deadline = DateTime.add(DateTime.utc_now(), -1, :day)

      tender = tender_notice_fixture(submitting_offers_date: past_deadline)
      _entry = watchlist_entry_fixture(user: user, tender: tender)

      flush_emails()

      assert :ok = perform_job(SendWatchlistReminders, %{})

      # No reminder emails should be sent
      refute email_sent_with_subject?("Przypomnienie: terminy przetargów za 7 dni - Przetargowi")
      refute email_sent_with_subject?("PILNE: terminy przetargów jutro! - Przetargowi")
    end

    test "does not process entries with deadlines too far in the future" do
      user = user_fixture()
      far_future = DateTime.add(DateTime.utc_now(), 30, :day)

      tender = tender_notice_fixture(submitting_offers_date: far_future)
      _entry = watchlist_entry_fixture(user: user, tender: tender)

      flush_emails()

      assert :ok = perform_job(SendWatchlistReminders, %{})

      # No reminder emails should be sent
      refute email_sent_with_subject?("Przypomnienie: terminy przetargów za 7 dni - Przetargowi")
      refute email_sent_with_subject?("PILNE: terminy przetargów jutro! - Przetargowi")
    end
  end

  describe "job enqueueing" do
    test "can enqueue job" do
      assert {:ok, _job} =
               SendWatchlistReminders.new(%{})
               |> Oban.insert()
    end

    test "uses alerts queue" do
      {:ok, job} =
        SendWatchlistReminders.new(%{})
        |> Oban.insert()

      assert job.queue == "alerts"
    end
  end
end
