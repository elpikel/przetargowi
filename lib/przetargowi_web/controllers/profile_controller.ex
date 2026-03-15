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
    attrs = Map.put(profile_params, "user_id", user.id)

    case Profiles.create_profile(attrs) do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profil firmy został utworzony.")
        |> redirect(to: ~p"/profil-firmy")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
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
        case Profiles.update_profile(profile, profile_params) do
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
end
