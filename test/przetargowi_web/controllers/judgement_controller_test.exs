defmodule PrzetargowiWeb.JudgementControllerTest do
  use PrzetargowiWeb.ConnCase

  alias Przetargowi.Judgements

  defp create_judgement(details) do
    {:ok, judgement} =
      Judgements.upsert_from_list(%{
        uzp_id: "#{System.unique_integer([:positive])}",
        signature: "KIO #{System.unique_integer([:positive])}/24",
        synced_at: DateTime.utc_now()
      })

    {:ok, judgement} = Judgements.update_with_details(judgement, details)
    judgement
  end

  describe "GET /orzecznictwo-kio/:slug indexability" do
    test "thin page with no content is marked noindex", %{conn: conn} do
      judgement = create_judgement(%{})

      response = conn |> get(~p"/orzecznictwo-kio/#{judgement.slug}") |> html_response(200)

      assert response =~ ~s(<meta name="robots" content="noindex, follow">)
    end

    test "page with real content stays indexable", %{conn: conn} do
      judgement = create_judgement(%{content_html: "<p>#{String.duplicate("treść ", 200)}</p>"})

      response = conn |> get(~p"/orzecznictwo-kio/#{judgement.slug}") |> html_response(200)

      assert response =~ ~s(<meta name="robots" content="index, follow">)
    end
  end

  describe "GET /orzecznictwo-kio/:slug unique content" do
    test "renders an original narrative summary", %{conn: conn} do
      judgement =
        create_judgement(%{
          content_html: "<p>#{String.duplicate("treść ", 200)}</p>",
          resolution_method: "oddalone",
          procedure_type: "przetarg nieograniczony"
        })

      response = conn |> get(~p"/orzecznictwo-kio/#{judgement.slug}") |> html_response(200)

      assert response =~ "Streszczenie orzeczenia"
      assert response =~ "oddaliła odwołanie"
    end

    test "links related rulings with followable internal links", %{conn: conn} do
      related =
        create_judgement(%{
          content_html: "<p>content</p>",
          issuing_authority: "KIO",
          thematic_issues: ["rażąco niska cena"]
        })

      judgement =
        create_judgement(%{
          content_html: "<p>#{String.duplicate("treść ", 200)}</p>",
          issuing_authority: "KIO",
          thematic_issues: ["rażąco niska cena"]
        })

      response = conn |> get(~p"/orzecznictwo-kio/#{judgement.slug}") |> html_response(200)

      assert response =~ "Podobne orzeczenia KIO"
      assert response =~ "/orzecznictwo-kio/#{related.slug}"
    end
  end

  describe "GET /orzecznictwo-kio/:slug metadata links" do
    test "links chairman to an exact chairman filter, not a full-text query", %{conn: conn} do
      judgement = create_judgement(%{chairman: "Maria Kacprzyk"})

      response = conn |> get(~p"/orzecznictwo-kio/#{judgement.slug}") |> html_response(200)

      assert response =~ "/orzecznictwo-kio/szukaj?chairman=#{URI.encode("Maria Kacprzyk")}"
      refute response =~ "/orzecznictwo-kio/szukaj?q=#{URI.encode("Maria Kacprzyk")}"
    end

    test "links contracting authority to an exact contracting_authority filter", %{conn: conn} do
      judgement = create_judgement(%{contracting_authority: "Politechnika Poznańska"})

      response = conn |> get(~p"/orzecznictwo-kio/#{judgement.slug}") |> html_response(200)

      assert response =~
               "/orzecznictwo-kio/szukaj?contracting_authority=#{URI.encode("Politechnika Poznańska")}"

      refute response =~ "/orzecznictwo-kio/szukaj?q=#{URI.encode("Politechnika Poznańska")}"
    end

    test "links location to an exact location filter", %{conn: conn} do
      judgement = create_judgement(%{location: "Poznań"})

      response = conn |> get(~p"/orzecznictwo-kio/#{judgement.slug}") |> html_response(200)

      assert response =~ "/orzecznictwo-kio/szukaj?location=#{URI.encode("Poznań")}"
      refute response =~ "/orzecznictwo-kio/szukaj?q=#{URI.encode("Poznań")}"
    end
  end

  describe "GET /orzecznictwo-kio/:slug titles and navigation" do
    test "labels an order as postanowienie, not wyrok", %{conn: conn} do
      judgement = create_judgement(%{})
      {:ok, judgement} = Judgements.update_judgement(judgement, %{document_type: "postanowienie"})

      conn = get(conn, ~p"/orzecznictwo-kio/#{judgement.slug}")
      html_response(conn, 200)

      assert conn.assigns.heading == "Postanowienie #{judgement.signature}"
      assert conn.assigns.page_title =~ "Postanowienie #{judgement.signature}"
      refute conn.assigns.page_title =~ "Wyrok"
    end

    test "puts the decision date and main topic in the title", %{conn: conn} do
      judgement = create_judgement(%{thematic_issues: ["zamawiający", "rażąco niska cena"]})

      {:ok, judgement} =
        Judgements.update_judgement(judgement, %{
          document_type: "wyrok",
          decision_date: ~D[2025-03-12]
        })

      conn = get(conn, ~p"/orzecznictwo-kio/#{judgement.slug}")
      html_response(conn, 200)

      assert conn.assigns.page_title ==
               "Wyrok #{judgement.signature} z 12.03.2025 — rażąco niska cena"
    end

    test "links curated issues to their topic hub with a followable link", %{conn: conn} do
      judgement = create_judgement(%{thematic_issues: ["rażąco niska cena", "egzotyczne"]})

      document =
        conn
        |> get(~p"/orzecznictwo-kio/#{judgement.slug}")
        |> html_response(200)
        |> LazyHTML.from_document()

      hub_link =
        LazyHTML.query(document, ~s(#sidebar a[href="/orzecznictwo-kio/razaco-niska-cena"]))

      assert Enum.count(hub_link) == 1
      assert LazyHTML.attribute(hub_link, "rel") == []

      search_link =
        LazyHTML.query(document, ~s(#sidebar a[href^="/orzecznictwo-kio/szukaj?zagadnienie="]))

      assert LazyHTML.attribute(search_link, "rel") == ["nofollow"]
    end

    test "shows breadcrumbs through the pillar page and topic hub", %{conn: conn} do
      judgement = create_judgement(%{thematic_issues: ["wadium"]})

      document =
        conn
        |> get(~p"/orzecznictwo-kio/#{judgement.slug}")
        |> html_response(200)
        |> LazyHTML.from_document()

      crumbs = LazyHTML.query(document, "#judgement-breadcrumbs a")

      assert LazyHTML.attribute(crumbs, "href") == [
               "/orzecznictwo-kio",
               "/orzecznictwo-kio/wadium"
             ]
    end
  end

  describe "GET /orzecznictwo-kio/:slug for an unknown ruling" do
    test "returns a real 404 instead of redirecting to search", %{conn: conn} do
      conn = get(conn, ~p"/orzecznictwo-kio/kio-does-not-exist-99")

      assert html_response(conn, 404)
    end
  end

  describe "legacy /orzeczenie/:slug URLs" do
    test "permanently redirect to the ruling under /orzecznictwo-kio", %{conn: conn} do
      judgement = create_judgement(%{})

      conn = get(conn, "/orzeczenie/#{judgement.slug}")

      assert redirected_to(conn, 301) == "/orzecznictwo-kio/#{judgement.slug}"
    end

    test "resolve a numeric id to the slug URL", %{conn: conn} do
      judgement = create_judgement(%{})

      conn = get(conn, "/orzeczenie/#{judgement.id}")

      assert redirected_to(conn, 301) == "/orzecznictwo-kio/#{judgement.slug}"
    end

    test "return 404 for an unknown ruling", %{conn: conn} do
      assert conn |> get("/orzeczenie/kio-does-not-exist-99") |> html_response(404)
    end
  end

  describe "canonical URL" do
    test "points at the ruling under /orzecznictwo-kio", %{conn: conn} do
      judgement = create_judgement(%{})

      conn = get(conn, ~p"/orzecznictwo-kio/#{judgement.slug}")
      html_response(conn, 200)

      assert conn.assigns.canonical_url ==
               "https://przetargowi.pl/orzecznictwo-kio/#{judgement.slug}"
    end
  end

  describe "joint cases and bad source dates" do
    defp create_joint_case do
      {:ok, judgement} =
        Judgements.upsert_from_list(%{
          uzp_id: "#{System.unique_integer([:positive])}",
          signature: "KIO 2728/23|KIO 2729/23",
          document_type: "wyrok",
          synced_at: DateTime.utc_now()
        })

      judgement
    end

    test "a joint case gets a slug with a separator between its signatures" do
      assert create_joint_case().slug == "kio-2728-23-kio-2729-23"
    end

    test "the old slug without a separator redirects to the corrected one", %{conn: conn} do
      create_joint_case()

      assert conn |> get("/orzecznictwo-kio/kio-2728-23kio-2729-23") |> redirected_to(301) ==
               "/orzecznictwo-kio/kio-2728-23-kio-2729-23"

      assert conn |> get("/orzeczenie/kio-2728-23kio-2729-23") |> redirected_to(301) ==
               "/orzecznictwo-kio/kio-2728-23-kio-2729-23"
    end

    test "a joint case is headed with readable signatures, not the stored separator", %{
      conn: conn
    } do
      judgement = create_joint_case()

      conn = get(conn, ~p"/orzecznictwo-kio/#{judgement.slug}")
      html_response(conn, 200)

      assert conn.assigns.heading == "Wyrok KIO 2728/23, KIO 2729/23"
    end

    test "a decision date in the future is not stored" do
      future = Date.add(Date.utc_today(), 30)

      {:ok, judgement} =
        Judgements.upsert_from_list(%{
          uzp_id: "#{System.unique_integer([:positive])}",
          signature: "KIO #{System.unique_integer([:positive])}/25",
          decision_date: future,
          synced_at: DateTime.utc_now()
        })

      assert judgement.decision_date == nil
    end
  end

  describe "document order" do
    test "the summary comes before the metadata sidebar in the HTML", %{conn: conn} do
      judgement =
        create_judgement(%{
          content_html: "<p>#{String.duplicate("treść ", 200)}</p>",
          resolution_method: "oddalone"
        })

      response = conn |> get(~p"/orzecznictwo-kio/#{judgement.slug}") |> html_response(200)

      {summary, _} = :binary.match(response, "Streszczenie orzeczenia")
      {sidebar, _} = :binary.match(response, ~s(id="sidebar"))

      assert summary < sidebar
    end
  end
end
