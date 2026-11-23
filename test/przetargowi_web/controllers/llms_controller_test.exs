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

  test "GET /llms.txt lists published blog articles", %{conn: conn} do
    {:ok, _} =
      Blog.create_article(%{
        title: "Testowy poradnik",
        slug: "testowy-poradnik",
        excerpt: "Krótki opis",
        content: "<p>Treść</p>",
        published: true
      })

    body = conn |> get("/llms.txt") |> response(200)

    assert body =~ "[Testowy poradnik](https://przetargowi.pl/blog/testowy-poradnik): Krótki opis"
  end
end
