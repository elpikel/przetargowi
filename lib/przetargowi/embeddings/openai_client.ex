defmodule Przetargowi.Embeddings.OpenAIClient do
  @moduledoc """
  HTTP client for OpenAI embeddings API.
  """

  require Logger

  @embeddings_url "https://api.openai.com/v1/embeddings"
  @default_model "text-embedding-3-small"

  @doc """
  Generates an embedding for the given text.
  Returns {:ok, embedding} or {:error, reason}.
  """
  def get_embedding(text, opts \\ []) do
    model = Keyword.get(opts, :model, @default_model)
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :missing_api_key}
    else
      request_embedding(text, model, api_key)
    end
  end

  @doc """
  Generates embeddings for multiple texts in a batch.
  Returns {:ok, [embeddings]} or {:error, reason}.
  """
  def get_embeddings_batch(texts, opts \\ []) when is_list(texts) do
    model = Keyword.get(opts, :model, @default_model)
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :missing_api_key}
    else
      request_embeddings_batch(texts, model, api_key)
    end
  end

  defp request_embedding(text, model, api_key) do
    body = Jason.encode!(%{
      model: model,
      input: text
    })

    case Req.post(@embeddings_url, body: body, headers: headers(api_key)) do
      {:ok, %{status: 200, body: %{"data" => [%{"embedding" => embedding} | _]}}} ->
        {:ok, embedding}

      {:ok, %{status: status, body: body}} ->
        Logger.error("OpenAI API error: status=#{status}, body=#{inspect(body)}")
        {:error, {:api_error, status, body}}

      {:error, reason} ->
        Logger.error("OpenAI request failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp request_embeddings_batch(texts, model, api_key) do
    body = Jason.encode!(%{
      model: model,
      input: texts
    })

    case Req.post(@embeddings_url, body: body, headers: headers(api_key)) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        # Sort by index to ensure order matches input
        embeddings =
          data
          |> Enum.sort_by(& &1["index"])
          |> Enum.map(& &1["embedding"])

        {:ok, embeddings}

      {:ok, %{status: status, body: body}} ->
        Logger.error("OpenAI API error: status=#{status}, body=#{inspect(body)}")
        {:error, {:api_error, status, body}}

      {:error, reason} ->
        Logger.error("OpenAI request failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp headers(api_key) do
    [
      {"Authorization", "Bearer #{api_key}"},
      {"Content-Type", "application/json"}
    ]
  end

  defp get_api_key do
    Application.get_env(:przetargowi, :openai_api_key) ||
      System.get_env("OPENAI_API_KEY")
  end
end
