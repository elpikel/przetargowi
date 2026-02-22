defmodule Przetargowi.Repo.Migrations.ChangeArrayColumnsToText do
  use Ecto.Migration

  def change do
    # Change array columns from varchar(255)[] to text[]
    alter table(:judgements) do
      modify :key_provisions, {:array, :text}, from: {:array, :string}
      modify :thematic_issues, {:array, :text}, from: {:array, :string}
    end
  end
end
