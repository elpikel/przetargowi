defmodule Przetargowi.Repo.Migrations.FixReportCtaLinks do
  use Ecto.Migration

  @doc """
  Backfill stored report HTML whose CTA linked to the non-existent `/register`
  route. The generator was fixed to point at `/rejestracja` in a later commit,
  but reports already persisted in the database still carried the broken link,
  so the "Rozpocznij za darmo" button dead-ended. Rewrite the stored HTML for
  existing rows.
  """

  def up do
    # Reports: the CTA linked to the non-existent `/register` route.
    for column <- ~w(upsell_html analysis_html introduction_html) do
      execute("""
      UPDATE tender_reports
      SET #{column} = REPLACE(#{column}, 'href="/register"', 'href="/rejestracja"')
      WHERE #{column} LIKE '%href="/register"%'
      """)
    end

    # Blog articles: CTAs linked to the removed `/subskrypcja` and
    # `/subskrypcja/nowa` routes. The app is now free, so point them at
    # registration (the longer path first so the prefix replace can't mangle it).
    execute("""
    UPDATE articles
    SET content = REPLACE(content, 'href="/subskrypcja/nowa"', 'href="/rejestracja"')
    WHERE content LIKE '%href="/subskrypcja/nowa"%'
    """)

    execute("""
    UPDATE articles
    SET content = REPLACE(content, 'href="/subskrypcja"', 'href="/rejestracja"')
    WHERE content LIKE '%href="/subskrypcja"%'
    """)
  end

  def down do
    # Not reversible — restoring a broken link serves no purpose.
    :ok
  end
end
