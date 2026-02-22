defmodule Przetargowi.Embeddings do
  @moduledoc """
  Context for managing text embeddings and semantic search.
  """

  import Ecto.Query
  alias Przetargowi.Repo
  alias Przetargowi.Embeddings.{Chunk, TextChunker, OpenAIClient}
  alias Przetargowi.Judgements.Judgement

  @doc """
  Creates chunks for a judgement's deliberation text.
  Deletes existing chunks first, then creates new ones.
  """
  def create_chunks_for_judgement(%Judgement{} = judgement) do
    # Delete existing chunks
    delete_chunks_for_judgement(judgement.id)

    # Create new chunks
    case judgement.deliberation do
      nil ->
        {:ok, []}

      "" ->
        {:ok, []}

      deliberation ->
        chunks_data = TextChunker.chunk_text(deliberation)

        try do
          chunks =
            chunks_data
            |> Enum.with_index()
            |> Enum.map(fn {{content, word_count}, index} ->
              %Chunk{}
              |> Chunk.changeset(%{
                judgement_id: judgement.id,
                chunk_index: index,
                content: content,
                word_count: word_count
              })
              |> Repo.insert!()
            end)

          {:ok, chunks}
        rescue
          e -> {:error, e}
        end
    end
  end

  @doc """
  Deletes all chunks for a judgement.
  """
  def delete_chunks_for_judgement(judgement_id) do
    Chunk
    |> where([c], c.judgement_id == ^judgement_id)
    |> Repo.delete_all()
  end

  @doc """
  Generates and saves embedding for a chunk.
  """
  def generate_and_save_embedding(%Chunk{} = chunk) do
    case OpenAIClient.get_embedding(chunk.content) do
      {:ok, embedding} ->
        chunk
        |> Chunk.embedding_changeset(embedding)
        |> Repo.update()

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Generates embeddings for multiple chunks in a batch.
  More efficient than individual calls.
  """
  def generate_embeddings_batch(chunks) when is_list(chunks) do
    texts = Enum.map(chunks, & &1.content)

    case OpenAIClient.get_embeddings_batch(texts) do
      {:ok, embeddings} ->
        results =
          Enum.zip(chunks, embeddings)
          |> Enum.map(fn {chunk, embedding} ->
            chunk
            |> Chunk.embedding_changeset(embedding)
            |> Repo.update()
          end)

        {:ok, results}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Returns chunks that don't have embeddings yet.
  """
  def chunks_needing_embeddings(limit \\ 100) do
    Chunk
    |> where([c], is_nil(c.embedding))
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns judgements with deliberation that don't have chunks yet.
  """
  def judgements_needing_chunks(limit \\ 100) do
    # Subquery to get judgement IDs that have chunks
    chunks_subquery =
      Chunk
      |> select([c], c.judgement_id)
      |> distinct(true)

    Judgement
    |> where([j], not is_nil(j.deliberation) and j.deliberation != "")
    |> where([j], j.id not in subquery(chunks_subquery))
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Searches for chunks similar to the query text.
  Returns chunks with their judgements, ordered by similarity.
  """
  def search_similar(query_text, limit \\ 10) do
    case OpenAIClient.get_embedding(query_text) do
      {:ok, query_embedding} ->
        search_by_embedding(query_embedding, limit)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Searches for chunks similar to the given embedding vector.
  """
  def search_by_embedding(embedding, limit \\ 10) do
    embedding_vector = Pgvector.new(embedding)

    chunks =
      Chunk
      |> where([c], not is_nil(c.embedding))
      |> order_by([c], fragment("embedding <=> ?", ^embedding_vector))
      |> limit(^limit)
      |> preload(:judgement)
      |> Repo.all()

    {:ok, chunks}
  end

  @doc """
  Returns statistics about chunks and embeddings.
  """
  def stats do
    total_chunks = Repo.aggregate(Chunk, :count, :id)

    chunks_with_embeddings =
      Chunk
      |> where([c], not is_nil(c.embedding))
      |> Repo.aggregate(:count, :id)

    judgements_with_deliberation =
      Judgement
      |> where([j], not is_nil(j.deliberation) and j.deliberation != "")
      |> Repo.aggregate(:count, :id)

    judgements_with_chunks =
      Chunk
      |> select([c], c.judgement_id)
      |> distinct(true)
      |> Repo.aggregate(:count)

    %{
      total_chunks: total_chunks,
      chunks_with_embeddings: chunks_with_embeddings,
      chunks_without_embeddings: total_chunks - chunks_with_embeddings,
      judgements_with_deliberation: judgements_with_deliberation,
      judgements_with_chunks: judgements_with_chunks,
      judgements_needing_chunks: judgements_with_deliberation - judgements_with_chunks
    }
  end
end
