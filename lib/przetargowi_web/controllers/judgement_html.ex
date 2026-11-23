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

  # The page has its own <h1>; source documents often contain another one.
  defp demote_headings(tree) do
    Floki.traverse_and_update(tree, fn
      {"h1", attrs, children} -> {"h2", attrs, children}
      node -> node
    end)
  end

  @doc """
  Structured data for a ruling. schema.org has no court-decision type that
  search engines read, so the ruling is described as an `Article` about its
  legal issues, published by the issuing authority's source and hosted here.
  """
  def json_ld(judgement, heading, topics) do
    url = "https://przetargowi.pl/orzecznictwo-kio/#{judgement.slug || judgement.id}"
    date = judgement.decision_date && Date.to_iso8601(judgement.decision_date)

    %{
      "@context" => "https://schema.org",
      "@type" => "Article",
      "headline" => heading,
      "name" => heading,
      "description" => judgement.meritum || judgement.deliberation,
      "datePublished" => date,
      "inLanguage" => "pl-PL",
      "genre" => judgement.document_type,
      "author" => %{
        "@type" => "GovernmentOrganization",
        "name" => judgement.issuing_authority || "Krajowa Izba Odwoławcza"
      },
      "publisher" => %{
        "@type" => "Organization",
        "name" => "Przetargowi.pl",
        "url" => "https://przetargowi.pl"
      },
      "about" => Enum.map(topics, &%{"@type" => "Thing", "name" => &1.name}),
      "keywords" => Enum.join(judgement.thematic_issues, ", "),
      "isBasedOn" => judgement.pdf_url,
      "mainEntityOfPage" => url
    }
    |> Map.reject(fn {_key, value} -> value in [nil, "", []] end)
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
        |> demote_headings()
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
