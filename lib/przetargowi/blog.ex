defmodule Przetargowi.Blog do
  @moduledoc """
  Blog articles.

  Articles are files in `priv/blog/<slug>.html`: a short header followed by the
  article HTML. They are read at compile time, so the site serves them from
  memory and an edit is an ordinary, reviewable change to a file.

      ---
      title: Wadium w przetargu — formy, gwarancja wadialna, zwrot i zatrzymanie
      excerpt: One or two sentences shown in lists.
      meta_description: Text for search results.
      keywords: wadium, gwarancja wadialna
      author: Redakcja Przetargowi.pl
      published_at: 2026-11-23
      updated_at: 2026-11-23
      ---
      <h2>First section</h2>
      <p>…</p>

  To publish an article, add a file; the file name is the URL slug. To retire
  one, delete the file. `title` and `published_at` are required. An `<h2>`
  mentioning "pytania" or "FAQ" followed by `<h3>` questions becomes FAQ
  structured data (see `PrzetargowiWeb.BlogHTML.prepare_content/1`).
  """

  alias Przetargowi.Blog.Article

  @blog_dir Path.expand("../../priv/blog", __DIR__)
  @paths @blog_dir |> Path.join("*.html") |> Path.wildcard() |> Enum.sort()

  for path <- @paths, do: @external_resource(path)

  @articles (for path <- @paths do
               [header, content] =
                 path
                 |> File.read!()
                 |> String.split(~r/^---\s*$/m, parts: 3)
                 |> case do
                   ["", header, content] -> [header, content]
                   _ -> raise "#{path}: expected a header between two --- lines"
                 end

               fields =
                 for line <- String.split(header, "\n", trim: true), into: %{} do
                   case String.split(line, ":", parts: 2) do
                     [key, value] -> {String.trim(key), String.trim(value)}
                     _ -> raise "#{path}: malformed header line #{inspect(line)}"
                   end
                 end

               date = fn key ->
                 case Map.fetch(fields, key) do
                   {:ok, value} ->
                     DateTime.new!(Date.from_iso8601!(value), ~T[08:00:00], "Etc/UTC")

                   :error ->
                     nil
                 end
               end

               published_at = date.("published_at") || raise("#{path}: missing published_at")

               %Article{
                 slug: Path.basename(path, ".html"),
                 title: Map.get(fields, "title") || raise("#{path}: missing title"),
                 excerpt: Map.get(fields, "excerpt"),
                 # Falls back to the excerpt so pages never go out without one
                 meta_description:
                   Map.get(fields, "meta_description") || Map.get(fields, "excerpt"),
                 keywords: Map.get(fields, "keywords"),
                 author: Map.get(fields, "author", "Redakcja Przetargowi.pl"),
                 content: String.trim(content),
                 published_at: published_at,
                 updated_at: date.("updated_at") || published_at
               }
             end)
            |> Enum.sort_by(&{&1.published_at, &1.slug}, fn {a_date, a_slug}, {b_date, b_slug} ->
              case DateTime.compare(a_date, b_date) do
                :gt -> true
                :lt -> false
                :eq -> a_slug <= b_slug
              end
            end)

  @by_slug Map.new(@articles, &{&1.slug, &1})

  # Recompile when an article file is added or removed (edits are covered by
  # @external_resource).
  @paths_hash :erlang.md5(@paths)

  def __mix_recompile__? do
    @blog_dir |> Path.join("*.html") |> Path.wildcard() |> Enum.sort() |> :erlang.md5() !=
      @paths_hash
  end

  @doc "Lists articles, newest first. Options: `:limit` (default 10), `:offset`."
  def list_articles(opts \\ []) do
    limit = Keyword.get(opts, :limit, 10)
    offset = Keyword.get(opts, :offset, 0)

    @articles |> Enum.drop(offset) |> Enum.take(limit)
  end

  @doc "Number of articles."
  def count_articles, do: length(@articles)

  @doc "Returns the article with the given slug, or nil."
  def get_article_by_slug(slug) when is_binary(slug), do: Map.get(@by_slug, slug)
  def get_article_by_slug(_), do: nil

  @doc "The newest articles, for cross-links on other pages."
  def list_recent_articles(limit \\ 3), do: Enum.take(@articles, limit)

  @doc "Slug and last-modified time of every article, for the sitemap."
  def list_sitemap_entries, do: Enum.map(@articles, &%{slug: &1.slug, updated_at: &1.updated_at})

  @doc "Number of articles, for the sitemap."
  def count_sitemap_entries, do: count_articles()
end
