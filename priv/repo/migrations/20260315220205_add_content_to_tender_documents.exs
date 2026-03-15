defmodule Przetargowi.Repo.Migrations.AddContentToTenderDocuments do
  use Ecto.Migration

  def change do
    alter table(:tender_documents) do
      add :content, :binary
      add :downloaded_at, :utc_datetime
      add :download_error, :string
    end

    create index(:tender_documents, [:downloaded_at])
  end
end
