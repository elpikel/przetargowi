defmodule PrzetargowiWeb.BlogController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Blog

  @per_page 10

  def index(conn, params) do
    page = parse_page(Map.get(params, "page", "1"))
    offset = (page - 1) * @per_page

    articles = Blog.list_articles(limit: @per_page, offset: offset)
    total_count = Blog.count_articles()
    total_pages = ceil(total_count / @per_page)

    breadcrumbs = [
      %{name: "Strona główna", url: "https://przetargowi.pl"},
      %{name: "Blog", url: "https://przetargowi.pl/blog"}
    ]

    conn
    |> assign(:page_title, "Blog — poradniki i artykuły o zamówieniach publicznych")
    |> assign(
      :meta_description,
      "Blog Przetargowi.pl — poradniki jak rozpocząć działalność w zamówieniach publicznych, artykuły o przetargach i orzecznictwie KIO."
    )
    |> assign(:canonical_url, "https://przetargowi.pl/blog")
    |> assign(:breadcrumbs, breadcrumbs)
    |> assign(:articles, articles)
    |> assign(:current_page, page)
    |> assign(:total_pages, total_pages)
    |> assign(:total_count, total_count)
    |> render(:index)
  end

  def show(conn, %{"slug" => slug}) do
    case Blog.get_article_by_slug(slug) do
      nil ->
        conn
        |> put_flash(:error, "Artykuł nie został znaleziony")
        |> redirect(to: "/blog")

      article ->
        canonical_url = "https://przetargowi.pl/blog/#{article.slug}"

        breadcrumbs = [
          %{name: "Strona główna", url: "https://przetargowi.pl"},
          %{name: "Blog", url: "https://przetargowi.pl/blog"},
          %{name: article.title, url: canonical_url}
        ]

        # Get related articles
        related_articles = Blog.list_recent_articles(3)

        conn
        |> assign(:page_title, "#{article.title} — Blog Przetargowi.pl")
        |> assign(
          :meta_description,
          article.meta_description || article.excerpt || String.slice(article.content, 0, 155)
        )
        |> assign(:canonical_url, canonical_url)
        |> assign(:og_url, canonical_url)
        |> assign(:og_type, "article")
        |> assign(:breadcrumbs, breadcrumbs)
        |> assign(:article, article)
        |> assign(:related_articles, related_articles)
        |> assign(:article_json_ld, build_article_json_ld(article, canonical_url))
        |> render(:show)
    end
  end

  defp parse_page(page_str) do
    case Integer.parse(page_str) do
      {page, ""} when page > 0 -> page
      _ -> 1
    end
  end

  defp build_article_json_ld(article, url) do
    %{
      "@context" => "https://schema.org",
      "@type" => "Article",
      "headline" => article.title,
      "description" => article.meta_description || article.excerpt,
      "author" => %{
        "@type" => "Person",
        "name" => article.author
      },
      "publisher" => %{
        "@type" => "Organization",
        "name" => "Przetargowi.pl",
        "url" => "https://przetargowi.pl"
      },
      "datePublished" => format_date(article.published_at),
      "dateModified" => format_date(article.updated_at),
      "mainEntityOfPage" => url
    }
  end

  defp format_date(nil), do: nil
  defp format_date(%DateTime{} = dt), do: DateTime.to_iso8601(dt)
end
