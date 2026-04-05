defmodule Przetargowi.Embeddings.EmbeddingCacheTest do
  use ExUnit.Case, async: false

  alias Przetargowi.Embeddings.EmbeddingCache

  setup do
    # Clear cache before each test
    EmbeddingCache.clear()
    :ok
  end

  describe "get/1 and put/2" do
    test "returns :miss for uncached query" do
      assert EmbeddingCache.get("uncached query") == :miss
    end

    test "stores and retrieves embedding" do
      query = "test query"
      embedding = [0.1, 0.2, 0.3]

      assert EmbeddingCache.put(query, embedding) == :ok
      assert EmbeddingCache.get(query) == {:ok, embedding}
    end

    test "different queries have different cache entries" do
      query1 = "first query"
      query2 = "second query"
      embedding1 = [0.1, 0.2]
      embedding2 = [0.3, 0.4]

      EmbeddingCache.put(query1, embedding1)
      EmbeddingCache.put(query2, embedding2)

      assert EmbeddingCache.get(query1) == {:ok, embedding1}
      assert EmbeddingCache.get(query2) == {:ok, embedding2}
    end
  end

  describe "TTL behavior" do
    test "expired entries return :miss" do
      query = "expiring query"
      embedding = [0.1, 0.2, 0.3]

      # Use 0 second TTL for immediate expiration
      EmbeddingCache.put(query, embedding, 0)

      # Should be expired immediately
      Process.sleep(10)
      assert EmbeddingCache.get(query) == :miss
    end
  end

  describe "clear/0" do
    test "removes all cached entries" do
      EmbeddingCache.put("query1", [0.1])
      EmbeddingCache.put("query2", [0.2])

      assert {:ok, _} = EmbeddingCache.get("query1")
      assert {:ok, _} = EmbeddingCache.get("query2")

      EmbeddingCache.clear()

      assert EmbeddingCache.get("query1") == :miss
      assert EmbeddingCache.get("query2") == :miss
    end
  end
end
