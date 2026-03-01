defmodule Przetargowi.Repo.Migrations.AddIsPremiumToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_premium, :boolean, default: false, null: false
    end
  end
end
