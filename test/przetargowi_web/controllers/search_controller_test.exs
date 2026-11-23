defmodule PrzetargowiWeb.SearchControllerTest do
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

  describe "GET /orzecznictwo-kio/szukaj field filters" do
    test "filters results by chairman", %{conn: conn} do
      match = create_judgement(%{chairman: "Maria Kacprzyk"})
      other = create_judgement(%{chairman: "Jan Kowalski"})

      response =
        conn
        |> get(~p"/orzecznictwo-kio/szukaj", chairman: "Maria Kacprzyk")
        |> html_response(200)

      assert response =~ match.signature
      refute response =~ other.signature
    end

    test "filters results by contracting_authority", %{conn: conn} do
      match = create_judgement(%{contracting_authority: "Politechnika Poznańska"})
      other = create_judgement(%{contracting_authority: "Uniwersytet Warszawski"})

      response =
        conn
        |> get(~p"/orzecznictwo-kio/szukaj", contracting_authority: "Politechnika Poznańska")
        |> html_response(200)

      assert response =~ match.signature
      refute response =~ other.signature
    end

    test "filters results by location", %{conn: conn} do
      match = create_judgement(%{location: "Poznań"})
      other = create_judgement(%{location: "Kraków"})

      response =
        conn |> get(~p"/orzecznictwo-kio/szukaj", location: "Poznań") |> html_response(200)

      assert response =~ match.signature
      refute response =~ other.signature
    end

    test "filters results by thematic issue via the zagadnienie param", %{conn: conn} do
      match = create_judgement(%{thematic_issues: ["rażąco niska cena", "odrzucenie oferty"]})
      other = create_judgement(%{thematic_issues: ["wykluczenie wykonawcy"]})

      response =
        conn
        |> get(~p"/orzecznictwo-kio/szukaj", zagadnienie: "rażąco niska cena")
        |> html_response(200)

      assert response =~ match.signature
      refute response =~ other.signature
    end
  end

  describe "legacy /szukaj URLs" do
    test "bare URL permanently redirects to the KIO pillar page", %{conn: conn} do
      conn = get(conn, "/szukaj")

      assert redirected_to(conn, 301) == "/orzecznictwo-kio"
    end

    test "URL with parameters redirects to the new search path, keeping them", %{conn: conn} do
      conn = get(conn, "/szukaj?q=czysto%C5%9Bci&page=2")

      assert redirected_to(conn, 301) == "/orzecznictwo-kio/szukaj?q=czysto%C5%9Bci&page=2"
    end
  end

  describe "GET /orzecznictwo-kio/szukaj indexing" do
    test "search UI without a query is noindex and has no canonical", %{conn: conn} do
      response = conn |> get("/orzecznictwo-kio/szukaj") |> html_response(200)

      assert response =~ ~s(<meta name="robots" content="noindex, follow">)
      refute response =~ ~s(rel="canonical")
    end

    test "search results are noindex", %{conn: conn} do
      response = conn |> get("/orzecznictwo-kio/szukaj?q=wadium") |> html_response(200)

      assert response =~ ~s(<meta name="robots" content="noindex, follow">)
    end
  end
end
