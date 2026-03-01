defmodule Przetargowi.Repo.Migrations.FixInvalidDecisionDates do
  use Ecto.Migration

  def up do
    # Fix dates where year > 2026 by extracting year from signature
    # Signatures like "KIO 103/20" mean year 2020
    execute """
    UPDATE judgements
    SET decision_date = make_date(
      CASE
        WHEN CAST(SUBSTRING(signature FROM '/([0-9]{2})$') AS INTEGER) >= 90
        THEN 1900 + CAST(SUBSTRING(signature FROM '/([0-9]{2})$') AS INTEGER)
        ELSE 2000 + CAST(SUBSTRING(signature FROM '/([0-9]{2})$') AS INTEGER)
      END,
      EXTRACT(MONTH FROM decision_date)::INTEGER,
      EXTRACT(DAY FROM decision_date)::INTEGER
    )
    WHERE EXTRACT(YEAR FROM decision_date) > 2026
      AND signature ~ '/[0-9]{2}$'
    """

    # Fix dates where year < 1990 by extracting year from signature
    execute """
    UPDATE judgements
    SET decision_date = make_date(
      CASE
        WHEN CAST(SUBSTRING(signature FROM '/([0-9]{2})$') AS INTEGER) >= 90
        THEN 1900 + CAST(SUBSTRING(signature FROM '/([0-9]{2})$') AS INTEGER)
        ELSE 2000 + CAST(SUBSTRING(signature FROM '/([0-9]{2})$') AS INTEGER)
      END,
      EXTRACT(MONTH FROM decision_date)::INTEGER,
      EXTRACT(DAY FROM decision_date)::INTEGER
    )
    WHERE EXTRACT(YEAR FROM decision_date) < 1990
      AND decision_date IS NOT NULL
      AND signature ~ '/[0-9]{2}$'
    """
  end

  def down do
    # Cannot reverse this migration - data correction is one-way
    :ok
  end
end
