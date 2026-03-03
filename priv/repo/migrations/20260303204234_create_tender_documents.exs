defmodule Przetargowi.Repo.Migrations.CreateTenderDocuments do
  use Ecto.Migration

  def change do
    create table(:tender_documents, primary_key: false) do
      add :object_id, :string, primary_key: true
      add :tender_id, :string, null: false
      add :name, :text, null: false
      add :file_name, :text, null: false
      add :url, :text, null: false
      add :state, :string
      add :create_date, :utc_datetime
      add :published_date, :utc_datetime
      add :delete_date, :utc_datetime
      add :delete_reason, :text

      timestamps()
    end

    create index(:tender_documents, [:tender_id])
    create index(:tender_documents, [:state])
  end
end
