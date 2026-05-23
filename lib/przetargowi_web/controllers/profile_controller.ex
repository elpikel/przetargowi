defmodule PrzetargowiWeb.ProfileController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Profiles
  alias Przetargowi.Profiles.CompanyProfile

  def index(conn, _params) do
    user = conn.assigns.current_scope.user
    profiles = Profiles.list_profiles_by_user(user.id)

    render(conn, :index, profiles: profiles)
  end

  def new(conn, _params) do
    changeset = Profiles.change_profile(%CompanyProfile{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"company_profile" => profile_params}) do
    user = conn.assigns.current_scope.user

    attrs =
      profile_params
      |> filter_empty_representatives()
      |> Map.put("user_id", user.id)

    case Profiles.create_profile(attrs) do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profil firmy został utworzony.")
        |> redirect(to: ~p"/profil-firmy")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Popraw błędy w formularzu.")
        |> render(:new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_scope.user

    case Profiles.get_user_profile(user.id, id) do
      nil ->
        conn
        |> put_flash(:error, "Profil nie został znaleziony.")
        |> redirect(to: ~p"/profil-firmy")

      profile ->
        changeset = Profiles.change_profile(profile)
        render(conn, :edit, profile: profile, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "company_profile" => profile_params}) do
    user = conn.assigns.current_scope.user

    case Profiles.get_user_profile(user.id, id) do
      nil ->
        conn
        |> put_flash(:error, "Profil nie został znaleziony.")
        |> redirect(to: ~p"/profil-firmy")

      profile ->
        case Profiles.update_profile(profile, filter_empty_representatives(profile_params)) do
          {:ok, _profile} ->
            conn
            |> put_flash(:info, "Profil firmy został zaktualizowany.")
            |> redirect(to: ~p"/profil-firmy")

          {:error, changeset} ->
            render(conn, :edit, profile: profile, changeset: changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_scope.user

    case Profiles.get_user_profile(user.id, id) do
      nil ->
        conn
        |> put_flash(:error, "Profil nie został znaleziony.")
        |> redirect(to: ~p"/profil-firmy")

      profile ->
        {:ok, _} = Profiles.delete_profile(profile)

        conn
        |> put_flash(:info, "Profil firmy został usunięty.")
        |> redirect(to: ~p"/profil-firmy")
    end
  end

  def set_primary(conn, %{"id" => id}) do
    user = conn.assigns.current_scope.user

    case Profiles.set_primary_profile(user.id, id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Profil został ustawiony jako domyślny.")
        |> redirect(to: ~p"/profil-firmy")

      {:error, _} ->
        conn
        |> put_flash(:error, "Nie udało się ustawić profilu jako domyślnego.")
        |> redirect(to: ~p"/profil-firmy")
    end
  end

  defp filter_empty_representatives(%{"representatives" => reps} = params) when is_map(reps) do
    filtered =
      reps
      |> Enum.reject(fn {_idx, rep} ->
        blank?(rep["full_name"]) and blank?(rep["position"])
      end)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {{_old_idx, rep}, new_idx} -> {to_string(new_idx), rep} end)

    case filtered do
      empty when map_size(empty) == 0 -> Map.delete(params, "representatives")
      filtered -> Map.put(params, "representatives", filtered)
    end
  end

  defp filter_empty_representatives(params), do: params

  defp blank?(nil), do: true
  defp blank?(s) when is_binary(s), do: String.trim(s) == ""
  defp blank?(_), do: false
end
