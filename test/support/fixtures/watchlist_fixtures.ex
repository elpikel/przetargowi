defmodule Przetargowi.WatchlistFixtures do
  @moduledoc """
  Test helpers for creating entities via the `Przetargowi.Watchlist` context.
  """

  alias Przetargowi.Repo
  alias Przetargowi.Watchlist.WatchlistEntry

  import Przetargowi.AccountsFixtures
  import Przetargowi.TendersFixtures

  def valid_watchlist_entry_attributes(attrs \\ %{}) do
    user = attrs[:user] || user_fixture()
    tender = attrs[:tender] || tender_notice_fixture()

    Enum.into(attrs, %{
      user_id: user.id,
      tender_object_id: tender.object_id,
      notes: nil,
      reminder_7_day_sent: false,
      reminder_1_day_sent: false
    })
    |> Map.drop([:user, :tender])
  end

  def watchlist_entry_fixture(attrs \\ %{}) do
    attrs = valid_watchlist_entry_attributes(attrs)

    %WatchlistEntry{}
    |> WatchlistEntry.create_changeset(attrs)
    |> Repo.insert!()
    |> Repo.preload(:tender_notice)
  end
end
