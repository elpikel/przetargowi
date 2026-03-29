defmodule Przetargowi.Repo.Migrations.AddSitemapIndexes do
  use Ecto.Migration

  def change do
    # Covering index for sitemap query: includes updated_at for index-only scan
    create index(:judgements, [:slug],
      where: "slug IS NOT NULL",
      include: [:updated_at],
      name: :judgements_sitemap_index
    )

    create index(:tender_notices, [:slug],
      where: "slug IS NOT NULL",
      include: [:updated_at],
      name: :tender_notices_sitemap_index
    )
  end
end
