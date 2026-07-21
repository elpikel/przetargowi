defmodule PrzetargowiWeb.JudgementController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements
  alias Przetargowi.Judgements.Summary

  defp build_meta_description(judgement) do
    signature = judgement.signature || "orzeczenie"
    prefix = "Wyrok KIO #{signature} — orzecznictwo zamówień publicznych. "

    content =
      cond do
        judgement.meritum && String.length(judgement.meritum) > 0 ->
          judgement.meritum

        judgement.deliberation && String.length(judgement.deliberation) > 0 ->
          judgement.deliberation

        true ->
          ""
      end

    (prefix <> content)
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
    |> String.slice(0, 155)
    |> Kernel.<>("...")
  end

  # Thin/empty rulings (no fetched content) are kept out of the index so they
  # stop dragging the domain's quality signal down. Once content is fetched and
  # the page carries real value, it becomes indexable again automatically.
  defp maybe_noindex(conn, judgement) do
    if Summary.indexable?(judgement) do
      conn
    else
      assign(conn, :meta_robots, "noindex, follow")
    end
  end

  def show(conn, %{"slug" => slug}) do
    case Judgements.get_judgement(slug) do
      nil ->
        conn
        |> put_flash(:error, "Orzeczenie nie zostało znalezione")
        |> redirect(to: "/szukaj")

      judgement when judgement.slug != nil and judgement.slug != slug ->
        conn
        |> put_status(301)
        |> redirect(to: "/orzeczenie/#{judgement.slug}")

      judgement ->
        view_judgement = %{
          id: judgement.id,
          slug: judgement.slug,
          signature: judgement.signature,
          decision_date: judgement.decision_date,
          issuing_authority: judgement.issuing_authority,
          document_type: judgement.document_type,
          chairman: judgement.chairman,
          contracting_authority: judgement.contracting_authority,
          location: judgement.location,
          procedure_type: judgement.procedure_type,
          resolution_method: judgement.resolution_method,
          key_provisions: judgement.key_provisions || [],
          thematic_issues: judgement.thematic_issues || [],
          deliberation: judgement.deliberation,
          meritum: judgement.meritum,
          content_html: judgement.content_html,
          pdf_url: judgement.pdf_url
        }

        meta_description = build_meta_description(judgement)
        narrative = Summary.narrative(judgement)
        related_judgements = Judgements.list_related_judgements(judgement)
        url_identifier = judgement.slug || judgement.id
        canonical_url = "https://przetargowi.pl/orzeczenie/#{url_identifier}"

        breadcrumbs = [
          %{name: "Strona główna", url: "https://przetargowi.pl"},
          %{name: "Orzecznictwo KIO", url: "https://przetargowi.pl/szukaj"},
          %{name: view_judgement.signature || "Orzeczenie", url: canonical_url}
        ]

        page_title =
          if view_judgement.signature do
            "#{view_judgement.signature} — wyrok KIO, orzecznictwo zamówień publicznych"
          else
            "Orzeczenie KIO — orzecznictwo zamówień publicznych"
          end

        conn
        |> assign(:page_title, page_title)
        |> assign(:meta_description, meta_description)
        |> assign(:canonical_url, canonical_url)
        |> assign(:og_url, canonical_url)
        |> maybe_noindex(judgement)
        |> assign(:breadcrumbs, breadcrumbs)
        |> assign(:judgement, view_judgement)
        |> assign(:narrative, narrative)
        |> assign(:related_judgements, related_judgements)
        |> render(:show)
    end
  end
end
