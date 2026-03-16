defmodule Przetargowi.Workers.DownloadTenderDocumentsTest do
  use Przetargowi.DataCase
  use Oban.Testing, repo: Przetargowi.Repo

  alias Przetargowi.Workers.DownloadTenderDocuments
  alias Przetargowi.Tenders

  import Przetargowi.TendersFixtures

  describe "perform/1" do
    test "processes documents without content" do
      doc = tender_document_fixture(file_name: "test.docx")

      # Document starts without content
      assert doc.content == nil
      assert doc.downloaded_at == nil

      # Worker will try to download but URL is fake, so it will fail
      # This tests the worker runs and marks documents appropriately
      assert :ok = perform_job(DownloadTenderDocuments, %{limit: 10})

      # Document should now have an error (since URL doesn't work)
      updated = Tenders.get_document(doc.object_id)
      assert updated.download_error != nil
    end

    test "respects batch_size argument" do
      for i <- 1..5 do
        tender_document_fixture(file_name: "doc#{i}.docx")
      end

      # With batch_size 2, only 2 documents should be processed per batch
      assert :ok = perform_job(DownloadTenderDocuments, %{"batch_size" => 2})

      # Check that some documents still don't have errors (weren't processed)
      docs_without_error =
        Tenders.get_documents_to_download(10)
        |> length()

      # 5 total - 2 processed = 3 remaining (processed ones have error set)
      assert docs_without_error == 3
    end

    test "skips documents that already have content" do
      doc_with_content = tender_document_with_content_fixture(file_name: "filled.docx")
      doc_without = tender_document_fixture(file_name: "empty.docx")

      assert :ok = perform_job(DownloadTenderDocuments, %{})

      # Document with content should be unchanged
      doc_with_content_reloaded = Tenders.get_document(doc_with_content.object_id)
      assert doc_with_content_reloaded.content != nil
      assert doc_with_content_reloaded.download_error == nil

      # Document without content should have been processed (and failed due to fake URL)
      doc_without_reloaded = Tenders.get_document(doc_without.object_id)
      assert doc_without_reloaded.download_error != nil
    end

    test "skips documents that already have errors" do
      doc_with_error = tender_document_with_error_fixture(file_name: "error.docx")

      assert :ok = perform_job(DownloadTenderDocuments, %{})

      # Error document should not be reprocessed
      reloaded = Tenders.get_document(doc_with_error.object_id)
      assert reloaded.download_error == "spa_redirect"
    end

    test "returns :ok even when no documents to process" do
      # No documents in database
      assert :ok = perform_job(DownloadTenderDocuments, %{})
    end
  end

  describe "job enqueueing" do
    test "can enqueue job" do
      assert {:ok, _job} =
               DownloadTenderDocuments.new(%{limit: 50})
               |> Oban.insert()
    end

    test "uses documents queue" do
      {:ok, job} =
        DownloadTenderDocuments.new(%{})
        |> Oban.insert()

      assert job.queue == "documents"
    end
  end
end
