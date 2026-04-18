defmodule PrzetargowiWeb.BlogHTML do
  @moduledoc """
  This module contains pages rendered by BlogController.
  """
  use PrzetargowiWeb, :html

  embed_templates "blog_html/*"

  def format_date(nil), do: ""

  def format_date(%DateTime{} = dt) do
    Calendar.strftime(dt, "%d.%m.%Y")
  end
end
