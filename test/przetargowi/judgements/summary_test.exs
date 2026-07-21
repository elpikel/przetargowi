defmodule Przetargowi.Judgements.SummaryTest do
  use ExUnit.Case, async: true

  alias Przetargowi.Judgements.Summary

  defp judgement(attrs) do
    Map.merge(
      %{
        signature: nil,
        decision_date: nil,
        contracting_authority: nil,
        location: nil,
        procedure_type: nil,
        resolution_method: nil,
        thematic_issues: [],
        key_provisions: [],
        meritum: nil,
        deliberation: nil,
        content_html: nil
      },
      attrs
    )
  end

  describe "indexable?/1" do
    test "empty page (no content) is not indexable" do
      refute Summary.indexable?(judgement(%{}))
    end

    test "page with substantial content_html is indexable" do
      refute Summary.indexable?(judgement(%{content_html: "<p>short</p>"}))
      assert Summary.indexable?(judgement(%{content_html: String.duplicate("a", 500)}))
    end

    test "page with a meritum summary is indexable" do
      assert Summary.indexable?(judgement(%{meritum: String.duplicate("słowo ", 20)}))
    end
  end

  describe "narrative/1" do
    test "returns nil when there is nothing to say" do
      assert Summary.narrative(judgement(%{})) == nil
    end

    test "composes signature, date, procedure, outcome, issues and provisions" do
      text =
        Summary.narrative(
          judgement(%{
            signature: "KIO 1234/24",
            decision_date: ~D[2024-03-12],
            contracting_authority: "Politechnika Poznańska",
            location: "Poznań",
            procedure_type: "przetarg nieograniczony",
            resolution_method: "oddalone",
            thematic_issues: ["rażąco niska cena", "wykluczenie wykonawcy"],
            key_provisions: ["art. 226 ust. 1"]
          })
        )

      assert text =~ "KIO 1234/24"
      assert text =~ "12 marca 2024 r."
      assert text =~ "Politechnika Poznańska"
      assert text =~ "Poznań"
      assert text =~ "przetarg nieograniczony"
      assert text =~ "oddaliła odwołanie"
      assert text =~ "rażąco niska cena, wykluczenie wykonawcy"
      assert text =~ "art. 226 ust. 1"
    end

    test "maps resolution methods to readable Polish outcomes" do
      assert Summary.narrative(
               judgement(%{signature: "KIO 1/24", resolution_method: "uwzględnione"})
             ) =~
               "uwzględniła odwołanie"

      assert Summary.narrative(
               judgement(%{signature: "KIO 2/24", resolution_method: "umorzone (wycofanie)"})
             ) =~ "umorzone"
    end
  end

  describe "format_date/1" do
    test "formats as Polish long form" do
      assert Summary.format_date(~D[2024-01-05]) == "5 stycznia 2024 r."
      assert Summary.format_date(~D[2023-12-31]) == "31 grudnia 2023 r."
    end

    test "nil returns nil" do
      assert Summary.format_date(nil) == nil
    end
  end
end
