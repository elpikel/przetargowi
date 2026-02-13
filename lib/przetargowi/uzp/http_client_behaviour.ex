defmodule Przetargowi.UZP.HTTPClientBehaviour do
  @moduledoc """
  Behaviour for HTTP client used by UZP scraper.
  Allows for easy mocking in tests.
  """

  @callback get(url :: String.t()) :: {:ok, Req.Response.t()} | {:error, term()}
  @callback post(url :: String.t(), body :: String.t()) :: {:ok, Req.Response.t()} | {:error, term()}
end
