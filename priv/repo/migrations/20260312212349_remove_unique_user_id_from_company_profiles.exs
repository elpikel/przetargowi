defmodule Przetargowi.Repo.Migrations.RemoveUniqueUserIdFromCompanyProfiles do
  use Ecto.Migration

  def change do
    drop unique_index(:company_profiles, [:user_id])
    create index(:company_profiles, [:user_id])
  end
end
