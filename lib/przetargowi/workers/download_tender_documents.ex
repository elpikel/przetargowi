defmodule Przetargowi.Workers.DownloadTenderDocuments do
  @moduledoc """
  Oban worker for downloading tender document content from e-Zamówienia platform.
  Downloads all pending documents and stores their binary content in the database.

  Automatically schedules next batch until all documents are downloaded.

  ## Usage

      # Start downloading all pending documents
      Przetargowi.Workers.DownloadTenderDocuments.new(%{}) |> Oban.insert()

      # Custom batch size (default 50)
      Przetargowi.Workers.DownloadTenderDocuments.new(%{batch_size: 100}) |> Oban.insert()
  """
  use Oban.Worker,
    queue: :documents,
    max_attempts: 3,
    unique: [period: 60]

  alias Przetargowi.Tenders

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    batch_size = args["batch_size"] || 50

    documents = Tenders.get_documents_to_download(batch_size)
    count = length(documents)

    if count == 0 do
      Logger.info("No documents to download, all synced")
      :ok
    else
      Logger.info("Downloading #{count} documents...")

      Enum.each(documents, fn document ->
        download_and_store(document)
        Process.sleep(500)
      end)

      # Schedule next batch if we had a full batch (more might be waiting)
      if count == batch_size do
        Logger.info("Scheduling next batch...")

        %{batch_size: batch_size}
        |> __MODULE__.new(schedule_in: 5)
        |> Oban.insert()
      else
        Logger.info("All documents downloaded")
      end

      :ok
    end
  end

  defp download_and_store(document) do
    Logger.info("Downloading document #{document.object_id}: #{document.file_name}")

    case download_document(document.url) do
      {:ok, content} ->
        case Tenders.update_document_content(document, content) do
          {:ok, _} ->
            Logger.info(
              "Successfully downloaded #{document.file_name} (#{byte_size(content)} bytes)"
            )

          {:error, changeset} ->
            Logger.warning(
              "Failed to save document #{document.object_id}: #{inspect(changeset.errors)}"
            )
        end

      {:error, reason} ->
        Logger.warning("Failed to download #{document.file_name}: #{inspect(reason)}")
        Tenders.mark_document_download_failed(document, reason)
    end
  end

  defp download_document(url) do
    opts = [
      redirect: true,
      max_redirects: 5,
      retry: false,
      receive_timeout: 30_000,
      connect_options: [
        transport_opts: [verify: :verify_none]
      ]
    ]

    case Req.get(url, opts) do
      {:ok, %{status: 200, body: body}} when is_binary(body) ->
        cond do
          # Check for HTML response (SPA redirect or error page)
          String.contains?(body, "<!doctype html>") or String.contains?(body, "<html") ->
            {:error, :spa_redirect}

          # Valid binary content
          byte_size(body) > 0 ->
            {:ok, body}

          true ->
            {:error, :empty_response}
        end

      {:ok, %{status: status}} ->
        {:error, {:http_error, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
