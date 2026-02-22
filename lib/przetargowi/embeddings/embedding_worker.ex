defmodule Przetargowi.Embeddings.EmbeddingWorker do
  @moduledoc """
  Oban worker for generating text chunks and embeddings.
  """

  use Oban.Worker,
    queue: :embeddings,
    max_attempts: 3,
    unique: [period: :infinity, states: [:available, :scheduled, :executing]]

  alias Przetargowi.Embeddings

  require Logger

  # Delay between API calls to respect rate limits
  @delay_between_batches 1_000
  # Number of chunks to embed in a single API call
  @embedding_batch_size 20
  # Number of judgements to process per chunking batch
  @chunking_batch_size 100

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    mode = Map.get(args, "mode", "full")

    case mode do
      "chunk" -> chunk_all()
      "embed" -> embed_all()
      "full" -> full_process()
    end
  end

  defp full_process do
    with :ok <- chunk_all(),
         :ok <- embed_all() do
      :ok
    end
  end

  defp chunk_all do
    Logger.info("Starting chunking process")
    chunk_batch()
  end

  defp chunk_batch do
    judgements = Embeddings.judgements_needing_chunks(@chunking_batch_size)

    if length(judgements) == 0 do
      Logger.info("All judgements have been chunked")
      :ok
    else
      Logger.info("Chunking batch of #{length(judgements)} judgements")

      results =
        Enum.map(judgements, fn judgement ->
          case Embeddings.create_chunks_for_judgement(judgement) do
            {:ok, chunks} ->
              Logger.debug("Created #{length(chunks)} chunks for judgement #{judgement.id}")
              :ok

            {:error, reason} ->
              Logger.warning("Failed to chunk judgement #{judgement.id}: #{inspect(reason)}")
              :error
          end
        end)

      success_count = Enum.count(results, &(&1 == :ok))
      error_count = Enum.count(results, &(&1 == :error))

      Logger.info("Chunking batch completed: #{success_count} success, #{error_count} errors")

      if error_count > length(judgements) / 2 do
        {:error, "Too many chunking errors"}
      else
        # Continue with next batch
        chunk_batch()
      end
    end
  end

  defp embed_all do
    Logger.info("Starting embedding process")
    embed_batch()
  end

  defp embed_batch do
    chunks = Embeddings.chunks_needing_embeddings(@embedding_batch_size)

    if length(chunks) == 0 do
      Logger.info("All chunks have embeddings")
      :ok
    else
      Logger.info("Embedding batch of #{length(chunks)} chunks")

      Process.sleep(@delay_between_batches)

      case Embeddings.generate_embeddings_batch(chunks) do
        {:ok, results} ->
          success_count = Enum.count(results, &match?({:ok, _}, &1))
          error_count = length(results) - success_count

          Logger.info("Embedding batch completed: #{success_count} success, #{error_count} errors")

          if error_count > length(chunks) / 2 do
            {:error, "Too many embedding errors"}
          else
            # Continue with next batch
            embed_batch()
          end

        {:error, reason} ->
          Logger.error("Embedding batch failed: #{inspect(reason)}")
          {:error, reason}
      end
    end
  end
end
