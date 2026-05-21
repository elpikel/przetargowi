defmodule Przetargowi.Repo.Migrations.AddCpvMainIndex do
  use Ecto.Migration

  def change do
    create index(:tender_notices, [:cpv_main])
  end
end
