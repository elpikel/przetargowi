defmodule Przetargowi.UZP.SyncWorker do
  @moduledoc """
  Oban worker for syncing judgements from UZP website.
  Runs daily to fetch new judgements from list pages and their details.
  """

  use Oban.Worker,
    queue: :uzp_sync,
    max_attempts: 3,
    unique: [period: :infinity, states: [:available, :scheduled, :executing]]

  alias Przetargowi.Embeddings.EmbeddingWorker
  alias Przetargowi.Judgements
  alias Przetargowi.Judgements.TextExtractor
  alias Przetargowi.UZP.Scraper

  require Logger

  @delay_between_requests 100

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    mode = Map.get(args, "mode", "full")

    case mode do
      "list" -> sync_list_pages(args)
      "details" -> sync_details()
      "reextract" -> reextract_deliberations()
      "fix_meritum" -> fix_missing_meritum()
      "fix_document_type" -> fix_document_types()
      "detect_document_type" -> detect_document_types()
      "fix_resolution_method" -> fix_resolution_methods()
      "fix_procedure_type" -> fix_procedure_types()
      "full" -> sync_full()
    end
  end

  defp sync_full do
    with :ok <- sync_list_pages(%{}),
         :ok <- sync_details(),
         :ok <- fix_document_types(),
         :ok <- fix_resolution_methods(),
         :ok <- fix_procedure_types() do
      Logger.info("SyncWorker completed, enqueueing EmbeddingWorker")
      Oban.insert(EmbeddingWorker.new(%{}))
      :ok
    end
  end

  defp sync_list_pages(_args) do
    Logger.info("Starting UZP list sync")

    result =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while({:ok, 0, nil}, fn page, {:ok, count, prev_uzp_ids} ->
        Process.sleep(@delay_between_requests)

        case sync_page(page) do
          {:ok, 0, 0, _uzp_ids} ->
            Logger.info("No results on page #{page}, stopping")
            {:halt, {:ok, count}}

          {:ok, _total, 0, _uzp_ids} ->
            Logger.info("Page #{page}: all judgements already in DB, stopping")
            {:halt, {:ok, count}}

          {:ok, total, new_count, uzp_ids} ->
            if prev_uzp_ids != nil and MapSet.equal?(prev_uzp_ids, uzp_ids) do
              Logger.info("Page #{page} same as previous page, stopping")
              {:halt, {:ok, count}}
            else
              Logger.info("Synced page #{page}: #{new_count} new of #{total} judgements")
              {:cont, {:ok, count + new_count, uzp_ids}}
            end

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
        {:ok, 0, 0, MapSet.new()}

      {:ok, %{judgements: judgements}} ->
        uzp_ids = judgements |> Enum.map(& &1.uzp_id) |> MapSet.new()

        results =
          Enum.map(judgements, fn attrs ->
            # Check if judgement already exists
            exists = Judgements.exists_by_uzp_id?(attrs.uzp_id)

            case Judgements.upsert_from_list(attrs) do
              {:ok, _judgement} ->
                if exists, do: :existing, else: :new

              {:error, changeset} ->
                Logger.warning(
                  "Failed to upsert judgement #{attrs.uzp_id}: #{inspect(changeset.errors)}"
                )

                :error
            end
          end)

        new_count = Enum.count(results, &(&1 == :new))
        {:ok, length(judgements), new_count, uzp_ids}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp sync_details do
    Logger.info("Starting UZP details sync")

    # Process in batches of 100 until all are done
    sync_details_batch(1)
  end

  defp sync_details_batch(batch_num) do
    judgements = Judgements.judgements_needing_details(100)

    if length(judgements) == 0 do
      Logger.info("All judgements have details synced")
      :ok
    else
      IO.puts("\n[Batch #{batch_num}] Processing #{length(judgements)} judgements...")

      results =
        Enum.map(judgements, fn judgement ->
          result = sync_judgement_details(judgement)
          print_progress(if result == :ok, do: ".", else: "x")
          result
        end)

      IO.puts("")
      success_count = Enum.count(results, &(&1 == :ok))
      error_count = Enum.count(results, &(&1 != :ok))

      Logger.info("Batch completed: #{success_count} success, #{error_count} errors")

      if error_count > length(judgements) / 2 do
        {:error, "Too many errors during details sync"}
      else
        # Continue with next batch
        sync_details_batch(batch_num + 1)
      end
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
            Logger.error(
              "Failed to update details for #{judgement.uzp_id}: #{inspect(changeset)}"
            )

            {:error, changeset}
        end

      {:error, reason} ->
        Logger.warning("Failed to fetch details for #{judgement.uzp_id}: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp reextract_deliberations do
    Logger.info("Starting deliberation re-extraction")
    total = Judgements.count_judgements_needing_extraction()
    Logger.info("Found #{total} judgements needing extraction")

    reextract_batch(1, 0, 0)
  end

  defp reextract_batch(batch_num, total_success, total_errors) do
    judgements = Judgements.judgements_needing_extraction(100)

    if length(judgements) == 0 do
      Logger.info(
        "Re-extraction completed, total success: #{total_success}, total errors: #{total_errors}"
      )

      :ok
    else
      IO.puts("\n[Batch #{batch_num}] Processing #{length(judgements)} judgements...")

      results =
        Enum.map(judgements, fn judgement ->
          result = reextract_judgement_deliberation(judgement)
          print_progress(if result == :ok, do: ".", else: "x")
          result
        end)

      IO.puts("")
      success_count = Enum.count(results, &(&1 == :ok))
      error_count = Enum.count(results, &(&1 != :ok))

      Logger.info("Batch completed: #{success_count} success, #{error_count} errors")

      reextract_batch(batch_num + 1, total_success + success_count, total_errors + error_count)
    end
  end

  defp reextract_judgement_deliberation(%{id: id, content_html: content_html}) do
    deliberation = TextExtractor.extract_deliberation(content_html)
    meritum = TextExtractor.extract_deliberation_summary(deliberation)

    # Use empty string if extraction failed, to avoid infinite loop
    deliberation = deliberation || ""
    meritum = meritum || ""

    case Judgements.update_deliberation_by_id(id, %{
           deliberation: deliberation,
           meritum: meritum
         }) do
      {:ok, _} ->
        Logger.debug("Re-extracted deliberation for #{id}")
        :ok

      {:error, reason} ->
        Logger.warning("Failed to update deliberation for #{id}: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp fix_missing_meritum do
    Logger.info("Starting meritum fix")
    total = Judgements.count_judgements_needing_meritum()
    Logger.info("Found #{total} judgements needing meritum")

    fix_meritum_batch(1, 0)
  end

  defp fix_meritum_batch(batch_num, total_fixed) do
    judgements = Judgements.judgements_needing_meritum(100)

    if length(judgements) == 0 do
      Logger.info("Meritum fix completed, total fixed: #{total_fixed}")
      :ok
    else
      IO.puts("\n[Batch #{batch_num}] Processing #{length(judgements)} judgements...")

      results =
        Enum.map(judgements, fn %{id: id, deliberation: deliberation} ->
          meritum = TextExtractor.extract_deliberation_summary(deliberation)
          meritum = meritum || ""

          case Judgements.update_meritum_by_id(id, meritum) do
            {:ok, _} ->
              print_progress(".")
              :ok

            {:error, reason} ->
              print_progress("x")
              Logger.warning("Failed to update meritum for #{id}: #{inspect(reason)}")
              {:error, reason}
          end
        end)

      IO.puts("")
      success_count = Enum.count(results, &(&1 == :ok))
      Logger.info("Batch completed: #{success_count} fixed")

      fix_meritum_batch(batch_num + 1, total_fixed + success_count)
    end
  end

  defp fix_document_types do
    Logger.info("Starting document type fix")
    total = Judgements.count_judgements_needing_document_type_fix()
    Logger.info("Found #{total} judgements needing document type fix")

    fix_document_type_batch(1, 0)
  end

  defp fix_document_type_batch(batch_num, total_fixed) do
    judgements = Judgements.judgements_needing_document_type_fix(100)

    if length(judgements) == 0 do
      Logger.info("Document type fix completed, total fixed: #{total_fixed}")
      :ok
    else
      IO.puts("\n[Batch #{batch_num}] Processing #{length(judgements)} judgements...")

      results =
        Enum.map(judgements, fn %{
                                  id: id,
                                  document_type: document_type,
                                  content_html: content_html
                                } ->
          normalized = Judgements.normalize_document_type(document_type)
          # If still nil, try to detect from content
          normalized = normalized || Judgements.detect_document_type_from_content(content_html)

          case Judgements.update_document_type_by_id(id, normalized) do
            {:ok, _} ->
              print_progress(".")
              :ok

            {:error, reason} ->
              print_progress("x")
              Logger.warning("Failed to update document type for #{id}: #{inspect(reason)}")
              {:error, reason}
          end
        end)

      IO.puts("")
      success_count = Enum.count(results, &(&1 == :ok))
      Logger.info("Batch completed: #{success_count} fixed")

      fix_document_type_batch(batch_num + 1, total_fixed + success_count)
    end
  end

  defp detect_document_types do
    Logger.info("Starting document type detection from content")
    # Process all NULL documents in one pass (no looping)
    judgements = Judgements.judgements_with_null_document_type(1000)
    total = length(judgements)
    Logger.info("Found #{total} judgements with NULL document type")

    if total == 0 do
      Logger.info("No judgements need document type detection")
      :ok
    else
      IO.puts("\nProcessing #{total} judgements...")

      results =
        Enum.map(judgements, fn %{id: id, content_html: content_html} ->
          case Judgements.detect_document_type_from_content(content_html) do
            nil ->
              print_progress("-")
              :skipped

            detected_type ->
              case Judgements.update_document_type_by_id(id, detected_type) do
                {:ok, _} ->
                  print_progress(".")
                  :ok

                {:error, reason} ->
                  print_progress("x")
                  Logger.warning("Failed to update document type for #{id}: #{inspect(reason)}")
                  {:error, reason}
              end
          end
        end)

      IO.puts("")
      detected_count = Enum.count(results, &(&1 == :ok))
      skipped_count = Enum.count(results, &(&1 == :skipped))

      Logger.info(
        "Detection completed: #{detected_count} detected, #{skipped_count} could not be detected"
      )

      :ok
    end
  end

  defp fix_resolution_methods do
    Logger.info("Starting resolution method fix")
    total = Judgements.count_judgements_needing_resolution_method_fix()
    Logger.info("Found #{total} judgements needing resolution method fix")

    fix_resolution_method_batch(1, 0)
  end

  defp fix_resolution_method_batch(batch_num, total_fixed) do
    judgements = Judgements.judgements_needing_resolution_method_fix(100)

    if length(judgements) == 0 do
      Logger.info("Resolution method fix completed, total fixed: #{total_fixed}")
      :ok
    else
      IO.puts("\n[Batch #{batch_num}] Processing #{length(judgements)} judgements...")

      results =
        Enum.map(judgements, fn %{id: id, resolution_method: resolution_method} ->
          normalized = Judgements.normalize_resolution_method(resolution_method)

          case Judgements.update_resolution_method_by_id(id, normalized) do
            {:ok, _} ->
              print_progress(".")
              :ok

            {:error, reason} ->
              print_progress("x")
              Logger.warning("Failed to update resolution method for #{id}: #{inspect(reason)}")
              {:error, reason}
          end
        end)

      IO.puts("")
      success_count = Enum.count(results, &(&1 == :ok))
      Logger.info("Batch completed: #{success_count} fixed")

      fix_resolution_method_batch(batch_num + 1, total_fixed + success_count)
    end
  end

  defp fix_procedure_types do
    Logger.info("Starting procedure type fix")
    total = Judgements.count_judgements_needing_procedure_type_fix()
    Logger.info("Found #{total} judgements needing procedure type fix")

    fix_procedure_type_batch(1, 0)
  end

  defp fix_procedure_type_batch(batch_num, total_fixed) do
    judgements = Judgements.judgements_needing_procedure_type_fix(100)

    if length(judgements) == 0 do
      Logger.info("Procedure type fix completed, total fixed: #{total_fixed}")
      :ok
    else
      IO.puts("\n[Batch #{batch_num}] Processing #{length(judgements)} judgements...")

      results =
        Enum.map(judgements, fn %{id: id, procedure_type: procedure_type} ->
          normalized = Judgements.normalize_procedure_type(procedure_type)

          case Judgements.update_procedure_type_by_id(id, normalized) do
            {:ok, _} ->
              print_progress(".")
              :ok

            {:error, reason} ->
              print_progress("x")
              Logger.warning("Failed to update procedure type for #{id}: #{inspect(reason)}")
              {:error, reason}
          end
        end)

      IO.puts("")
      success_count = Enum.count(results, &(&1 == :ok))
      Logger.info("Batch completed: #{success_count} fixed")

      fix_procedure_type_batch(batch_num + 1, total_fixed + success_count)
    end
  end

  defp print_progress(char) do
    :io.format("~s", [char])
  end
end
