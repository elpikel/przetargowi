defmodule Przetargowi.Repo do
  use Ecto.Repo,
    otp_app: :przetargowi,
    adapter: Ecto.Adapters.Postgres
end
