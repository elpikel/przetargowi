defmodule PrzetargowiWeb.SearchHTML do
  @moduledoc """
  This module contains pages rendered by SearchController.

  See the `search_html` directory for all templates available.
  """
  use PrzetargowiWeb, :html

  embed_templates "search_html/*"

  @doc """
  Returns the badge CSS class for a given court source.
  """
  def badge_class("KIO"), do: "badge-primary"
  def badge_class("SO"), do: "badge-secondary"
  def badge_class("SA"), do: "badge-accent"
  def badge_class("SN"), do: "badge-info"
  def badge_class(_), do: "badge-ghost"

  @doc """
  Returns the styled badge class for source badges (new design).
  """
  def source_badge_class("KIO"), do: "bg-primary/15 text-primary"
  def source_badge_class("SO"), do: "bg-accent/15 text-accent"
  def source_badge_class("SA"), do: "bg-secondary/15 text-secondary"
  def source_badge_class("SN"), do: "bg-info/15 text-info"
  def source_badge_class(_), do: "bg-base-200 text-base-content/70"

  @doc """
  Returns the court badge CSS class.
  """
  def court_badge_class("KIO"), do: "badge-kio"
  def court_badge_class("SO"), do: "badge-so"
  def court_badge_class("SA"), do: "badge-sa"
  def court_badge_class("SN"), do: "badge-sn"
  def court_badge_class(_), do: "bg-base-300 text-base-content"

  @doc """
  Formats relevance score as percentage.
  """
  def format_relevance(score) when is_float(score) do
    "#{round(score * 100)}%"
  end

  def format_relevance(_), do: "-"
end
