defmodule Przetargowi.Repo.Migrations.BackfillTenderNoticeSlugs do
  use Ecto.Migration

  def up do
    # Generate slugs from order_object (tender title)
    # Truncate to 100 chars to keep URLs reasonable, then append object_id for uniqueness
    execute """
    UPDATE tender_notices
    SET slug = CONCAT(
      LEFT(
        TRIM(BOTH '-' FROM
          REGEXP_REPLACE(
            REGEXP_REPLACE(
              REGEXP_REPLACE(
                REGEXP_REPLACE(
                  REGEXP_REPLACE(LOWER(order_object), '[/\\\\]', '-', 'g'),
                  '\\s+', '-', 'g'),
                '[^a-z0-9-]', '', 'g'),
              '-+', '-', 'g'),
            '^-|-$', '', 'g')),
        100),
      '-',
      object_id
    )
    WHERE slug IS NULL AND order_object IS NOT NULL
    """

    # Handle records without order_object - use object_id directly
    execute """
    UPDATE tender_notices
    SET slug = object_id
    WHERE slug IS NULL
    """

    # Create unique index
    create unique_index(:tender_notices, [:slug])
  end

  def down do
    drop_if_exists index(:tender_notices, [:slug])
    execute "UPDATE tender_notices SET slug = NULL"
  end
end
