defmodule Przetargowi.UZP.HTTPClient do
  @moduledoc """
  HTTP client for fetching UZP pages using Req.

  Note: Certificate verification is disabled because orzeczenia.uzp.gov.pl
  has a misconfigured SSL certificate with key_usage_mismatch error.
  """

  @behaviour Przetargowi.UZP.HTTPClientBehaviour

  @default_headers [
    {"user-agent", "Mozilla/5.0 (compatible; Przetargowi/1.0; +https://przetargowi.pl)"},
    {"accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"},
    {"accept-language", "pl,en;q=0.5"}
  ]

  @default_options [
    receive_timeout: 30_000,
    retry: :transient,
    max_retries: 3,
    # UZP government site has certificate with key_usage_mismatch, disable verification
    connect_options: [
      transport_opts: [
        verify: :verify_none
      ]
    ]
  ]

  @impl true
  def get(url) do
    Req.get(url, [headers: @default_headers] ++ @default_options)
  end

  @impl true
  def post(url, body) do
    headers = @default_headers ++ [{"content-type", "application/x-www-form-urlencoded"}]
    Req.post(url, [headers: headers, body: body] ++ @default_options)
  end
end
