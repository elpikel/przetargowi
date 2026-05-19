defmodule Przetargowi.Repo.Migrations.UpdateWatchlistBlogPostLimit do
  use Ecto.Migration

  def up do
    # Update the table row - change "do 5 przetargów" to "1 przetarg"
    execute("""
    UPDATE articles
    SET content = REPLACE(
          REPLACE(content, 'do 5 przetargów', '1 przetarg'),
          'Śledzisz więcej niż 5 przetargów?',
          'Chcesz obserwować więcej przetargów?'
        ),
        meta_description = REPLACE(meta_description, 'Darmowe dla 5 przetargów', 'Darmowy dla 1 przetargu')
    WHERE slug = 'obserwuj-przetargi-nowa-funkcja'
    """)
  end

  def down do
    execute("""
    UPDATE articles
    SET content = REPLACE(
          REPLACE(content, '1 przetarg', 'do 5 przetargów'),
          'Chcesz obserwować więcej przetargów?',
          'Śledzisz więcej niż 5 przetargów?'
        ),
        meta_description = REPLACE(meta_description, 'Darmowy dla 1 przetargu', 'Darmowe dla 5 przetargów')
    WHERE slug = 'obserwuj-przetargi-nowa-funkcja'
    """)
  end
end
