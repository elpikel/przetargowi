defmodule Przetargowi.Repo.Migrations.AddMeritumToJudgements do
  use Ecto.Migration

  def change do
    alter table(:judgements) do
      add :meritum, :text
    end
  end
end
