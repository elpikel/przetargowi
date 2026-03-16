defmodule PrzetargowiWeb.DocumentController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Tenders

  @doc """
  Downloads a document by its object_id.
  Serves the stored content if available, otherwise redirects to the external URL.
  """
  def download(conn, %{"id" => object_id}) do
    case Tenders.get_document(object_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(html: PrzetargowiWeb.ErrorHTML)
        |> render(:"404")

      %{content: nil, url: url} when not is_nil(url) ->
        redirect(conn, external: url)

      %{content: content, file_name: file_name} when not is_nil(content) ->
        content_type = get_content_type(file_name)

        conn
        |> put_resp_content_type(content_type)
        |> put_resp_header(
          "content-disposition",
          ~s(attachment; filename="#{file_name}")
        )
        |> send_resp(200, content)

      %{url: url} when not is_nil(url) ->
        redirect(conn, external: url)

      _ ->
        conn
        |> put_status(:not_found)
        |> put_view(html: PrzetargowiWeb.ErrorHTML)
        |> render(:"404")
    end
  end

  defp get_content_type(file_name) do
    case Path.extname(file_name) |> String.downcase() do
      ".docx" -> "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      ".doc" -> "application/msword"
      ".pdf" -> "application/pdf"
      ".xlsx" -> "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      ".xls" -> "application/vnd.ms-excel"
      ".zip" -> "application/zip"
      ".7z" -> "application/x-7z-compressed"
      ".rar" -> "application/vnd.rar"
      _ -> "application/octet-stream"
    end
  end
end
