defmodule Przetargowi.Repo.Migrations.CreateJudgements do
  use Ecto.Migration

  def change do
    create table(:judgements) do
      # External ID from UZP website
      add :uzp_id, :string, null: false

      # Basic info from list page
      add :signature, :string, null: false
      add :issuing_authority, :string
      add :document_type, :string
      add :decision_date, :date

      # Details from detail page
      add :chairman, :string
      add :contracting_authority, :text
      add :location, :string
      add :resolution_method, :string
      add :procedure_type, :string
      add :order_type, :string

      # Arrays stored as JSONB
      add :key_provisions, {:array, :string}, default: []
      add :thematic_issues, {:array, :string}, default: []

      # Full document content
      add :content_html, :text
      add :pdf_url, :string

      # Sync metadata
      add :synced_at, :utc_datetime
      add :details_synced_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:judgements, [:uzp_id])
    create index(:judgements, [:signature])
    create index(:judgements, [:decision_date])
    create index(:judgements, [:issuing_authority])
    create index(:judgements, [:document_type])
  end
end
