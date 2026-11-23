defmodule Przetargowi.Blog.Article do
  @moduledoc """
  A blog article, loaded from a file in `priv/blog` (see `Przetargowi.Blog`).
  """

  @enforce_keys [:slug, :title, :content, :published_at]
  defstruct [
    :slug,
    :title,
    :excerpt,
    :meta_description,
    :keywords,
    :content,
    :published_at,
    :updated_at,
    author: "Redakcja Przetargowi.pl"
  ]
end
