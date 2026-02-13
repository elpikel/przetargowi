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
        # Transform for view - extract plain text content from HTML
        view_judgement = %{
          id: judgement.id,
          signature: judgement.signature || "Brak sygnatury",
          decision_date: judgement.decision_date,
          issuing_authority: judgement.issuing_authority || "Nieznany organ",
          document_type: judgement.document_type || "Dokument",
          chairman: judgement.chairman || "Nieznany",
          contracting_authority: judgement.contracting_authority || "Nieznany zamawiający",
          location: judgement.location || "Nieznana lokalizacja",
          procedure_type: judgement.procedure_type || "Nieznany tryb",
          order_type: judgement.order_type || "Nieznany rodzaj",
          resolution_method: judgement.resolution_method || "Nieznany sposób rozstrzygnięcia",
          key_provisions: judgement.key_provisions || [],
          thematic_issues: judgement.thematic_issues || [],
          meritum: extract_meritum(judgement.content_html),
          content: extract_plain_text(judgement.content_html),
          pdf_url: judgement.pdf_url || "#"
        }

        conn
        |> assign(:page_title, view_judgement.signature)
        |> assign(:judgement, view_judgement)
        |> render(:show)
    end
  end

  # Extract plain text from HTML content
  defp extract_plain_text(nil), do: "Brak treści dokumentu"
  defp extract_plain_text(html) do
    case Floki.parse_document(html) do
      {:ok, document} -> Floki.text(document)
      _ -> html
    end
  end

  # Extract meritum (summary) - first paragraph or first 500 chars
  defp extract_meritum(nil), do: "Brak streszczenia"
  defp extract_meritum(html) do
    text = extract_plain_text(html)

    text
    |> String.split(~r/\n\n+/)
    |> Enum.find(fn p -> String.length(String.trim(p)) > 100 end)
    |> case do
      nil ->
        text |> String.slice(0, 500) |> String.trim()
      paragraph ->
        paragraph |> String.slice(0, 500) |> String.trim()
    end
  end
end
