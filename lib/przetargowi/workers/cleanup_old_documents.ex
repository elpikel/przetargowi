defmodule Przetargowi.Workers.CleanupOldDocuments do
  @moduledoc """
  Oban worker for cleaning up document content from old tenders.
  Removes binary content from documents belonging to tenders older than 30 days
  to save database storage. The URL to the external document is preserved.

  ## Usage

      # Run cleanup with default 30 days
      Przetargowi.Workers.CleanupOldDocuments.new(%{}) |> Oban.insert()

      # Custom age threshold
      Przetargowi.Workers.CleanupOldDocuments.new(%{days_old: 60}) |> Oban.insert()
  """
  use Oban.Worker,
    queue: :default,
    max_attempts: 3

  alias Przetargowi.Tenders

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    days_old = args["days_old"] || 30

    Logger.info("Starting cleanup of documents older than #{days_old} days...")

    count = Tenders.cleanup_old_document_content(days_old)

    Logger.info("Cleaned up content from #{count} old documents")

    :ok
  end
end
