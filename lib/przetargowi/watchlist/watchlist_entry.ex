defmodule Przetargowi.Watchlist.WatchlistEntry do
  @moduledoc """
  Schema for user watchlist entries - tenders saved for tracking deadlines.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Przetargowi.Accounts.User
  alias Przetargowi.Tenders.TenderNotice

  schema "watchlist_entries" do
    field :tender_object_id, :string
    field :notes, :string
    field :reminder_7_day_sent, :boolean, default: false
    field :reminder_1_day_sent, :boolean, default: false

    belongs_to :user, User
    belongs_to :tender_notice, TenderNotice, references: :object_id, foreign_key: :tender_object_id, define_field: false

    timestamps(type: :utc_datetime)
  end

  @doc """
  Changeset for creating a watchlist entry.
  """
  def create_changeset(entry \\ %__MODULE__{}, attrs) do
    entry
    |> cast(attrs, [:user_id, :tender_object_id, :notes])
    |> validate_required([:user_id, :tender_object_id])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:user_id, :tender_object_id],
      message: "już obserwujesz ten przetarg"
    )
  end

  @doc """
  Changeset for updating notes on a watchlist entry.
  """
  def update_changeset(entry, attrs) do
    entry
    |> cast(attrs, [:notes])
  end

  @doc """
  Changeset for marking reminders as sent.
  """
  def reminder_changeset(entry, attrs) do
    entry
    |> cast(attrs, [:reminder_7_day_sent, :reminder_1_day_sent])
  end
end
