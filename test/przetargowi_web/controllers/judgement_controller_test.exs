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
