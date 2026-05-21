defmodule Przetargowi.Workers.ComputeWinnerAnalyses do
  @moduledoc """
  Oban worker that precomputes winner analyses for all CPV + order type + province combinations.
  Computes both regional (per province) and national (all provinces) analyses.
  Runs daily after tender results are fetched, so the data is fresh for page loads.
  """
  use Oban.Worker,
    queue: :default,
    max_attempts: 3

  alias Przetargowi.Tenders

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    combos = Tenders.list_cpv_order_type_combos()

    Logger.info(
      "Computing winner analyses for #{length(combos)} CPV+order_type+province combinations..."
    )

    # Compute per-province analyses
    regional_results =
      Enum.map(combos, fn {cpv_main, order_type, province} ->
        compute(cpv_main, order_type, province)
      end)

    # Compute national analyses (distinct cpv_main + order_type, province = nil)
    national_combos =
      combos
      |> Enum.map(fn {cpv_main, order_type, _province} -> {cpv_main, order_type} end)
      |> Enum.uniq()

    national_results =
      Enum.map(national_combos, fn {cpv_main, order_type} ->
        compute(cpv_main, order_type, nil)
      end)

    all_results = regional_results ++ national_results
    computed = Enum.count(all_results, &(&1 == :ok))
    skipped = Enum.count(all_results, &(&1 == :skip))
    failed = Enum.count(all_results, &(&1 == :error))

    Logger.info(
      "Winner analyses complete: #{computed} computed, #{skipped} skipped, #{failed} failed " <>
        "(#{length(regional_results)} regional + #{length(national_results)} national)"
    )

    :ok
  end

  defp compute(cpv_main, order_type, province) do
    case Tenders.compute_and_store_winner_analysis(cpv_main, order_type, province) do
      {:ok, _} -> :ok
      :skip -> :skip
      {:error, reason} ->
        Logger.warning(
          "Failed to compute winner analysis for #{cpv_main}/#{order_type}/#{province || "national"}: #{inspect(reason)}"
        )

        :error
    end
  end
end
