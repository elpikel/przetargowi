defmodule Przetargowi.Embeddings.Chunk do
  @moduledoc """
  Schema for judgement text chunks with embeddings.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Przetargowi.Judgements.Judgement

  schema "judgement_chunks" do
    field :chunk_index, :integer
    field :content, :string
    field :word_count, :integer
    field :embedding, Pgvector.Ecto.Vector

    belongs_to :judgement, Judgement

    timestamps(type: :utc_datetime)
  end

  @doc """
  Changeset for creating a new chunk.
  """
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:judgement_id, :chunk_index, :content, :word_count])
    |> validate_required([:judgement_id, :chunk_index, :content, :word_count])
    |> foreign_key_constraint(:judgement_id)
    |> unique_constraint([:judgement_id, :chunk_index])
  end

  @doc """
  Changeset for updating embedding.
  """
  def embedding_changeset(chunk, embedding) do
    chunk
    |> cast(%{embedding: embedding}, [:embedding])
  end
end
