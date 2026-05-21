defmodule Przetargowi.Repo.Migrations.AddProvinceToCpvWinnerAnalyses do
  use Ecto.Migration

  def change do
    alter table(:cpv_winner_analyses) do
      add :province, :string, null: false, default: ""
    end

    drop unique_index(:cpv_winner_analyses, [:cpv_main, :order_type])
    create unique_index(:cpv_winner_analyses, [:cpv_main, :order_type, :province])
  end
end
