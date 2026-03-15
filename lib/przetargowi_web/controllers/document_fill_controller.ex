defmodule PrzetargowiWeb.DocumentFillController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.DocumentFiller
  alias Przetargowi.Profiles
  alias Przetargowi.Tenders
  alias Przetargowi.TenderDocuments

  plug :require_profile

  def show(conn, %{"slug" => slug}) do
    user = conn.assigns.current_scope.user

    case Tenders.get_tender_by_slug(slug) do
      nil ->
        conn
        |> put_flash(:error, "Przetarg nie został znaleziony.")
        |> redirect(to: ~p"/przetargi")

      tender ->
        documents = Tenders.get_documents_by_tender_id(tender.tender_id)
        fillable_documents = Enum.filter(documents, &fillable?/1)
        profiles = Profiles.list_profiles_by_user(user.id)
        primary_profile = Profiles.get_primary_profile(user.id)

        render(conn, :show,
          tender: tender,
          documents: fillable_documents,
          profiles: profiles,
          selected_profile_id: primary_profile && primary_profile.id
        )
    end
  end

  def create(conn, %{"slug" => slug} = params) do
    user = conn.assigns.current_scope.user
    profile_id = params["profile_id"]
    document_ids = params["document_ids"] || []

    with {:ok, profile} <- get_user_profile(user.id, profile_id),
         {:ok, tender} <- get_tender(slug),
         {:ok, documents} <- get_selected_documents(tender.tender_id, document_ids) do
      case fill_and_download(documents, profile) do
        {:ok, zip_binary, filename} ->
          conn
          |> put_resp_content_type("application/zip")
          |> put_resp_header("content-disposition", "attachment; filename=\"#{filename}\"")
          |> send_resp(200, zip_binary)

        {:error, :no_documents_filled} ->
          conn
          |> put_flash(
            :error,
            "Nie udało się pobrać żadnego dokumentu. Dokumenty z ezamowienia.gov.pl wymagają ręcznego pobrania przez przeglądarkę."
          )
          |> redirect(to: ~p"/przetargi/#{slug}/wypelnij")

        {:error, reason} ->
          conn
          |> put_flash(:error, "Nie udało się wypełnić dokumentów: #{format_error(reason)}")
          |> redirect(to: ~p"/przetargi/#{slug}/wypelnij")
      end
    else
      {:error, :profile_not_found} ->
        conn
        |> put_flash(:error, "Profil nie został znaleziony.")
        |> redirect(to: ~p"/przetargi/#{slug}/wypelnij")

      {:error, :tender_not_found} ->
        conn
        |> put_flash(:error, "Przetarg nie został znaleziony.")
        |> redirect(to: ~p"/przetargi")

      {:error, :no_documents_selected} ->
        conn
        |> put_flash(:error, "Wybierz co najmniej jeden dokument.")
        |> redirect(to: ~p"/przetargi/#{slug}/wypelnij")
    end
  end

  defp require_profile(conn, _opts) do
    user = conn.assigns.current_scope.user
    profiles = Profiles.list_profiles_by_user(user.id)

    if Enum.empty?(profiles) do
      conn
      |> put_flash(:info, "Najpierw dodaj profil firmy, aby móc wypełniać dokumenty.")
      |> redirect(to: ~p"/profil-firmy/nowy")
      |> halt()
    else
      conn
    end
  end

  defp fillable?(%{file_name: file_name, name: name}) do
    TenderDocuments.fillable?(name, file_name)
  end

  defp get_user_profile(user_id, profile_id) do
    case Profiles.get_user_profile(user_id, profile_id) do
      nil -> {:error, :profile_not_found}
      profile -> {:ok, profile}
    end
  end

  defp get_tender(slug) do
    case Tenders.get_tender_by_slug(slug) do
      nil -> {:error, :tender_not_found}
      tender -> {:ok, tender}
    end
  end

  defp get_selected_documents(tender_id, document_ids) when is_list(document_ids) do
    if Enum.empty?(document_ids) do
      {:error, :no_documents_selected}
    else
      documents = Tenders.get_documents_by_tender_id(tender_id)

      selected =
        documents
        |> Enum.filter(fn doc -> doc.object_id in document_ids end)

      if Enum.empty?(selected) do
        {:error, :no_documents_selected}
      else
        {:ok, selected}
      end
    end
  end

  defp get_selected_documents(_tender_id, _), do: {:error, :no_documents_selected}

  defp fill_and_download(documents, profile) do
    # Pass TenderDocument structs directly - DocumentFiller will use stored content if available
    case DocumentFiller.fill_documents(documents, profile) do
      {:ok, zip_binary, _success_count, _total_count} ->
        filename = "dokumenty_#{Date.to_iso8601(Date.utc_today())}.zip"
        {:ok, zip_binary, filename}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp format_error({:zip_create_failed, reason}) do
    "Błąd tworzenia archiwum: #{inspect(reason)}"
  end

  defp format_error(reason) do
    inspect(reason)
  end
end
