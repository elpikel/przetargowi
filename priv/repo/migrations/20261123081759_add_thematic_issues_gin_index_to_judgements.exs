defmodule Przetargowi.Repo.Migrations.AddThematicIssuesGinIndexToJudgements do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  # Topic hubs (/orzecznictwo-kio/:slug) filter rulings with
  # `thematic_issues && ARRAY[...]`, which needs a GIN index to stay fast.
  def change do
    create_if_not_exists index(:judgements, [:thematic_issues],
                           using: :gin,
                           concurrently: true
                         )
  end
end
