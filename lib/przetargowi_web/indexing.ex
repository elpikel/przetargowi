defmodule PrzetargowiWeb.Indexing do
  @moduledoc """
  Which kinds of pages search engines are asked to index.

  The site's indexable surface is deliberately small: landing pages, hubs,
  the blog and static pages. Detail pages — single rulings and single monthly
  reports — are mostly copies or generated summaries of public data, and in
  bulk they dilute how the domain is judged. They stay on the site for
  visitors and are linked from the hubs, but carry `noindex, follow` and are
  left out of the sitemap. (Single tender pages have always been noindex.)

  To let a kind back into the index, set it to `true` in `config/config.exs`:

      config :przetargowi, :index_detail_pages, rulings: true, reports: false

  The page's robots tag and the sitemap both follow this one setting, so they
  cannot disagree.
  """

  @type kind :: :rulings | :reports

  @doc "Whether detail pages of the given kind are indexable."
  @spec detail_pages?(kind) :: boolean
  def detail_pages?(kind) when kind in [:rulings, :reports] do
    :przetargowi |> Application.get_env(:index_detail_pages, []) |> Keyword.get(kind, false)
  end

  @doc "Whether any kind of detail page is indexable (the sitemap then needs an index)."
  def any_detail_pages?, do: detail_pages?(:rulings) or detail_pages?(:reports)
end
