defmodule PrzetargowiWeb.AnalyticsController do
  use PrzetargowiWeb, :controller

  @plausible_host "plausible.przetargowyprzeglad.pl"
  @script_url "https://#{@plausible_host}/js/script.js"
  @cache_ttl :timer.hours(1)

  def script(conn, _params) do
    case get_cached_script() do
      {:ok, script} ->
        conn
        |> put_resp_content_type("application/javascript")
        |> put_resp_header("cache-control", "public, max-age=3600")
        |> send_resp(200, script)

      {:error, _reason} ->
        send_resp(conn, 502, "")
    end
  end

  def event(conn, _params) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    headers = [
      {"user-agent", get_req_header(conn, "user-agent") |> List.first() || ""},
      {"x-forwarded-for", get_client_ip(conn)},
      {"content-type", "application/json"}
    ]

    case Req.post("https://#{@plausible_host}/api/event", body: body, headers: headers) do
      {:ok, %{status: status, body: resp_body}} ->
        send_resp(conn, status, resp_body || "")

      {:error, _reason} ->
        send_resp(conn, 502, "")
    end
  end

  defp get_cached_script do
    case :persistent_term.get({__MODULE__, :script}, nil) do
      {script, cached_at} when is_binary(script) ->
        if System.monotonic_time(:millisecond) - cached_at < @cache_ttl do
          {:ok, script}
        else
          fetch_and_cache_script()
        end

      _ ->
        fetch_and_cache_script()
    end
  end

  defp fetch_and_cache_script do
    case Req.get(@script_url) do
      {:ok, %{status: 200, body: script}} when is_binary(script) ->
        # Modify script to use our proxy endpoint
        modified_script = String.replace(script, @plausible_host, "przetargowi.pl")

        :persistent_term.put(
          {__MODULE__, :script},
          {modified_script, System.monotonic_time(:millisecond)}
        )

        {:ok, modified_script}

      {:ok, %{status: status}} ->
        {:error, {:http_error, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_client_ip(conn) do
    conn
    |> get_req_header("x-forwarded-for")
    |> List.first()
    |> case do
      nil -> conn.remote_ip |> :inet.ntoa() |> to_string()
      forwarded -> forwarded |> String.split(",") |> List.first() |> String.trim()
    end
  end
end
