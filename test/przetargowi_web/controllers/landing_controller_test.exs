defmodule PrzetargowiWeb.LandingControllerTest do
  use PrzetargowiWeb.ConnCase

  alias Przetargowi.Judgements
  alias Przetargowi.Judgements.Topics

  defp create_judgement(details) do
    {:ok, judgement} =
      Judgements.upsert_from_list(%{
        uzp_id: "#{System.unique_integer([:positive])}",
        signature: "KIO #{System.unique_integer([:positive])}/24",
        document_type: "wyrok",
        synced_at: DateTime.utc_now()
      })

    {:ok, judgement} = Judgements.update_with_details(judgement, details)
    judgement
  end

  defp document(conn, path) do
    conn |> get(path) |> html_response(200) |> LazyHTML.from_document()
  end

  describe "GET /orzecznictwo-kio" do
    test "renders the pillar page with a search form posting to /orzecznictwo-kio/szukaj", %{
      conn: conn
    } do
      document = document(conn, ~p"/orzecznictwo-kio")

      form = LazyHTML.query(document, "#kio-search")
      assert LazyHTML.attribute(form, "action") == ["/orzecznictwo-kio/szukaj"]
      assert Enum.count(LazyHTML.query(document, "#kio-search-input[name=q]")) == 1
    end

    test "links to every topic hub", %{conn: conn} do
      document = document(conn, ~p"/orzecznictwo-kio")

      hrefs = document |> LazyHTML.query("#kio-topics a") |> LazyHTML.attribute("href")

      assert hrefs == Topics.all_paths()
    end

    test "is indexable with a self-referencing canonical", %{conn: conn} do
      document = document(conn, ~p"/orzecznictwo-kio")

      assert document |> LazyHTML.query(~s(link[rel="canonical"])) |> LazyHTML.attribute("href") ==
               ["https://przetargowi.pl/orzecznictwo-kio"]

      assert document |> LazyHTML.query(~s(meta[name="robots"])) |> LazyHTML.attribute("content") ==
               ["index, follow"]
    end

    test "lists recent rulings", %{conn: conn} do
      judgement = create_judgement(%{meritum: "Istota sprawy"})

      document = document(conn, ~p"/orzecznictwo-kio")

      assert Enum.count(
               LazyHTML.query(
                 document,
                 ~s(#kio-recent a[href="/orzecznictwo-kio/#{judgement.slug}"])
               )
             ) == 1
    end
  end

  describe "GET /orzecznictwo-kio/:slug" do
    test "lists the rulings tagged with the topic's issues", %{conn: conn} do
      matching = create_judgement(%{thematic_issues: ["rażąco niska cena"]})
      other = create_judgement(%{thematic_issues: ["wadium"]})

      document = document(conn, ~p"/orzecznictwo-kio/razaco-niska-cena")

      hrefs = document |> LazyHTML.query("#topic-judgements h3 a") |> LazyHTML.attribute("href")

      assert "/orzecznictwo-kio/#{matching.slug}" in hrefs
      refute "/orzecznictwo-kio/#{other.slug}" in hrefs
    end

    test "renders editorial copy, FAQ and outcome statistics on the first page", %{conn: conn} do
      create_judgement(%{thematic_issues: ["rażąco niska cena"], resolution_method: "oddalone"})

      document = document(conn, ~p"/orzecznictwo-kio/razaco-niska-cena")

      assert Enum.count(LazyHTML.query(document, "#topic-overview")) == 1
      assert Enum.count(LazyHTML.query(document, "#topic-faq details")) > 0
      assert Enum.count(LazyHTML.query(document, "#topic-outcomes")) == 1
    end

    test "is indexable with a self-referencing canonical", %{conn: conn} do
      document = document(conn, ~p"/orzecznictwo-kio/wadium")

      assert document |> LazyHTML.query(~s(link[rel="canonical"])) |> LazyHTML.attribute("href") ==
               ["https://przetargowi.pl/orzecznictwo-kio/wadium"]

      assert document |> LazyHTML.query(~s(meta[name="robots"])) |> LazyHTML.attribute("content") ==
               ["index, follow"]
    end

    test "links to the other topic hubs", %{conn: conn} do
      document = document(conn, ~p"/orzecznictwo-kio/wadium")

      hrefs = document |> LazyHTML.query("#kio-browse a") |> LazyHTML.attribute("href")

      assert "/orzecznictwo-kio/razaco-niska-cena" in hrefs
      refute "/orzecznictwo-kio/wadium" in hrefs
    end

    test "deeper pages are noindex and drop the editorial copy", %{conn: conn} do
      for _ <- 1..21, do: create_judgement(%{thematic_issues: ["wadium"]})

      document = document(conn, "/orzecznictwo-kio/wadium?strona=2")

      assert document |> LazyHTML.query(~s(meta[name="robots"])) |> LazyHTML.attribute("content") ==
               ["noindex, follow"]

      assert Enum.count(LazyHTML.query(document, "#topic-overview")) == 0
      assert Enum.count(LazyHTML.query(document, "#topic-judgements h3 a")) == 1
    end

    test "redirects a page number past the end back to the hub", %{conn: conn} do
      conn = get(conn, "/orzecznictwo-kio/wadium?strona=99")

      assert redirected_to(conn) == "/orzecznictwo-kio/wadium"
    end

    test "returns 404 for an unknown topic", %{conn: conn} do
      conn = get(conn, "/orzecznictwo-kio/nie-ma-takiego-zagadnienia")

      assert html_response(conn, 404)
    end

    test "every curated topic renders", %{conn: conn} do
      for path <- Topics.all_paths() do
        assert conn |> get(path) |> html_response(200)
      end
    end
  end

  describe "GET /orzecznictwo-kio/statystyki" do
    setup do
      Przetargowi.SitemapCache.clear()
      on_exit(&Przetargowi.SitemapCache.clear/0)
    end

    test "shows the upheld rate computed from rulings decided on the merits", %{conn: conn} do
      for method <- ["uwzględnione", "oddalone", "oddalone", "oddalone", "umorzone"] do
        judgement =
          create_judgement(%{thematic_issues: ["wadium"], resolution_method: method})

        {:ok, _} = Judgements.update_judgement(judgement, %{decision_date: ~D[2025-02-01]})
      end

      conn = get(conn, ~p"/orzecznictwo-kio/statystyki")
      document = conn |> html_response(200) |> LazyHTML.from_document()

      assert conn.assigns.stats.outcomes.upheld_rate == 25

      assert [%{year: 2025, total: 5, upheld: 1, dismissed: 3, upheld_rate: 25}] =
               conn.assigns.stats.years

      assert Enum.count(LazyHTML.query(document, "#stats-years tbody tr")) == 1

      assert Enum.count(LazyHTML.query(document, "#stats-topics tbody tr")) ==
               length(Topics.all())

      wadium = Enum.find(conn.assigns.stats.topics, &(&1.topic.slug == "wadium"))
      assert %{count: 5, decided: 4, upheld_rate: 25} = wadium
    end

    test "is indexable and is not mistaken for a topic or ruling slug", %{conn: conn} do
      document = conn |> get(~p"/orzecznictwo-kio/statystyki") |> html_response(200)
      document = LazyHTML.from_document(document)

      assert document |> LazyHTML.query(~s(link[rel="canonical"])) |> LazyHTML.attribute("href") ==
               ["https://przetargowi.pl/orzecznictwo-kio/statystyki"]

      assert Enum.count(LazyHTML.query(document, "#stats-method")) == 1
    end
  end

  describe "KIO and tender sections share one layout" do
    test "hub pages of both sections are built from the same blocks in the same order", %{
      conn: conn
    } do
      Przetargowi.SitemapCache.clear()

      blocks = fn path ->
        conn
        |> get(path)
        |> html_response(200)
        |> LazyHTML.from_document()
        |> LazyHTML.query("main [id]")
        |> LazyHTML.attribute("id")
      end

      kio = ~w(topic-figures topic-search topic-judgements topic-overview topic-faq kio-browse)
      tender = ~w(hub-figures hub-search hub-tenders hub-overview hub-faq tender-browse)

      assert Enum.filter(blocks.("/orzecznictwo-kio/wadium"), &(&1 in kio)) == kio
      assert Enum.filter(blocks.("/przetargi/branza/budowlane"), &(&1 in tender)) == tender
    end

    test "a topic hub lists every other hub in its browse block, marking itself current", %{
      conn: conn
    } do
      document =
        conn |> get("/orzecznictwo-kio/wadium") |> html_response(200) |> LazyHTML.from_document()

      hrefs = document |> LazyHTML.query("#kio-browse a") |> LazyHTML.attribute("href")

      assert length(Enum.filter(hrefs, &(&1 in Topics.all_paths()))) == length(Topics.all()) - 1
      assert Enum.count(LazyHTML.query(document, "#kio-browse [aria-current=page]")) == 1
    end
  end
end
