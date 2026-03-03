defmodule Przetargowi.Workers.FetchTenderDocuments do
  @moduledoc """
  Oban worker for backfilling tender documents from e-Zamówienia platform.
  Fetches documents for existing tenders that don't have documents yet.

  Note: New tenders automatically get their documents fetched by FetchTendersNotices.
  This worker is only needed for backfilling historical tenders.

  ## Usage

      # Backfill documents for 100 tenders
      Przetargowi.Workers.FetchTenderDocuments.new(%{limit: 100}) |> Oban.insert()

  ## Arguments
  - `limit` - Number of tenders to process per run (defaults to 50)
  """
  use Oban.Worker,
    queue: :tenders,
    max_attempts: 3

  alias Przetargowi.Bzp.Client, as: BZPClient
  alias Przetargowi.Tenders

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    limit = args["limit"] || 50

    Logger.info("Starting tender documents fetch for up to #{limit} tenders")

    tender_ids = Tenders.get_tender_ids_without_documents(limit)

    Logger.info("Found #{length(tender_ids)} tenders without documents")

    Enum.each(tender_ids, fn tender_id ->
      fetch_and_store_documents(tender_id)
      # Rate limiting
      Process.sleep(200)
    end)

    :ok
  end

  defp fetch_and_store_documents(tender_id) do
    case BZPClient.fetch_tender_documents(tender_id) do
      {:ok, []} ->
        Logger.debug("No documents found for tender #{tender_id}")
        :ok

      {:ok, documents} ->
        Logger.info("Found #{length(documents)} documents for tender #{tender_id}")
        {success_count, failed} = Tenders.upsert_tender_documents(documents)

        if length(failed) > 0 do
          Logger.warning("Failed to upsert #{length(failed)} documents for tender #{tender_id}")
        else
          Logger.debug("Successfully upserted #{success_count} documents for tender #{tender_id}")
        end

        :ok

      {:error, reason} ->
        Logger.warning("Failed to fetch documents for tender #{tender_id}: #{inspect(reason)}")
        :ok
    end
  end
end
