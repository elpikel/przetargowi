defmodule Przetargowi.Tenders.TenderDocument do
  @moduledoc """
  Schema for tender documents from e-Zamówienia platform.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:object_id, :string, autogenerate: false}
  schema "tender_documents" do
    field :tender_id, :string
    field :name, :string
    field :file_name, :string
    field :url, :string
    field :state, :string
    field :create_date, :utc_datetime
    field :published_date, :utc_datetime
    field :delete_date, :utc_datetime
    field :delete_reason, :string
    field :content, :binary
    field :downloaded_at, :utc_datetime
    field :download_error, :string

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [
      :object_id,
      :tender_id,
      :name,
      :file_name,
      :url,
      :state,
      :create_date,
      :published_date,
      :delete_date,
      :delete_reason
    ])
    |> validate_required([:object_id, :tender_id, :name, :file_name, :url])
  end

  @doc """
  Changeset for updating document download status.
  """
  def download_changeset(document, attrs) do
    document
    |> cast(attrs, [:content, :downloaded_at, :download_error])
  end
end
