defmodule Przetargowi.UZP.SyncWorker do
  @moduledoc """
  Oban worker for syncing judgements from UZP website.
  Runs daily to fetch new judgements from list pages and their details.
  """

  use Oban.Worker,
    queue: :uzp_sync,
    max_attempts: 3,
    unique: [period: :infinity, states: [:available, :scheduled, :executing]]

  alias Przetargowi.Judgements
  alias Przetargowi.UZP.Scraper

  require Logger

  @max_pages 100
  @delay_between_requests 1_000

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    mode = Map.get(args, "mode", "full")

    case mode do
      "list" -> sync_list_pages(args)
      "details" -> sync_details()
      "full" -> sync_full()
    end
  end

  defp sync_full do
    with :ok <- sync_list_pages(%{}),
         :ok <- sync_details() do
      :ok
    end
  end

  defp sync_list_pages(args) do
    max_pages = Map.get(args, "max_pages", @max_pages)

    Logger.info("Starting UZP list sync, max_pages: #{max_pages}")

    result =
      1..max_pages
      |> Enum.reduce_while({:ok, 0}, fn page, {:ok, count} ->
        Process.sleep(@delay_between_requests)

        case sync_page(page) do
          {:ok, 0} ->
            Logger.info("No more results on page #{page}, stopping")
            {:halt, {:ok, count}}

          {:ok, page_count} ->
            Logger.info("Synced page #{page}, #{page_count} judgements")
            {:cont, {:ok, count + page_count}}

          {:error, reason} ->
            Logger.error("Failed to sync page #{page}: #{inspect(reason)}")
            {:halt, {:error, reason}}
        end
      end)

    case result do
      {:ok, total} ->
        Logger.info("UZP list sync completed, total: #{total} judgements")
        :ok

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp sync_page(page) do
    case Scraper.fetch_list_page(page) do
      {:ok, %{judgements: []}} ->
        {:ok, 0}

      {:ok, %{judgements: judgements}} ->
        Enum.each(judgements, fn attrs ->
          case Judgements.upsert_from_list(attrs) do
            {:ok, _judgement} -> :ok
            {:error, changeset} ->
              Logger.warning("Failed to upsert judgement #{attrs.uzp_id}: #{inspect(changeset.errors)}")
          end
        end)

        {:ok, length(judgements)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp sync_details do
    Logger.info("Starting UZP details sync")

    judgements = Judgements.judgements_needing_details(100)
    Logger.info("Found #{length(judgements)} judgements needing details")

    results =
      Enum.map(judgements, fn judgement ->
        Process.sleep(@delay_between_requests)
        sync_judgement_details(judgement)
      end)

    success_count = Enum.count(results, &(&1 == :ok))
    error_count = Enum.count(results, &(&1 != :ok))

    Logger.info("UZP details sync completed, success: #{success_count}, errors: #{error_count}")

    if error_count > length(judgements) / 2 do
      {:error, "Too many errors during details sync"}
    else
      :ok
    end
  end

  defp sync_judgement_details(judgement) do
    case Scraper.fetch_details(judgement.uzp_id) do
      {:ok, details} ->
        case Judgements.update_with_details(judgement, details) do
          {:ok, _updated} ->
            Logger.debug("Updated details for #{judgement.uzp_id}")
            :ok

          {:error, changeset} ->
            Logger.warning("Failed to update details for #{judgement.uzp_id}: #{inspect(changeset.errors)}")
            {:error, changeset}
        end

      {:error, reason} ->
        Logger.warning("Failed to fetch details for #{judgement.uzp_id}: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
