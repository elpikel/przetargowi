defmodule PrzetargowiWeb.JudgementController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements

  defp build_meta_description(judgement) do
    base =
      cond do
        judgement.meritum && String.length(judgement.meritum) > 0 ->
          judgement.meritum

        judgement.deliberation && String.length(judgement.deliberation) > 0 ->
          judgement.deliberation

        true ->
          "Orzeczenie #{judgement.signature || ""} - #{judgement.issuing_authority || "KIO"}"
      end

    base
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
    |> String.slice(0, 155)
    |> Kernel.<>("...")
  end

  def show(conn, %{"id" => id}) do
    case Judgements.get_judgement(id) do
      nil ->
        conn
        |> put_flash(:error, "Orzeczenie nie zostało znalezione")
        |> redirect(to: "/szukaj")

      judgement ->
        view_judgement = %{
          id: judgement.id,
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
        canonical_url = "https://przetargowi.pl/orzeczenie/#{judgement.id}"

        breadcrumbs = [
          %{name: "Strona główna", url: "https://przetargowi.pl"},
          %{name: "Wyszukiwarka", url: "https://przetargowi.pl/szukaj"},
          %{name: view_judgement.signature || "Orzeczenie", url: canonical_url}
        ]

        conn
        |> assign(:page_title, view_judgement.signature || "Orzeczenie")
        |> assign(:meta_description, meta_description)
        |> assign(:canonical_url, canonical_url)
        |> assign(:og_url, canonical_url)
        |> assign(:breadcrumbs, breadcrumbs)
        |> assign(:judgement, view_judgement)
        |> render(:show)
    end
  end
end
