defmodule PrzetargowiWeb.JudgementController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements

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

  def show(conn, %{"slug" => slug}) do
    case Judgements.get_judgement(slug) do
      nil ->
        conn
        |> put_flash(:error, "Orzeczenie nie zostało znalezione")
        |> redirect(to: "/szukaj")

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
        |> assign(:breadcrumbs, breadcrumbs)
        |> assign(:judgement, view_judgement)
        |> render(:show)
    end
  end
end
