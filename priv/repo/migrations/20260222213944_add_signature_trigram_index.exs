defmodule Przetargowi.Repo.Migrations.AddSignatureTrigramIndex do
  use Ecto.Migration

  def up do
    # Enable pg_trgm extension for fast ILIKE searches
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm"

    # Create GIN trigram index on signature for fast ILIKE
    execute "CREATE INDEX judgements_signature_trgm_idx ON judgements USING gin (signature gin_trgm_ops)"
  end

  def down do
    execute "DROP INDEX IF EXISTS judgements_signature_trgm_idx"
  end
end
