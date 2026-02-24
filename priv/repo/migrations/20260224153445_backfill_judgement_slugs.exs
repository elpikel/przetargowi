defmodule Przetargowi.Repo.Migrations.BackfillJudgementSlugs do
  use Ecto.Migration

  def up do
    # First, generate base slugs
    execute """
    UPDATE judgements
    SET slug = TRIM(BOTH '-' FROM
      REGEXP_REPLACE(
        REGEXP_REPLACE(
          REGEXP_REPLACE(
            REGEXP_REPLACE(
              REGEXP_REPLACE(LOWER(signature), '[/\\\\]', '-', 'g'),
              '\\s+', '-', 'g'),
            '[^a-z0-9-]', '', 'g'),
          '-+', '-', 'g'),
        '^-|-$', '', 'g'))
    WHERE slug IS NULL AND signature IS NOT NULL
    """

    # Handle duplicates by appending ID (keep the oldest record with the base slug)
    execute """
    UPDATE judgements j
    SET slug = j.slug || '-' || j.id
    WHERE j.id NOT IN (
      SELECT MIN(id)
      FROM judgements
      WHERE slug IS NOT NULL
      GROUP BY slug
    )
    AND j.slug IS NOT NULL
    """

    # Create unique index after handling duplicates
    create unique_index(:judgements, [:slug])
  end

  def down do
    drop_if_exists index(:judgements, [:slug])
    execute "UPDATE judgements SET slug = NULL"
  end
end
