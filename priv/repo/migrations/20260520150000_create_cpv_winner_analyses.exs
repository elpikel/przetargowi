defmodule Przetargowi.Repo.Migrations.CreateCpvWinnerAnalyses do
  use Ecto.Migration

  def change do
    create table(:cpv_winner_analyses) do
      add :cpv_main, :string, null: false
      add :order_type, :string, null: false
      add :data, :map, null: false, default: %{}
      add :computed_at, :utc_datetime, null: false

      timestamps()
    end

    create unique_index(:cpv_winner_analyses, [:cpv_main, :order_type])
  end
end
