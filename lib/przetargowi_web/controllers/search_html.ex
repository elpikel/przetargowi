defmodule PrzetargowiWeb.SearchHTML do
  @moduledoc """
  This module contains pages rendered by SearchController.

  See the `search_html` directory for all templates available.
  """
  use PrzetargowiWeb, :html

  embed_templates "search_html/*"

  def pagination_params(query, page) do
    params = if query != "", do: [q: query, page: page], else: [page: page]
    URI.encode_query(params)
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
