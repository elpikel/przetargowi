defmodule Przetargowi.Repo.Migrations.CreateAlerts do
  use Ecto.Migration

  def change do
    create table(:alerts) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :rules, :map, null: false
      add :last_sent_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:alerts, [:user_id])
  end
end
