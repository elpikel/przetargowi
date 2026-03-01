defmodule Przetargowi.Repo.Migrations.AddSlugToTenderNotices do
  use Ecto.Migration

  def change do
    alter table(:tender_notices) do
      add :slug, :string
    end
  end
end
