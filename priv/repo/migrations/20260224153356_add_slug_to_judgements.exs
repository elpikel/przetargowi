defmodule Przetargowi.Repo.Migrations.AddSlugToJudgements do
  use Ecto.Migration

  def change do
    alter table(:judgements) do
      add :slug, :string
    end
  end
end
