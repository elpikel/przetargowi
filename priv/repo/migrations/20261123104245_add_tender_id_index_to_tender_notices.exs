defmodule Przetargowi.Repo.Migrations.AddTenderIdIndexToTenderNotices do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  # Every tender page looks up the other notices of the same procurement by
  # tender_id. Without an index that was a sequential scan of the whole table
  # on each page view (2.5–3 s on production).
  def change do
    create_if_not_exists index(:tender_notices, [:tender_id], concurrently: true)
  end
end
