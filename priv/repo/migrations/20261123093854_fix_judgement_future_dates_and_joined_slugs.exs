defmodule Przetargowi.Repo.Migrations.FixJudgementFutureDatesAndJoinedSlugs do
  use Ecto.Migration

  # Two data fixes for rulings already in the database. New rows are handled
  # in Przetargowi.Judgements.Judgement.
  def up do
    # A decision cannot be dated in the future. The few that are come from
    # typos in the source documents (e.g. "7 grudnia 2026" in KIO 4983/25);
    # an unknown date is better than a wrong one in titles and sort order.
    execute("UPDATE judgements SET decision_date = NULL WHERE decision_date > CURRENT_DATE")

    # Joint cases have signatures like "KIO 2728/23|KIO 2729/23". The slug
    # generator dropped the separator, producing "kio-2728-23kio-2729-23".
    # Old URLs keep working: the lookup falls back to the separated form and
    # redirects (Przetargowi.Judgements.get_judgement_by_slug/1).
    execute("""
    UPDATE judgements AS j
    SET slug = regexp_replace(j.slug, '([0-9])(kio)', '\\1-\\2', 'g')
    WHERE j.slug ~ '[0-9]kio'
      AND NOT EXISTS (
        SELECT 1 FROM judgements AS other
        WHERE other.slug = regexp_replace(j.slug, '([0-9])(kio)', '\\1-\\2', 'g')
      )
    """)
  end

  # Neither change loses information worth restoring.
  def down, do: :ok
end
