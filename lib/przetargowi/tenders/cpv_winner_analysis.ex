defmodule Przetargowi.Tenders.CpvWinnerAnalysis do
  @moduledoc """
  Stores precomputed winner analysis for a given CPV main code + order type + province combination.
  Data is recomputed periodically by the ComputeWinnerAnalyses worker.
  Province is "" for national (all-province) analyses.
  """
  use Ecto.Schema

  import Ecto.Changeset

  schema "cpv_winner_analyses" do
    field :cpv_main, :string
    field :order_type, :string
    field :province, :string, default: ""
    field :data, :map, default: %{}
    field :computed_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(analysis, attrs) do
    analysis
    |> cast(attrs, [:cpv_main, :order_type, :province, :data, :computed_at])
    |> validate_required([:cpv_main, :order_type, :data, :computed_at])
    |> unique_constraint([:cpv_main, :order_type, :province])
  end
end
