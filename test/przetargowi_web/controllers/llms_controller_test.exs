defmodule PrzetargowiWeb.LlmsControllerTest do
  use PrzetargowiWeb.ConnCase

  alias Przetargowi.Blog
  alias Przetargowi.Judgements.Topics
  alias Przetargowi.SitemapCache

  setup do
    SitemapCache.clear()
    on_exit(&SitemapCache.clear/0)
  end

  test "GET /llms.txt serves a plain-text site map with every topic hub", %{conn: conn} do
    conn = get(conn, "/llms.txt")

    assert response_content_type(conn, :text)
    body = response(conn, 200)

    assert body =~ "# Przetargowi.pl"

    for path <- Topics.all_paths() do
      assert body =~ "https://przetargowi.pl#{path})"
    end
  end

  test "GET /llms.txt lists every blog article", %{conn: conn} do
    body = conn |> get("/llms.txt") |> response(200)

    for article <- Blog.list_articles(limit: 50) do
      assert body =~ "[#{article.title}](https://przetargowi.pl/blog/#{article.slug})"
    end
  end
end
