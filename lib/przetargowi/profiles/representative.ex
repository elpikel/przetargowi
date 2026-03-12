defmodule Przetargowi.Profiles.Representative do
  @moduledoc """
  Embedded schema for company representatives.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :full_name, :string
    field :position, :string
    field :is_primary, :boolean, default: false
  end

  def changeset(representative, attrs) do
    representative
    |> cast(attrs, [:full_name, :position, :is_primary])
    |> validate_required([:full_name, :position])
  end
end
