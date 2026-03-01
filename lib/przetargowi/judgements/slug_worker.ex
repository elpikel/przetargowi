defmodule Przetargowi.Judgements.SlugWorker do
  @moduledoc """
  Oban worker for regenerating judgement slugs in batches.
  """

  use Oban.Worker,
    queue: :default,
    max_attempts: 3,
    unique: [period: :infinity, states: [:available, :scheduled, :executing]]

  alias Przetargowi.Judgements
  alias Przetargowi.Judgements.Judgement

  require Logger

  @batch_size 500

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    Logger.info("Starting slug regeneration")
    regenerate_batch(1, 0)
  end

  defp regenerate_batch(batch_num, total_updated) do
    judgements = Judgements.judgements_needing_slug_regeneration(@batch_size)

    if length(judgements) == 0 do
      Logger.info("Slug regeneration completed, total updated: #{total_updated}")
      :ok
    else
      Logger.info("[Batch #{batch_num}] Processing #{length(judgements)} judgements")

      results =
        Enum.map(judgements, fn %{id: id, signature: signature} ->
          slug = Judgement.generate_slug(signature)

          case Judgements.update_slug_by_id(id, slug) do
            {:ok, _} -> :ok
            {:error, :duplicate} -> handle_duplicate(id, slug)
            {:error, reason} ->
              Logger.warning("Failed to update slug for #{id}: #{inspect(reason)}")
              :error
          end
        end)

      success_count = Enum.count(results, &(&1 == :ok))
      Logger.info("Batch completed: #{success_count} updated")

      regenerate_batch(batch_num + 1, total_updated + success_count)
    end
  end

  defp handle_duplicate(id, base_slug) do
    slug_with_id = "#{base_slug}-#{id}"

    case Judgements.update_slug_by_id(id, slug_with_id) do
      {:ok, _} -> :ok
      {:error, reason} ->
        Logger.warning("Failed to update duplicate slug for #{id}: #{inspect(reason)}")
        :error
    end
  end
end
