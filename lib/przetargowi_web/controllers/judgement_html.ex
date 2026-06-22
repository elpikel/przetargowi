defmodule PrzetargowiWeb.JudgementHTML do
  use PrzetargowiWeb, :html

  embed_templates "judgement_html/*"

  @doc """
  Generates a URL to the local PZP law page for a given provision.
  Parses provision strings like "art. 16 pkt 1" and extracts the article number.
  """
  def provision_url(provision) do
    case Regex.run(~r/art\.?\s*(\d+[a-z]?)/i, provision) do
      [_, article_number] ->
        "/ustawa-pzp#art-#{article_number}"

      _ ->
        nil
    end
  end

  def source_badge_class(source) do
    case source do
      "KIO" -> "badge-kio"
      "SO" -> "badge-so"
      "SA" -> "badge-sa"
      "SN" -> "badge-sn"
      _ -> "badge-kio"
    end
  end

  @doc """
  Sanitizes content_html from UZP by extracting body content
  and stripping dangerous elements (script, link, style, meta tags).
  """
  def sanitize_content_html(nil), do: nil

  def sanitize_content_html(html) do
    case Floki.parse_document(html) do
      {:ok, document} ->
        body_content =
          case Floki.find(document, "body") do
            [{"body", _attrs, children}] -> children
            _ -> document
          end

        body_content
        |> Floki.filter_out("script")
        |> Floki.filter_out("style")
        |> Floki.filter_out("link")
        |> Floki.filter_out("meta")
        |> Floki.raw_html()

      _ ->
        nil
    end
  end
end
