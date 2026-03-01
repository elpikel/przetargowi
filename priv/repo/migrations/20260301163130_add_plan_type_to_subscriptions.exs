defmodule Przetargowi.Repo.Migrations.AddPlanTypeToSubscriptions do
  use Ecto.Migration

  def change do
    alter table(:subscriptions) do
      add :plan_type, :string, default: "razem"
    end

    create index(:subscriptions, [:plan_type])
  end
end
