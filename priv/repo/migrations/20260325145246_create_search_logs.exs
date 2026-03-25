defmodule Przetargowi.Repo.Migrations.CreateSearchLogs do
  use Ecto.Migration

  def change do
    create table(:search_logs) do
      add :query, :string
      add :source, :string, null: false
      add :filters, :map, default: %{}
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:search_logs, [:source])
    create index(:search_logs, [:inserted_at])
    create index(:search_logs, [:user_id])
  end
end
