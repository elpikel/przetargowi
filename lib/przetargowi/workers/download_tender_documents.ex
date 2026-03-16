defmodule Przetargowi.Workers.DownloadTenderDocuments do
  @moduledoc """
  Oban worker for downloading tender document content from e-Zamówienia platform.
  Downloads all documents and stores their binary content in the database.

  ## Usage

      # Download up to 50 documents
      Przetargowi.Workers.DownloadTenderDocuments.new(%{}) |> Oban.insert()

      # Download with custom limit
      Przetargowi.Workers.DownloadTenderDocuments.new(%{limit: 100}) |> Oban.insert()

  ## Arguments
  - `limit` - Number of documents to process per run (defaults to 50)
  """
  use Oban.Worker,
    queue: :documents,
    max_attempts: 3

  alias Przetargowi.Tenders

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    limit = args["limit"] || 50

    Logger.info("Starting tender document download for up to #{limit} documents")

    documents = Tenders.get_documents_to_download(limit)

    Logger.info("Found #{length(documents)} documents to download")

    Enum.each(documents, fn document ->
      download_and_store(document)
      # Rate limiting to be nice to the server
      Process.sleep(500)
    end)

    :ok
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
