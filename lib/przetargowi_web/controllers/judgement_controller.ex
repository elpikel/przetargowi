defmodule PrzetargowiWeb.JudgementController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements

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

        conn
        |> assign(:page_title, view_judgement.signature || "Orzeczenie")
        |> assign(:judgement, view_judgement)
        |> render(:show)
    end
  end
end
