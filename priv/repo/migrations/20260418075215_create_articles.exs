defmodule Przetargowi.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :excerpt, :text
      add :content, :text, null: false
      add :meta_description, :string
      add :meta_keywords, :string
      add :cover_image_url, :string
      add :author, :string, default: "Redakcja Przetargowi.pl"
      add :published, :boolean, default: false
      add :published_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:articles, [:slug])
    create index(:articles, [:published, :published_at])
  end
end
