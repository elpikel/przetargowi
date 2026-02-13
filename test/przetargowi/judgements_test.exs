defmodule Przetargowi.JudgementsTest do
  use Przetargowi.DataCase, async: true

  alias Przetargowi.Judgements

  describe "list_judgements/1" do
    test "returns judgements ordered by decision_date desc" do
      {:ok, j1} = create_judgement(%{decision_date: ~D[2024-12-10]})
      {:ok, j2} = create_judgement(%{decision_date: ~D[2024-12-15]})
      {:ok, j3} = create_judgement(%{decision_date: ~D[2024-12-12]})

      result = Judgements.list_judgements()

      assert [first, second, third] = result
      assert first.id == j2.id
      assert second.id == j3.id
      assert third.id == j1.id
    end

    test "respects limit option" do
      for i <- 1..5, do: create_judgement(%{uzp_id: "#{i}"})

      result = Judgements.list_judgements(limit: 2)
      assert length(result) == 2
    end

    test "respects offset option" do
      for i <- 1..5 do
        create_judgement(%{uzp_id: "#{i}", decision_date: Date.add(~D[2024-12-01], i)})
      end

      result = Judgements.list_judgements(limit: 2, offset: 2)
      assert length(result) == 2
    end
  end

  describe "get_judgement/1" do
    test "returns judgement by id" do
      {:ok, judgement} = create_judgement()
      assert Judgements.get_judgement(judgement.id).id == judgement.id
    end

    test "returns nil for non-existent id" do
      assert Judgements.get_judgement(-1) == nil
    end
  end

  describe "get_judgement_by_uzp_id/1" do
    test "returns judgement by uzp_id" do
      {:ok, judgement} = create_judgement(%{uzp_id: "99999"})
      result = Judgements.get_judgement_by_uzp_id("99999")
      assert result.id == judgement.id
    end

    test "returns nil for non-existent uzp_id" do
      assert Judgements.get_judgement_by_uzp_id("nonexistent") == nil
    end
  end

  describe "upsert_from_list/1" do
    test "creates new judgement" do
      attrs = %{
        uzp_id: "12345",
        signature: "KIO 1234/24",
        issuing_authority: "KIO",
        document_type: "Wyrok",
        decision_date: ~D[2024-12-15],
        synced_at: DateTime.utc_now()
      }

      assert {:ok, judgement} = Judgements.upsert_from_list(attrs)
      assert judgement.uzp_id == "12345"
      assert judgement.signature == "KIO 1234/24"
    end

    test "updates existing judgement with same uzp_id" do
      attrs = %{
        uzp_id: "12345",
        signature: "KIO 1234/24",
        synced_at: DateTime.utc_now()
      }

      {:ok, original} = Judgements.upsert_from_list(attrs)

      updated_attrs = %{
        uzp_id: "12345",
        signature: "KIO 1234/24 (updated)",
        synced_at: DateTime.utc_now()
      }

      {:ok, updated} = Judgements.upsert_from_list(updated_attrs)

      assert updated.id == original.id
      assert updated.signature == "KIO 1234/24 (updated)"
    end
  end

  describe "update_with_details/2" do
    test "updates judgement with detail fields" do
      {:ok, judgement} = create_judgement()

      details = %{
        chairman: "Jan Kowalski",
        contracting_authority: "Gmina Warszawa",
        location: "Warszawa",
        resolution_method: "Oddalenie odwołania",
        procedure_type: "Przetarg nieograniczony",
        key_provisions: ["Art. 226", "Art. 109"],
        thematic_issues: ["Wykluczenie"],
        content_html: "<p>Content</p>",
        pdf_url: "https://example.com/doc.pdf",
        details_synced_at: DateTime.utc_now()
      }

      assert {:ok, updated} = Judgements.update_with_details(judgement, details)
      assert updated.chairman == "Jan Kowalski"
      assert updated.contracting_authority == "Gmina Warszawa"
      assert updated.key_provisions == ["Art. 226", "Art. 109"]
      assert updated.details_synced_at != nil
    end
  end

  describe "judgements_needing_details/1" do
    test "returns judgements without details_synced_at" do
      # j1 - no details (default from upsert_from_list)
      {:ok, j1} = create_judgement()
      # j2 - with details synced
      {:ok, j2} = create_judgement()
      {:ok, _j2_updated} = Judgements.update_with_details(j2, %{details_synced_at: DateTime.utc_now()})
      # j3 - no details
      {:ok, j3} = create_judgement()

      result = Judgements.judgements_needing_details()

      ids = Enum.map(result, & &1.id)
      assert j1.id in ids
      assert j3.id in ids
      assert length(result) == 2
    end

    test "respects limit parameter" do
      for i <- 1..5, do: create_judgement(%{uzp_id: "#{i}"})

      result = Judgements.judgements_needing_details(2)
      assert length(result) == 2
    end
  end

  describe "count_judgements/0" do
    test "returns total count" do
      for i <- 1..3, do: create_judgement(%{uzp_id: "#{i}"})

      assert Judgements.count_judgements() == 3
    end
  end

  describe "search_judgements/2" do
    test "searches by signature" do
      {:ok, j1} = create_judgement(%{signature: "KIO 1234/24"})
      {:ok, _j2} = create_judgement(%{signature: "KIO 5678/24"})

      result = Judgements.search_judgements("1234")
      assert length(result) == 1
      assert hd(result).id == j1.id
    end

    test "searches by contracting_authority" do
      {:ok, j1} = create_judgement()
      {:ok, _} = Judgements.update_with_details(j1, %{contracting_authority: "Gmina Warszawa"})

      {:ok, j2} = create_judgement()
      {:ok, _} = Judgements.update_with_details(j2, %{contracting_authority: "Gmina Kraków"})

      result = Judgements.search_judgements("Warszawa")
      assert length(result) == 1
      assert hd(result).id == j1.id
    end

    test "case insensitive search" do
      {:ok, j1} = create_judgement(%{signature: "KIO 1234/24"})

      result = Judgements.search_judgements("kio")
      assert length(result) == 1
      assert hd(result).id == j1.id
    end
  end

  # Helper function to create test judgements
  defp create_judgement(attrs \\ %{}) do
    default_attrs = %{
      uzp_id: "#{System.unique_integer([:positive])}",
      signature: "KIO #{System.unique_integer([:positive])}/24",
      synced_at: DateTime.utc_now()
    }

    merged = Map.merge(default_attrs, attrs)
    Judgements.upsert_from_list(merged)
  end
end
