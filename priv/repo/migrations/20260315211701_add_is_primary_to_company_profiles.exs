defmodule Przetargowi.Repo.Migrations.AddIsPrimaryToCompanyProfiles do
  use Ecto.Migration

  def change do
    alter table(:company_profiles) do
      add :is_primary, :boolean, default: false, null: false
    end
  end
end
