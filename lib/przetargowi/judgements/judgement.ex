defmodule Przetargowi.Judgements.Judgement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "judgements" do
    # External ID from UZP website
    field :uzp_id, :string

    # Basic info from list page
    field :signature, :string
    field :issuing_authority, :string
    field :document_type, :string
    field :decision_date, :date

    # Details from detail page
    field :chairman, :string
    field :contracting_authority, :string
    field :location, :string
    field :resolution_method, :string
    field :procedure_type, :string

    # Arrays
    field :key_provisions, {:array, :string}, default: []
    field :thematic_issues, {:array, :string}, default: []

    # Full document content
    field :content_html, :string
    field :pdf_url, :string

    # Sync metadata
    field :synced_at, :utc_datetime
    field :details_synced_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @required_fields ~w(uzp_id signature)a
  @optional_fields ~w(
    issuing_authority document_type decision_date chairman
    contracting_authority location resolution_method procedure_type
    key_provisions thematic_issues content_html pdf_url
    synced_at details_synced_at
  )a

  def changeset(judgement, attrs) do
    judgement
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:uzp_id)
  end

  def list_changeset(judgement, attrs) do
    judgement
    |> cast(attrs, [:uzp_id, :signature, :issuing_authority, :document_type, :decision_date, :synced_at])
    |> validate_required([:uzp_id, :signature])
    |> unique_constraint(:uzp_id)
  end

  def details_changeset(judgement, attrs) do
    judgement
    |> cast(attrs, [
      :chairman, :contracting_authority, :location, :resolution_method,
      :procedure_type, :key_provisions, :thematic_issues,
      :content_html, :pdf_url, :details_synced_at
    ])
  end
end
