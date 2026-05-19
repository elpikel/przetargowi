defmodule Przetargowi.Repo.Migrations.CreateWatchlistEntries do
  use Ecto.Migration

  def change do
    create table(:watchlist_entries) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :tender_object_id, :string, null: false
      add :notes, :text
      add :reminder_7_day_sent, :boolean, default: false, null: false
      add :reminder_1_day_sent, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:watchlist_entries, [:user_id])
    create index(:watchlist_entries, [:tender_object_id])
    create unique_index(:watchlist_entries, [:user_id, :tender_object_id])
  end
end
