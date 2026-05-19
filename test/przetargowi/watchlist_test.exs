defmodule Przetargowi.WatchlistTest do
  use Przetargowi.DataCase

  alias Przetargowi.Watchlist
  alias Przetargowi.Watchlist.WatchlistEntry

  import Przetargowi.AccountsFixtures
  import Przetargowi.TendersFixtures
  import Przetargowi.WatchlistFixtures

  describe "list_user_watchlist/1" do
    test "returns watchlist entries for user" do
      user = user_fixture()
      tender = tender_notice_fixture()
      entry = watchlist_entry_fixture(user: user, tender: tender)

      assert [%WatchlistEntry{id: id}] = Watchlist.list_user_watchlist(user.id)
      assert id == entry.id
    end

    test "returns empty list when user has no entries" do
      user = user_fixture()
      assert Watchlist.list_user_watchlist(user.id) == []
    end

    test "does not return entries for other users" do
      user1 = user_fixture()
      user2 = user_fixture()
      tender = tender_notice_fixture()
      _entry = watchlist_entry_fixture(user: user1, tender: tender)

      assert Watchlist.list_user_watchlist(user2.id) == []
    end
  end

  describe "get_entry/2" do
    test "returns entry by id for user" do
      user = user_fixture()
      entry = watchlist_entry_fixture(user: user)

      assert %WatchlistEntry{id: id} = Watchlist.get_entry(user.id, entry.id)
      assert id == entry.id
    end

    test "returns nil for non-existent id" do
      user = user_fixture()
      assert Watchlist.get_entry(user.id, -1) == nil
    end

    test "returns nil if entry belongs to different user" do
      user1 = user_fixture()
      user2 = user_fixture()
      entry = watchlist_entry_fixture(user: user1)

      assert Watchlist.get_entry(user2.id, entry.id) == nil
    end
  end

  describe "is_watching?/2" do
    test "returns true when user is watching tender" do
      user = user_fixture()
      tender = tender_notice_fixture()
      _entry = watchlist_entry_fixture(user: user, tender: tender)

      assert Watchlist.is_watching?(user.id, tender.object_id)
    end

    test "returns false when user is not watching tender" do
      user = user_fixture()
      tender = tender_notice_fixture()

      refute Watchlist.is_watching?(user.id, tender.object_id)
    end
  end

  describe "add_to_watchlist/2" do
    test "adds tender to watchlist" do
      user = user_fixture()
      tender = tender_notice_fixture()

      assert {:ok, %WatchlistEntry{} = entry} =
               Watchlist.add_to_watchlist(user.id, tender.object_id)

      assert entry.user_id == user.id
      assert entry.tender_object_id == tender.object_id
    end

    test "fails when adding same tender twice" do
      user = user_fixture()
      tender = tender_notice_fixture()

      assert {:ok, _entry} = Watchlist.add_to_watchlist(user.id, tender.object_id)
      assert {:error, changeset} = Watchlist.add_to_watchlist(user.id, tender.object_id)
      assert %{user_id: _} = errors_on(changeset)
    end
  end

  describe "remove_from_watchlist/2" do
    test "removes entry from watchlist" do
      user = user_fixture()
      entry = watchlist_entry_fixture(user: user)

      assert {:ok, %WatchlistEntry{}} = Watchlist.remove_from_watchlist(user.id, entry.id)
      assert Watchlist.get_entry(user.id, entry.id) == nil
    end

    test "returns error when entry not found" do
      user = user_fixture()
      assert {:error, :not_found} = Watchlist.remove_from_watchlist(user.id, -1)
    end

    test "returns error when entry belongs to different user" do
      user1 = user_fixture()
      user2 = user_fixture()
      entry = watchlist_entry_fixture(user: user1)

      assert {:error, :not_found} = Watchlist.remove_from_watchlist(user2.id, entry.id)
    end
  end

  describe "remove_by_tender/2" do
    test "removes entry by tender object_id" do
      user = user_fixture()
      tender = tender_notice_fixture()
      _entry = watchlist_entry_fixture(user: user, tender: tender)

      assert {:ok, %WatchlistEntry{}} = Watchlist.remove_by_tender(user.id, tender.object_id)
      refute Watchlist.is_watching?(user.id, tender.object_id)
    end

    test "returns error when not watching tender" do
      user = user_fixture()
      tender = tender_notice_fixture()

      assert {:error, :not_found} = Watchlist.remove_by_tender(user.id, tender.object_id)
    end
  end

  describe "count_user_watchlist/1" do
    test "returns count of user's watchlist entries" do
      user = user_fixture()
      tender1 = tender_notice_fixture()
      tender2 = tender_notice_fixture()
      _entry1 = watchlist_entry_fixture(user: user, tender: tender1)
      _entry2 = watchlist_entry_fixture(user: user, tender: tender2)

      assert Watchlist.count_user_watchlist(user.id) == 2
    end

    test "returns 0 when user has no entries" do
      user = user_fixture()
      assert Watchlist.count_user_watchlist(user.id) == 0
    end
  end

  describe "get_watched_tender_ids/1" do
    test "returns list of watched tender object_ids" do
      user = user_fixture()
      tender1 = tender_notice_fixture()
      tender2 = tender_notice_fixture()
      _entry1 = watchlist_entry_fixture(user: user, tender: tender1)
      _entry2 = watchlist_entry_fixture(user: user, tender: tender2)

      ids = Watchlist.get_watched_tender_ids(user.id)
      assert length(ids) == 2
      assert tender1.object_id in ids
      assert tender2.object_id in ids
    end
  end

  describe "can_add_to_watchlist?/1" do
    test "returns true when user has less than limit" do
      user = user_fixture()
      assert Watchlist.can_add_to_watchlist?(user.id)
    end

    test "returns false when free user has 5 entries" do
      user = user_fixture()

      for _ <- 1..5 do
        tender = tender_notice_fixture()
        watchlist_entry_fixture(user: user, tender: tender)
      end

      refute Watchlist.can_add_to_watchlist?(user.id)
    end
  end

  describe "reminder queries" do
    test "get_pending_7_day_reminders returns entries with deadlines in 7 days" do
      user = user_fixture()
      seven_days_from_now = DateTime.add(DateTime.utc_now(), 5, :day)

      tender =
        tender_notice_fixture(submitting_offers_date: seven_days_from_now)

      _entry = watchlist_entry_fixture(user: user, tender: tender)

      entries = Watchlist.get_pending_7_day_reminders()
      assert length(entries) == 1
    end

    test "get_pending_1_day_reminders returns entries with deadlines in 1 day" do
      user = user_fixture()
      one_day_from_now = DateTime.add(DateTime.utc_now(), 12, :hour)

      tender =
        tender_notice_fixture(submitting_offers_date: one_day_from_now)

      _entry = watchlist_entry_fixture(user: user, tender: tender)

      entries = Watchlist.get_pending_1_day_reminders()
      assert length(entries) == 1
    end

    test "mark_7_day_reminder_sent updates the flag" do
      user = user_fixture()
      entry = watchlist_entry_fixture(user: user)

      assert {:ok, updated} = Watchlist.mark_7_day_reminder_sent(entry)
      assert updated.reminder_7_day_sent == true
    end

    test "mark_1_day_reminder_sent updates the flag" do
      user = user_fixture()
      entry = watchlist_entry_fixture(user: user)

      assert {:ok, updated} = Watchlist.mark_1_day_reminder_sent(entry)
      assert updated.reminder_1_day_sent == true
    end
  end
end
