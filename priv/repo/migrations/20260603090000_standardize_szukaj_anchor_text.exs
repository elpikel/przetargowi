defmodule Przetargowi.Repo.Migrations.StandardizeSzukajAnchorText do
  use Ecto.Migration

  @doc """
  Standardize internal link anchor text pointing to /szukaj
  to consistently use "wyszukiwarka orzeczeń KIO" for SEO.
  """

  def up do
    # Styled links (in CTA boxes with gold color)
    execute("""
    UPDATE articles SET content = REPLACE(
      content,
      '<a href="/szukaj" style="color: #d4af37;">bazie orzeczeń KIO na Przetargowi.pl</a>',
      '<a href="/szukaj" style="color: #d4af37;">wyszukiwarce orzeczeń KIO</a>'
    )
    """)

    execute("""
    UPDATE articles SET content = REPLACE(
      content,
      '<a href="/szukaj" style="color: #d4af37;">bazie orzeczeń Przetargowi.pl</a>',
      '<a href="/szukaj" style="color: #d4af37;">wyszukiwarce orzeczeń KIO</a>'
    )
    """)

    execute("""
    UPDATE articles SET content = REPLACE(
      content,
      '<a href="/szukaj" style="color: #d4af37;">bazie orzeczeń KIO</a>',
      '<a href="/szukaj" style="color: #d4af37;">wyszukiwarce orzeczeń KIO</a>'
    )
    """)

    execute("""
    UPDATE articles SET content = REPLACE(
      content,
      '<a href="/szukaj" style="color: #d4af37;">bazie orzeczeń</a>',
      '<a href="/szukaj" style="color: #d4af37;">wyszukiwarce orzeczeń KIO</a>'
    )
    """)

    # Plain links (no inline style)
    execute("""
    UPDATE articles SET content = REPLACE(
      content,
      '<a href="/szukaj">bazie orzeczeń KIO</a>',
      '<a href="/szukaj">wyszukiwarce orzeczeń KIO</a>'
    )
    """)

    execute("""
    UPDATE articles SET content = REPLACE(
      content,
      '<a href="/szukaj">naszej bazie</a>',
      '<a href="/szukaj">wyszukiwarce orzeczeń KIO</a>'
    )
    """)

    execute("""
    UPDATE articles SET content = REPLACE(
      content,
      '<a href="/szukaj">Przetargowi.pl</a>',
      '<a href="/szukaj">wyszukiwarce orzeczeń KIO</a>'
    )
    """)
  end

  def down do
    # Not reversible — anchor text changes are cosmetic
    :ok
  end
end
