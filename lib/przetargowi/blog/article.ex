defmodule Przetargowi.Blog.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :title, :string
    field :slug, :string
    field :excerpt, :string
    field :content, :string
    field :meta_description, :string
    field :meta_keywords, :string
    field :cover_image_url, :string
    field :author, :string, default: "Redakcja Przetargowi.pl"
    field :published, :boolean, default: false
    field :published_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [
      :title,
      :slug,
      :excerpt,
      :content,
      :meta_description,
      :meta_keywords,
      :cover_image_url,
      :author,
      :published,
      :published_at
    ])
    |> validate_required([:title, :slug, :content])
    |> unique_constraint(:slug)
    |> maybe_set_published_at()
  end

  defp maybe_set_published_at(changeset) do
    if get_change(changeset, :published) == true && is_nil(get_field(changeset, :published_at)) do
      put_change(changeset, :published_at, DateTime.utc_now() |> DateTime.truncate(:second))
    else
      changeset
    end
  end
end
