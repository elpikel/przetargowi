defmodule PrzetargowiWeb.BlogControllerTest do
  use PrzetargowiWeb.ConnCase

  alias Przetargowi.Blog
  alias PrzetargowiWeb.BlogHTML

  @content """
  <h2>Czym jest wadium</h2>
  <p>Wstęp.</p>
  <h2>Formy wniesienia</h2>
  <p>Opis.</p>
  <h2>Najczęstsze pytania</h2>
  <h3>Czy wadium można uzupełnić?</h3>
  <p>Nie.</p>
  <p>Musi być wniesione przed terminem.</p>
  <h3>Ile wynosi wadium?</h3>
  <p>Do 3% wartości zamówienia.</p>
  <h2>Podsumowanie</h2>
  <p>Koniec.</p>
  """

  defp create_article(attrs \\ %{}) do
    {:ok, article} =
      Blog.create_article(
        Map.merge(
          %{
            title: "Wadium w przetargu",
            slug: "wadium-test-#{System.unique_integer([:positive])}",
            excerpt: "Opis",
            content: @content,
            published: true
          },
          attrs
        )
      )

    article
  end

  describe "BlogHTML.prepare_content/1" do
    test "gives every h2 a linkable id and lists them as the table of contents" do
      prepared = BlogHTML.prepare_content(@content)

      assert Enum.map(prepared.toc, & &1.id) == [
               "czym-jest-wadium",
               "formy-wniesienia",
               "najczestsze-pytania",
               "podsumowanie"
             ]

      assert prepared.html =~ ~s(<h2 id="czym-jest-wadium">)
    end

    test "keeps ids unique when two headings share a title" do
      prepared = BlogHTML.prepare_content("<h2>Wadium</h2><h2>Wadium</h2>")

      assert Enum.map(prepared.toc, & &1.id) == ["wadium", "wadium-2"]
    end

    test "extracts questions and answers from the FAQ section only" do
      assert BlogHTML.prepare_content(@content).faqs == [
               %{
                 question: "Czy wadium można uzupełnić?",
                 answer: "Nie. Musi być wniesione przed terminem."
               },
               %{question: "Ile wynosi wadium?", answer: "Do 3% wartości zamówienia."}
             ]
    end

    test "returns no FAQ when the article has no FAQ section" do
      assert BlogHTML.prepare_content("<h2>Wstęp</h2><h3>Pytanie?</h3><p>Odp.</p>").faqs == []
    end
  end

  describe "GET /blog/:slug" do
    test "renders a table of contents linking to the sections", %{conn: conn} do
      article = create_article()

      document =
        conn |> get(~p"/blog/#{article.slug}") |> html_response(200) |> LazyHTML.from_document()

      hrefs = document |> LazyHTML.query("#article-toc a") |> LazyHTML.attribute("href")

      assert "#formy-wniesienia" in hrefs
      assert Enum.count(LazyHTML.query(document, "h2#formy-wniesienia")) == 1
    end

    test "emits FAQPage structured data when the article has a FAQ section", %{conn: conn} do
      article = create_article()

      response = conn |> get(~p"/blog/#{article.slug}") |> html_response(200)

      assert response =~ ~s("@type":"FAQPage")
      assert response =~ "Czy wadium można uzupełnić?"
    end

    test "returns 404 for an unknown article instead of redirecting", %{conn: conn} do
      assert conn |> get("/blog/nie-ma-takiego-artykulu") |> html_response(404)
    end
  end
end
