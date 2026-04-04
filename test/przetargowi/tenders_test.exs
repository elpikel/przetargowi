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
end
