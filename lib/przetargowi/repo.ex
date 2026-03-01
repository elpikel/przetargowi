defmodule Przetargowi.Repo do
  use Ecto.Repo,
    otp_app: :przetargowi,
    adapter: Ecto.Adapters.Postgres

  @impl true
  def init(_context, config) do
    {:ok, Keyword.put(config, :types, Przetargowi.PostgrexTypes)}
  end
end
