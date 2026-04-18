defmodule Przetargowi.Blog do
  @moduledoc """
  Context module for managing blog articles.
  """

  import Ecto.Query

  alias Przetargowi.Repo
  alias Przetargowi.Blog.Article

  @doc """
  Lists published articles, ordered by publication date.
  """
  def list_articles(opts \\ []) do
    limit = Keyword.get(opts, :limit, 10)
    offset = Keyword.get(opts, :offset, 0)

    Article
    |> where([a], a.published == true)
    |> order_by([a], desc: a.published_at)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end

  @doc """
  Returns count of published articles.
  """
  def count_articles do
    Article
    |> where([a], a.published == true)
    |> Repo.aggregate(:count)
  end

  @doc """
  Gets a published article by slug.
  """
  def get_article_by_slug(slug) do
    Article
    |> where([a], a.slug == ^slug and a.published == true)
    |> Repo.one()
  end

  @doc """
  Gets an article by ID (for admin).
  """
  def get_article(id) do
    Repo.get(Article, id)
  end

  @doc """
  Creates an article.
  """
  def create_article(attrs) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an article.
  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an article.
  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns recent articles for display on other pages.
  """
  def list_recent_articles(limit \\ 3) do
    Article
    |> where([a], a.published == true)
    |> order_by([a], desc: a.published_at)
    |> limit(^limit)
    |> select([a], %{
      id: a.id,
      title: a.title,
      slug: a.slug,
      excerpt: a.excerpt,
      published_at: a.published_at,
      author: a.author
    })
    |> Repo.all()
  end

  @doc """
  Returns article slugs for sitemap generation.
  """
  def list_sitemap_entries do
    Article
    |> where([a], a.published == true)
    |> select([a], %{slug: a.slug, updated_at: a.updated_at})
    |> order_by([a], asc: a.id)
    |> Repo.all()
  end

  @doc """
  Returns count of published articles for sitemap.
  """
  def count_sitemap_entries do
    count_articles()
  end
end
