defmodule Przetargowi.Repo.Migrations.AddDeliberationToJudgements do
  use Ecto.Migration

  def change do
    alter table(:judgements) do
      add :deliberation, :text
    end
  end
end
