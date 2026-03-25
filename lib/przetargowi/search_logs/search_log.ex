defmodule Przetargowi.SearchLogs.SearchLog do
  use Ecto.Schema

  import Ecto.Changeset

  alias Przetargowi.Accounts.User

  schema "search_logs" do
    field :query, :string
    field :source, :string
    field :filters, :map, default: %{}

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def changeset(search_log \\ %__MODULE__{}, attrs) do
    search_log
    |> cast(attrs, [:query, :source, :filters, :user_id])
    |> validate_required([:source])
    |> validate_inclusion(:source, ~w(tenders reports kio))
  end
end
