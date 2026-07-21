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

  describe "GET /orzeczenie/:slug indexability" do
    test "thin page with no content is marked noindex", %{conn: conn} do
      judgement = create_judgement(%{})

      response = conn |> get(~p"/orzeczenie/#{judgement.slug}") |> html_response(200)

      assert response =~ ~s(<meta name="robots" content="noindex, follow">)
    end

    test "page with real content stays indexable", %{conn: conn} do
      judgement = create_judgement(%{content_html: "<p>#{String.duplicate("treść ", 200)}</p>"})

      response = conn |> get(~p"/orzeczenie/#{judgement.slug}") |> html_response(200)

      assert response =~ ~s(<meta name="robots" content="index, follow">)
    end
  end

  describe "GET /orzeczenie/:slug unique content" do
    test "renders an original narrative summary", %{conn: conn} do
      judgement =
        create_judgement(%{
          content_html: "<p>#{String.duplicate("treść ", 200)}</p>",
          resolution_method: "oddalone",
          procedure_type: "przetarg nieograniczony"
        })

      response = conn |> get(~p"/orzeczenie/#{judgement.slug}") |> html_response(200)

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

      response = conn |> get(~p"/orzeczenie/#{judgement.slug}") |> html_response(200)

      assert response =~ "Podobne orzeczenia KIO"
      assert response =~ "/orzeczenie/#{related.slug}"
    end
  end

  describe "GET /orzeczenie/:slug metadata links" do
    test "links chairman to an exact chairman filter, not a full-text query", %{conn: conn} do
      judgement = create_judgement(%{chairman: "Maria Kacprzyk"})

      response = conn |> get(~p"/orzeczenie/#{judgement.slug}") |> html_response(200)

      assert response =~ "/szukaj?chairman=#{URI.encode("Maria Kacprzyk")}"
      refute response =~ "/szukaj?q=#{URI.encode("Maria Kacprzyk")}"
    end

    test "links contracting authority to an exact contracting_authority filter", %{conn: conn} do
      judgement = create_judgement(%{contracting_authority: "Politechnika Poznańska"})

      response = conn |> get(~p"/orzeczenie/#{judgement.slug}") |> html_response(200)

      assert response =~ "/szukaj?contracting_authority=#{URI.encode("Politechnika Poznańska")}"
      refute response =~ "/szukaj?q=#{URI.encode("Politechnika Poznańska")}"
    end

    test "links location to an exact location filter", %{conn: conn} do
      judgement = create_judgement(%{location: "Poznań"})

      response = conn |> get(~p"/orzeczenie/#{judgement.slug}") |> html_response(200)

      assert response =~ "/szukaj?location=#{URI.encode("Poznań")}"
      refute response =~ "/szukaj?q=#{URI.encode("Poznań")}"
    end
  end
end
