defmodule PrzetargowiWeb.SearchHTML do
  @moduledoc """
  This module contains pages rendered by SearchController.

  See the `search_html` directory for all templates available.
  """
  use PrzetargowiWeb, :html

  embed_templates "search_html/*"

  def pagination_params(query, filters, page) do
    params =
      [page: page]
      |> add_if_present(:q, query)
      |> add_if_present(:document_type, filters[:document_type])
      |> add_if_present(:issuing_authority, filters[:issuing_authority])
      |> add_if_present(:resolution_method, filters[:resolution_method])
      |> add_if_present(:procedure_type, filters[:procedure_type])
      |> add_if_present(:date_from, filters[:date_from])
      |> add_if_present(:date_to, filters[:date_to])

    URI.encode_query(params)
  end

  defp add_if_present(params, _key, nil), do: params
  defp add_if_present(params, _key, ""), do: params
  defp add_if_present(params, key, value), do: [{key, value} | params]

  def has_active_filters?(filters) do
    Enum.any?(filters, fn {_key, value} -> value != "" and not is_nil(value) end)
  end

  def pagination_range(_current, total) when total <= 7 do
    Enum.to_list(1..total)
  end

  def pagination_range(current, total) do
    cond do
      current <= 3 ->
        [1, 2, 3, 4, :ellipsis, total]

      current >= total - 2 ->
        [1, :ellipsis, total - 3, total - 2, total - 1, total]

      true ->
        [1, :ellipsis, current - 1, current, current + 1, :ellipsis, total]
    end
  end
end
