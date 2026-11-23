defmodule Przetargowi.Repo.Migrations.PointBlogRulingLinksToNewUrls do
  use Ecto.Migration

  # Rulings moved from /orzeczenie/:slug to /orzecznictwo-kio/:slug. The old
  # URLs redirect, but internal links should not go through a 301.
  def up do
    execute("""
    UPDATE articles
    SET content = replace(content, 'href="/orzeczenie/', 'href="/orzecznictwo-kio/'),
        updated_at = now()
    WHERE position('href="/orzeczenie/' in content) > 0
    """)
  end

  def down, do: :ok
end
