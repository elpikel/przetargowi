defmodule PrzetargowiWeb.JudgementHTML do
  use PrzetargowiWeb, :html

  embed_templates "judgement_html/*"

  def source_badge_class(source) do
    case source do
      "KIO" -> "badge-kio"
      "SO" -> "badge-so"
      "SA" -> "badge-sa"
      "SN" -> "badge-sn"
      _ -> "badge-kio"
    end
  end
end
