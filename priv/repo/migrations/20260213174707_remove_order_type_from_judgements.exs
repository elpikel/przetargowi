defmodule Przetargowi.Repo.Migrations.RemoveOrderTypeFromJudgements do
  use Ecto.Migration

  def change do
    alter table(:judgements) do
      remove :order_type, :string
    end
  end
end
