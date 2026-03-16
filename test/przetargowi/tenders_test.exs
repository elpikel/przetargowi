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
end
