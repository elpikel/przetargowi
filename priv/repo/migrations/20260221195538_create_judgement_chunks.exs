defmodule Przetargowi.Repo.Migrations.CreateJudgementChunks do
  use Ecto.Migration

  def up do
    # Enable pgvector extension
    execute "CREATE EXTENSION IF NOT EXISTS vector"

    create table(:judgement_chunks) do
      add :judgement_id, references(:judgements, on_delete: :delete_all), null: false
      add :chunk_index, :integer, null: false
      add :content, :text, null: false
      add :word_count, :integer, null: false
      add :embedding, :vector, size: 1536

      timestamps(type: :utc_datetime)
    end

    create index(:judgement_chunks, [:judgement_id])
    create unique_index(:judgement_chunks, [:judgement_id, :chunk_index])

    # Create index for similarity search (using cosine distance)
    # Using ivfflat for faster approximate search on large datasets
    execute """
    CREATE INDEX judgement_chunks_embedding_idx
    ON judgement_chunks
    USING ivfflat (embedding vector_cosine_ops)
    WITH (lists = 100)
    """
  end

  def down do
    drop table(:judgement_chunks)
    execute "DROP EXTENSION IF EXISTS vector"
  end
end
