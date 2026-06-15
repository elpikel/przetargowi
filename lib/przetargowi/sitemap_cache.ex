defmodule Przetargowi.SitemapCache do
  @moduledoc """
  ETS-based cache for generated sitemap XML responses.
  Prevents slow DB queries (especially with large OFFSET) from timing out
  when Google fetches sitemap pages.
  """
  use GenServer

  @table_name :sitemap_cache
  # 1 hour
  @default_ttl_seconds 3600

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Gets cached sitemap XML for the given key.
  Returns {:ok, xml} if found and not expired, :miss otherwise.
  """
  def get(key) do
    case :ets.lookup(@table_name, key) do
      [{^key, xml, expires_at}] ->
        if System.monotonic_time(:second) < expires_at do
          {:ok, xml}
        else
          :ets.delete(@table_name, key)
          :miss
        end

      [] ->
        :miss
    end
  end

  @doc """
  Stores sitemap XML in the cache with optional TTL in seconds.
  """
  def put(key, xml, ttl_seconds \\ @default_ttl_seconds) do
    expires_at = System.monotonic_time(:second) + ttl_seconds
    :ets.insert(@table_name, {key, xml, expires_at})
    :ok
  end

  # Server callbacks

  @impl true
  def init(_opts) do
    table = :ets.new(@table_name, [:named_table, :public, :set, read_concurrency: true])
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
    # Run cleanup every 30 minutes
    Process.send_after(self(), :cleanup, 30 * 60 * 1000)
  end

  defp cleanup_expired do
    now = System.monotonic_time(:second)

    :ets.foldl(
      fn {key, _xml, expires_at}, acc ->
        if expires_at < now, do: :ets.delete(@table_name, key)
        acc
      end,
      :ok,
      @table_name
    )
  end
end
