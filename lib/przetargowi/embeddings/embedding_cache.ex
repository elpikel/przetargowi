defmodule Przetargowi.Embeddings.EmbeddingCache do
  @moduledoc """
  Simple ETS-based cache for query embeddings with TTL.
  Caches OpenAI embedding responses to avoid redundant API calls.
  """
  use GenServer

  @table_name :embedding_cache
  @default_ttl_seconds 3600  # 1 hour

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Gets a cached embedding for the given query text.
  Returns {:ok, embedding} if found and not expired, :miss otherwise.
  """
  def get(query_text) do
    key = hash_key(query_text)

    case :ets.lookup(@table_name, key) do
      [{^key, embedding, expires_at}] ->
        if System.monotonic_time(:second) < expires_at do
          {:ok, embedding}
        else
          # Expired - delete and return miss
          :ets.delete(@table_name, key)
          :miss
        end

      [] ->
        :miss
    end
  end

  @doc """
  Stores an embedding in the cache with optional TTL in seconds.
  """
  def put(query_text, embedding, ttl_seconds \\ @default_ttl_seconds) do
    key = hash_key(query_text)
    expires_at = System.monotonic_time(:second) + ttl_seconds
    :ets.insert(@table_name, {key, embedding, expires_at})
    :ok
  end

  @doc """
  Clears all cached embeddings.
  """
  def clear do
    :ets.delete_all_objects(@table_name)
    :ok
  end

  # Server callbacks

  @impl true
  def init(_opts) do
    table = :ets.new(@table_name, [:named_table, :public, :set, read_concurrency: true])
    # Schedule periodic cleanup of expired entries
    schedule_cleanup()
    {:ok, %{table: table}}
  end

  @impl true
  def handle_info(:cleanup, state) do
    cleanup_expired()
    schedule_cleanup()
    {:noreply, state}
  end

  defp schedule_cleanup do
    # Run cleanup every 10 minutes
    Process.send_after(self(), :cleanup, 10 * 60 * 1000)
  end

  defp cleanup_expired do
    now = System.monotonic_time(:second)

    :ets.foldl(
      fn {key, _embedding, expires_at}, acc ->
        if expires_at < now do
          :ets.delete(@table_name, key)
        end

        acc
      end,
      :ok,
      @table_name
    )
  end

  defp hash_key(query_text) do
    :crypto.hash(:sha256, query_text)
  end
end
