defmodule Przetargowi.Repo.Migrations.AddFullTextSearch do
  use Ecto.Migration

  def up do
    # Add tsvector column for full-text search
    alter table(:judgements) do
      add :search_vector, :tsvector
    end

    # Create GIN index for fast full-text search
    create index(:judgements, [:search_vector], using: :gin)

    # Populate search_vector with searchable fields (simple config for Polish)
    execute """
    UPDATE judgements SET search_vector =
      setweight(to_tsvector('simple', coalesce(signature, '')), 'A') ||
      setweight(to_tsvector('simple', coalesce(contracting_authority, '')), 'B') ||
      setweight(to_tsvector('simple', coalesce(meritum, '')), 'C') ||
      setweight(to_tsvector('simple', coalesce(deliberation, '')), 'D')
    """

    # Create trigger function to auto-update search_vector
    execute """
    CREATE OR REPLACE FUNCTION judgements_search_vector_update() RETURNS trigger AS $$
    BEGIN
      NEW.search_vector :=
        setweight(to_tsvector('simple', coalesce(NEW.signature, '')), 'A') ||
        setweight(to_tsvector('simple', coalesce(NEW.contracting_authority, '')), 'B') ||
        setweight(to_tsvector('simple', coalesce(NEW.meritum, '')), 'C') ||
        setweight(to_tsvector('simple', coalesce(NEW.deliberation, '')), 'D');
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """

    # Create trigger
    execute """
    CREATE TRIGGER judgements_search_vector_trigger
    BEFORE INSERT OR UPDATE OF signature, contracting_authority, meritum, deliberation
    ON judgements
    FOR EACH ROW
    EXECUTE FUNCTION judgements_search_vector_update();
    """
  end

  def down do
    execute "DROP TRIGGER IF EXISTS judgements_search_vector_trigger ON judgements"
    execute "DROP FUNCTION IF EXISTS judgements_search_vector_update()"

    alter table(:judgements) do
      remove :search_vector
    end
  end
end
