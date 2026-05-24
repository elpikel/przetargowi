defmodule Przetargowi.TendersTest do
  use Przetargowi.DataCase

  alias Przetargowi.Tenders
  alias Przetargowi.Tenders.TenderDocument

  import Przetargowi.TendersFixtures

  describe "get_documents_to_download/1" do
    test "returns documents without content or error" do
      doc = tender_document_fixture(file_name: "test.docx")

      [returned_doc] = Tenders.get_documents_to_download(10)

      assert returned_doc.object_id == doc.object_id
    end

    test "excludes documents with content" do
      _doc_with_content = tender_document_with_content_fixture(file_name: "filled.docx")
      doc_without = tender_document_fixture(file_name: "empty.docx")

      docs = Tenders.get_documents_to_download(10)

      assert length(docs) == 1
      assert hd(docs).object_id == doc_without.object_id
    end

    test "excludes documents with download error" do
      _doc_with_error = tender_document_with_error_fixture(file_name: "error.docx")
      doc_without = tender_document_fixture(file_name: "empty.docx")

      docs = Tenders.get_documents_to_download(10)

      assert length(docs) == 1
      assert hd(docs).object_id == doc_without.object_id
    end

    test "returns all file types" do
      pdf = tender_document_fixture(file_name: "document.pdf")
      docx = tender_document_fixture(file_name: "formularz.docx")
      doc = tender_document_fixture(file_name: "oswiadczenie.doc")

      docs = Tenders.get_documents_to_download(10)

      assert length(docs) == 3
      object_ids = Enum.map(docs, & &1.object_id)
      assert pdf.object_id in object_ids
      assert docx.object_id in object_ids
      assert doc.object_id in object_ids
    end

    test "respects limit parameter" do
      for _ <- 1..5, do: tender_document_fixture(file_name: "doc.docx")

      docs = Tenders.get_documents_to_download(3)

      assert length(docs) == 3
    end

    test "returns empty list when no documents need downloading" do
      _doc_with_content = tender_document_with_content_fixture()

      assert Tenders.get_documents_to_download(10) == []
    end
  end

  describe "update_document_content/2" do
    test "stores content and sets downloaded_at" do
      doc = tender_document_fixture()
      content = "PK test content"

      {:ok, updated} = Tenders.update_document_content(doc, content)

      assert updated.content == content
      assert updated.downloaded_at != nil
      assert updated.download_error == nil
    end

    test "clears previous download error" do
      doc = tender_document_with_error_fixture()
      content = "PK test content"

      {:ok, updated} = Tenders.update_document_content(doc, content)

      assert updated.content == content
      assert updated.download_error == nil
    end
  end

  describe "mark_document_download_failed/2" do
    test "stores error message" do
      doc = tender_document_fixture()

      {:ok, updated} = Tenders.mark_document_download_failed(doc, :spa_redirect)

      assert updated.download_error == "spa_redirect"
      assert updated.downloaded_at == nil
    end

    test "handles tuple errors" do
      doc = tender_document_fixture()

      {:ok, updated} = Tenders.mark_document_download_failed(doc, {:http_error, 404})

      assert updated.download_error == "{:http_error, 404}"
    end
  end

  describe "get_document/1" do
    test "returns document by object_id" do
      doc = tender_document_fixture()

      assert %TenderDocument{} = Tenders.get_document(doc.object_id)
    end

    test "returns nil for non-existent document" do
      assert Tenders.get_document("non-existent") == nil
    end
  end

  describe "list_sitemap_entries/2" do
    test "returns all entries with slug when no limit" do
      notice1 = tender_notice_fixture()
      notice2 = tender_notice_fixture()

      entries = Tenders.list_sitemap_entries()

      slugs = Enum.map(entries, & &1.slug)
      assert notice1.slug in slugs
      assert notice2.slug in slugs
    end

    test "excludes entries without slug" do
      notice_with_slug = tender_notice_fixture()

      Repo.insert!(%Przetargowi.Tenders.TenderNotice{
        object_id: "no-slug-#{System.unique_integer([:positive])}",
        notice_type: "ContractNotice",
        notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
        bzp_number: "BZP-#{System.unique_integer([:positive])}",
        is_tender_amount_below_eu: true,
        publication_date: DateTime.utc_now() |> DateTime.truncate(:second),
        cpv_codes: ["45000000-7"],
        organization_name: "Test",
        organization_city: "Warszawa",
        organization_country: "Polska",
        organization_national_id: "123",
        organization_id: "ORG-123",
        html_body: "<html>Test</html>",
        slug: nil
      })

      entries = Tenders.list_sitemap_entries()

      slugs = Enum.map(entries, & &1.slug)
      assert notice_with_slug.slug in slugs
      assert length(entries) == 1
    end

    test "respects limit and offset for pagination" do
      for _ <- 1..5, do: tender_notice_fixture()

      entries_page1 = Tenders.list_sitemap_entries(2, 0)
      entries_page2 = Tenders.list_sitemap_entries(2, 2)
      entries_page3 = Tenders.list_sitemap_entries(2, 4)

      assert length(entries_page1) == 2
      assert length(entries_page2) == 2
      assert length(entries_page3) == 1

      all_slugs =
        (entries_page1 ++ entries_page2 ++ entries_page3)
        |> Enum.map(& &1.slug)
        |> Enum.uniq()

      assert length(all_slugs) == 5
    end

    test "returns entries with updated_at field" do
      tender_notice_fixture()

      [entry] = Tenders.list_sitemap_entries()

      assert %{slug: _, updated_at: %NaiveDateTime{}} = entry
    end
  end

  describe "count_sitemap_entries/0" do
    test "returns count of entries with slug" do
      for _ <- 1..3, do: tender_notice_fixture()

      assert Tenders.count_sitemap_entries() == 3
    end

    test "excludes entries without slug" do
      tender_notice_fixture()

      Repo.insert!(%Przetargowi.Tenders.TenderNotice{
        object_id: "no-slug-count-#{System.unique_integer([:positive])}",
        notice_type: "ContractNotice",
        notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
        bzp_number: "BZP-#{System.unique_integer([:positive])}",
        is_tender_amount_below_eu: true,
        publication_date: DateTime.utc_now() |> DateTime.truncate(:second),
        cpv_codes: ["45000000-7"],
        organization_name: "Test",
        organization_city: "Warszawa",
        organization_country: "Polska",
        organization_national_id: "123",
        organization_id: "ORG-456",
        html_body: "<html>Test</html>",
        slug: nil
      })

      assert Tenders.count_sitemap_entries() == 1
    end

    test "returns 0 when no entries" do
      assert Tenders.count_sitemap_entries() == 0
    end
  end

  describe "upsert_tender_document/1" do
    test "inserts new document with valid attrs" do
      attrs = valid_tender_document_attributes()

      assert {:ok, doc} = Tenders.upsert_tender_document(attrs)
      assert doc.object_id == attrs[:object_id]
      assert doc.tender_id == attrs[:tender_id]
      assert doc.name == attrs[:name]
    end

    test "updates existing document on conflict" do
      attrs = valid_tender_document_attributes()
      {:ok, original} = Tenders.upsert_tender_document(attrs)

      updated_attrs = Map.put(attrs, :name, "Updated name")
      {:ok, updated} = Tenders.upsert_tender_document(updated_attrs)

      assert updated.object_id == original.object_id
      assert updated.name == "Updated name"
    end

    test "returns error changeset when required fields missing" do
      attrs = %{object_id: "test-id"}

      assert {:error, changeset} = Tenders.upsert_tender_document(attrs)
      refute changeset.valid?

      errors = errors_on(changeset)
      assert "can't be blank" in errors.tender_id
      assert "can't be blank" in errors.name
      assert "can't be blank" in errors.file_name
      assert "can't be blank" in errors.url
    end
  end

  describe "upsert_tender_documents/1" do
    test "inserts multiple documents" do
      attrs1 = valid_tender_document_attributes()
      attrs2 = valid_tender_document_attributes()

      {success_count, failed} = Tenders.upsert_tender_documents([attrs1, attrs2])

      assert success_count == 2
      assert failed == []
    end

    @tag capture_log: true
    test "returns failed documents with errors" do
      valid_attrs = valid_tender_document_attributes()
      invalid_attrs = %{object_id: "invalid-doc"}

      {success_count, failed} = Tenders.upsert_tender_documents([valid_attrs, invalid_attrs])

      assert success_count == 1
      assert length(failed) == 1
      assert {:error, ^invalid_attrs, _changeset} = hd(failed)
    end

    test "handles empty list" do
      {success_count, failed} = Tenders.upsert_tender_documents([])

      assert success_count == 0
      assert failed == []
    end
  end

  describe "cpv_main backfill on upsert" do
    test "backfills cpv_main from cpv_codes when cpv_main is nil" do
      {:ok, tender} =
        Tenders.upsert_tender_notice(%{
          object_id: "backfill-test-#{System.unique_integer([:positive])}",
          notice_type: "TenderResultNotice",
          notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
          bzp_number: "BZP-#{System.unique_integer([:positive])}",
          is_tender_amount_below_eu: true,
          publication_date: DateTime.utc_now() |> DateTime.truncate(:second),
          cpv_codes: ["33600000-6 (Produkty farmaceutyczne)", "33692200-9 (Produkty)"],
          cpv_main: nil,
          organization_name: "Test Org",
          organization_city: "Warszawa",
          organization_country: "Polska",
          organization_national_id: "123",
          organization_id: "ORG-#{System.unique_integer([:positive])}",
          html_body: "<html>Test</html>"
        })

      assert tender.cpv_main == "33600000-6"
    end

    test "does not backfill when cpv_main already set and no HTML parsing" do
      {:ok, tender} =
        Tenders.upsert_tender_notice(%{
          object_id: "no-overwrite-#{System.unique_integer([:positive])}",
          notice_type: "ContractNotice",
          notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
          bzp_number: "BZP-#{System.unique_integer([:positive])}",
          is_tender_amount_below_eu: true,
          publication_date: DateTime.utc_now() |> DateTime.truncate(:second),
          cpv_codes: ["99999999-9 (Other)"],
          cpv_main: "11111111-1",
          organization_name: "Test Org",
          organization_city: "Warszawa",
          organization_country: "Polska",
          organization_national_id: "123",
          organization_id: "ORG-#{System.unique_integer([:positive])}",
          html_body: "<html>No CPV section</html>"
        })

      # HTML parsing returns nil for cpv_main, so backfill kicks in from cpv_codes
      assert tender.cpv_main == "99999999-9"
    end

    test "leaves cpv_main nil when cpv_codes is empty" do
      {:ok, tender} =
        Tenders.upsert_tender_notice(%{
          object_id: "empty-cpv-#{System.unique_integer([:positive])}",
          notice_type: "TenderResultNotice",
          notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
          bzp_number: "BZP-#{System.unique_integer([:positive])}",
          is_tender_amount_below_eu: true,
          publication_date: DateTime.utc_now() |> DateTime.truncate(:second),
          cpv_codes: [],
          cpv_main: nil,
          organization_name: "Test Org",
          organization_city: "Warszawa",
          organization_country: "Polska",
          organization_national_id: "123",
          organization_id: "ORG-#{System.unique_integer([:positive])}",
          html_body: "<html>Test</html>"
        })

      assert tender.cpv_main == nil
    end
  end

  describe "winner analysis (compute + read)" do
    defp result_notice_fixture(attrs) do
      attrs =
        Map.merge(
          %{
            notice_type: "TenderResultNotice",
            publication_date: DateTime.utc_now() |> DateTime.truncate(:second)
          },
          attrs
        )

      tender_notice_fixture(attrs)
    end

    test "get_winner_analysis returns nil when tender has no cpv_main" do
      tender = tender_notice_fixture(%{cpv_main: nil})
      assert Tenders.get_winner_analysis(tender) == nil
    end

    test "get_winner_analysis returns nil when no analysis has been computed" do
      tender = tender_notice_fixture(%{cpv_main: "99999999", order_type: "Delivery"})
      assert Tenders.get_winner_analysis(tender) == nil
    end

    test "compute national and get_winner_analysis reads it back" do
      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "Firma ABC",
            contractor_city: "Kraków",
            contractor_nip: "1111111111",
            winning_price: Decimal.new("100000"),
            contract_value: Decimal.new("120000")
          }
        ]
      })

      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "Firma ABC",
            contractor_city: "Kraków",
            contractor_nip: "1111111111",
            winning_price: Decimal.new("200000"),
            contract_value: Decimal.new("210000")
          }
        ]
      })

      # Compute national
      assert {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Delivery")

      # Read back — no province on tender, so regional is nil
      tender =
        tender_notice_fixture(%{cpv_main: "30213000", order_type: "Delivery"})

      result = Tenders.get_winner_analysis(tender)

      assert result["regional"] == nil
      national = result["national"]
      assert national["total_similar_tenders"] == 2
      assert length(national["top_contractors"]) == 1
      assert hd(national["top_contractors"])["name"] == "Firma ABC"
      assert hd(national["top_contractors"])["win_count"] == 2
      assert national["price_stats"]["min"] == "100000"
      assert national["price_stats"]["max"] == "200000"
    end

    test "regional analysis returned when province matches" do
      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        organization_province: "PL14",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "Local Co",
            contractor_nip: "6666666666",
            winning_price: Decimal.new("90000"),
            contract_value: Decimal.new("95000")
          }
        ]
      })

      # Compute both regional and national
      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Delivery", "PL14")
      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Delivery")

      # Tender in same province — should get both regional and national
      tender =
        tender_notice_fixture(%{
          cpv_main: "30213000",
          order_type: "Delivery",
          organization_province: "PL14"
        })

      result = Tenders.get_winner_analysis(tender)

      assert result["regional"] != nil
      assert result["national"] != nil
      assert hd(result["regional"]["top_contractors"])["name"] == "Local Co"
    end

    test "falls back to national when no regional data" do
      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        organization_province: "PL14",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "Some Co",
            contractor_nip: "7777777777",
            winning_price: Decimal.new("100000"),
            contract_value: Decimal.new("100000")
          }
        ]
      })

      # Only compute national, not regional for PL22
      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Delivery")

      # Tender in PL22 — no regional data for this province
      tender =
        tender_notice_fixture(%{
          cpv_main: "30213000",
          order_type: "Delivery",
          organization_province: "PL22"
        })

      result = Tenders.get_winner_analysis(tender)

      assert result["regional"] == nil
      assert result["national"] != nil
    end

    test "compute_and_store_winner_analysis returns :skip when no tenders found" do
      assert :skip == Tenders.compute_and_store_winner_analysis("99999999", "Delivery")
    end

    test "compute_and_store_winner_analysis excludes cancelled contracts" do
      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Services",
        contractors_contract_details: [
          %{
            part: 1,
            status: :cancelled,
            contractor_name: "Cancelled Co",
            contractor_nip: "2222222222",
            winning_price: Decimal.new("999999"),
            cancellation_reason: "Cancelled"
          },
          %{
            part: 2,
            status: :contract_signed,
            contractor_name: "Good Co",
            contractor_nip: "3333333333",
            winning_price: Decimal.new("150000"),
            contract_value: Decimal.new("150000")
          }
        ]
      })

      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Services")

      tender = tender_notice_fixture(%{cpv_main: "30213000", order_type: "Services"})
      result = Tenders.get_winner_analysis(tender)

      national = result["national"]
      assert national["total_similar_tenders"] == 1
      assert length(national["top_contractors"]) == 1
      assert hd(national["top_contractors"])["name"] == "Good Co"
    end

    test "list_cpv_order_type_combos returns distinct combinations with province" do
      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        organization_province: "PL14"
      })

      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        organization_province: "PL14"
      })

      result_notice_fixture(%{
        cpv_main: "45000000",
        order_type: "Works",
        organization_province: "PL22"
      })

      combos = Tenders.list_cpv_order_type_combos()

      assert length(combos) == 2
      assert {"30213000", "Delivery", "PL14"} in combos
      assert {"45000000", "Works", "PL22"} in combos
    end

    test "recent_wins include tender details" do
      similar =
        result_notice_fixture(%{
          cpv_main: "30213000",
          order_type: "Works",
          order_object: "Komputery dla szkoły",
          contractors_contract_details: [
            %{
              part: 1,
              status: :contract_signed,
              contractor_name: "Winner Co",
              contractor_nip: "5555555555",
              winning_price: Decimal.new("80000"),
              contract_value: Decimal.new("85000")
            }
          ]
        })

      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Works")

      tender = tender_notice_fixture(%{cpv_main: "30213000", order_type: "Works"})
      result = Tenders.get_winner_analysis(tender)

      national = result["national"]
      assert length(national["recent_wins"]) == 1
      win = hd(national["recent_wins"])
      assert win["tender_title"] == "Komputery dla szkoły"
      assert win["contractor_name"] == "Winner Co"
      assert win["winning_price"] == "80000"
      assert win["tender_slug"] == similar.slug
    end

    test "handles nil prices gracefully" do
      result_notice_fixture(%{
        cpv_main: "65310000",
        order_type: "Services",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "No Price Co",
            contractor_nip: "8888888888",
            winning_price: nil,
            contract_value: nil
          }
        ]
      })

      {:ok, _} = Tenders.compute_and_store_winner_analysis("65310000", "Services")

      tender = tender_notice_fixture(%{cpv_main: "65310000", order_type: "Services"})
      result = Tenders.get_winner_analysis(tender)

      national = result["national"]
      assert national["total_similar_tenders"] == 1
      assert national["price_stats"]["avg"] == nil
      assert national["price_stats"]["min"] == nil
      assert national["price_stats"]["max"] == nil
      assert hd(national["top_contractors"])["name"] == "No Price Co"
      assert hd(national["top_contractors"])["avg_price"] == nil
    end

    test "recomputing updates existing analysis" do
      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "First Co",
            contractor_nip: "1010101010",
            winning_price: Decimal.new("50000"),
            contract_value: Decimal.new("55000")
          }
        ]
      })

      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Delivery")

      tender = tender_notice_fixture(%{cpv_main: "30213000", order_type: "Delivery"})
      result1 = Tenders.get_winner_analysis(tender)
      assert result1["national"]["total_similar_tenders"] == 1

      # Add another result notice and recompute
      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "Second Co",
            contractor_nip: "2020202020",
            winning_price: Decimal.new("70000"),
            contract_value: Decimal.new("75000")
          }
        ]
      })

      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Delivery")

      result2 = Tenders.get_winner_analysis(tender)
      assert result2["national"]["total_similar_tenders"] == 2
    end

    test "ranks contractors by win count descending" do
      for _ <- 1..3 do
        result_notice_fixture(%{
          cpv_main: "72000000",
          order_type: "Services",
          contractors_contract_details: [
            %{
              part: 1,
              status: :contract_signed,
              contractor_name: "Frequent Winner",
              contractor_nip: "1111111111",
              winning_price: Decimal.new("100000"),
              contract_value: Decimal.new("100000")
            }
          ]
        })
      end

      result_notice_fixture(%{
        cpv_main: "72000000",
        order_type: "Services",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "One-time Winner",
            contractor_nip: "2222222222",
            winning_price: Decimal.new("90000"),
            contract_value: Decimal.new("90000")
          }
        ]
      })

      {:ok, _} = Tenders.compute_and_store_winner_analysis("72000000", "Services")

      tender = tender_notice_fixture(%{cpv_main: "72000000", order_type: "Services"})
      result = Tenders.get_winner_analysis(tender)

      contractors = result["national"]["top_contractors"]
      assert length(contractors) == 2
      assert hd(contractors)["name"] == "Frequent Winner"
      assert hd(contractors)["win_count"] == 3
      assert List.last(contractors)["name"] == "One-time Winner"
      assert List.last(contractors)["win_count"] == 1
    end
  end

  describe "cleanup_old_document_content/1" do
    test "removes content from documents with old publication date" do
      # Create old tender notice (40 days ago)
      old_tender_id = "old-tender-#{System.unique_integer([:positive])}"

      Repo.insert!(%Przetargowi.Tenders.TenderNotice{
        object_id: "notice-#{old_tender_id}",
        tender_id: old_tender_id,
        notice_type: "ContractNotice",
        notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
        bzp_number: "BZP-#{System.unique_integer([:positive])}",
        is_tender_amount_below_eu: true,
        publication_date:
          DateTime.utc_now() |> DateTime.add(-40, :day) |> DateTime.truncate(:second),
        cpv_codes: ["45000000-7"],
        organization_name: "Test",
        organization_city: "Warszawa",
        organization_country: "Polska",
        organization_national_id: "123",
        organization_id: "ORG-old",
        html_body: "<html>Test</html>"
      })

      # Create document with content for old tender
      old_doc = tender_document_with_content_fixture(tender_id: old_tender_id)
      assert old_doc.content != nil

      # Create document with content for recent tender (default fixture is recent)
      recent_doc = tender_document_with_content_fixture()
      assert recent_doc.content != nil

      # Run cleanup
      count = Tenders.cleanup_old_document_content(30)

      # Should clean up 1 old document
      assert count == 1

      # Verify old document content was removed
      old_doc_updated = Tenders.get_document(old_doc.object_id)
      assert old_doc_updated.content == nil
      assert old_doc_updated.downloaded_at == nil
      # URL should still exist
      assert old_doc_updated.url != nil

      # Verify recent document content was kept
      recent_doc_updated = Tenders.get_document(recent_doc.object_id)
      assert recent_doc_updated.content != nil
    end

    test "returns 0 when no old documents with content exist" do
      # Create only recent documents
      _recent_doc = tender_document_with_content_fixture()

      count = Tenders.cleanup_old_document_content(30)

      assert count == 0
    end

    test "does not affect documents without content" do
      # Create old tender notice
      old_tender_id = "old-tender-no-content-#{System.unique_integer([:positive])}"

      Repo.insert!(%Przetargowi.Tenders.TenderNotice{
        object_id: "notice-#{old_tender_id}",
        tender_id: old_tender_id,
        notice_type: "ContractNotice",
        notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
        bzp_number: "BZP-#{System.unique_integer([:positive])}",
        is_tender_amount_below_eu: true,
        publication_date:
          DateTime.utc_now() |> DateTime.add(-40, :day) |> DateTime.truncate(:second),
        cpv_codes: ["45000000-7"],
        organization_name: "Test",
        organization_city: "Warszawa",
        organization_country: "Polska",
        organization_national_id: "123",
        organization_id: "ORG-old-no-content",
        html_body: "<html>Test</html>"
      })

      # Create document without content for old tender
      _old_doc_no_content = tender_document_fixture(tender_id: old_tender_id)

      count = Tenders.cleanup_old_document_content(30)

      assert count == 0
    end
  end

  describe "search_tender_notices with_winner_analysis filter" do
    defp future_deadline do
      DateTime.utc_now() |> DateTime.add(7, :day) |> DateTime.truncate(:second)
    end

    test "without filter returns all tenders" do
      tender_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        submitting_offers_date: future_deadline()
      })

      tender_notice_fixture(%{
        cpv_main: nil,
        order_type: "Services",
        submitting_offers_date: future_deadline()
      })

      result = Tenders.search_tender_notices(with_winner_analysis: false)
      assert result.total_count == 2
    end

    test "with filter returns only tenders that have winner analysis" do
      # Tender with cpv_main that has analysis
      tender_with =
        tender_notice_fixture(%{
          cpv_main: "30213000",
          order_type: "Delivery",
          submitting_offers_date: future_deadline()
        })

      # Create result notice and compute analysis for this CPV + order_type
      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "Firma ABC",
            contractor_nip: "1111111111",
            winning_price: Decimal.new("100000"),
            contract_value: Decimal.new("100000")
          }
        ]
      })

      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Delivery")

      # Tender without cpv_main — no analysis possible
      _tender_without_cpv =
        tender_notice_fixture(%{
          cpv_main: nil,
          order_type: "Services",
          submitting_offers_date: future_deadline()
        })

      # Tender with cpv_main but no analysis computed
      _tender_no_analysis =
        tender_notice_fixture(%{
          cpv_main: "99999999",
          order_type: "Services",
          submitting_offers_date: future_deadline()
        })

      result = Tenders.search_tender_notices(with_winner_analysis: true)
      assert result.total_count == 1
      assert hd(result.notices).object_id == tender_with.object_id
    end

    test "with filter matches when tender cpv_main includes description suffix" do
      # Active tender has CPV with description (as ingested from BZP contract notices)
      tender_with_desc =
        tender_notice_fixture(%{
          cpv_main: "30213000-5 - Komputery osobiste",
          order_type: "Delivery",
          submitting_offers_date: future_deadline()
        })

      # Analysis was computed with clean CPV code (from result notices)
      result_notice_fixture(%{
        cpv_main: "30213000-5",
        order_type: "Delivery",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "Firma XYZ",
            contractor_nip: "3333333333",
            winning_price: Decimal.new("50000"),
            contract_value: Decimal.new("50000")
          }
        ]
      })

      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000-5", "Delivery")

      result = Tenders.search_tender_notices(with_winner_analysis: true)
      assert result.total_count == 1
      assert hd(result.notices).object_id == tender_with_desc.object_id
    end

    test "with filter combines with other filters" do
      tender_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        organization_province: "PL14",
        submitting_offers_date: future_deadline()
      })

      tender_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        organization_province: "PL02",
        submitting_offers_date: future_deadline()
      })

      # Create analysis
      result_notice_fixture(%{
        cpv_main: "30213000",
        order_type: "Delivery",
        contractors_contract_details: [
          %{
            part: 1,
            status: :contract_signed,
            contractor_name: "Firma ABC",
            contractor_nip: "1111111111",
            winning_price: Decimal.new("50000"),
            contract_value: Decimal.new("50000")
          }
        ]
      })

      {:ok, _} = Tenders.compute_and_store_winner_analysis("30213000", "Delivery")

      # Both tenders match winner analysis, but filter by region
      result =
        Tenders.search_tender_notices(
          with_winner_analysis: true,
          regions: ["mazowieckie"]
        )

      assert result.total_count == 1
    end
  end
end
