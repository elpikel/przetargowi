defmodule Przetargowi.SearchLogs do
  @moduledoc """
  Context module for logging search queries.
  """

  alias Przetargowi.Repo
  alias Przetargowi.SearchLogs.SearchLog

  @doc """
  Logs a search query asynchronously to avoid slowing down the request.
  """
  def log_search(attrs) do
    Task.start(fn ->
      %SearchLog{}
      |> SearchLog.changeset(attrs)
      |> Repo.insert()
    end)

    :ok
  end

  @doc """
  Extracts user_id from conn if available.
  """
  def get_user_id(conn) do
    case conn.assigns[:current_scope] do
      %{user: %{id: user_id}} -> user_id
      _ -> nil
    end
  end
end
