defmodule PrzetargowiWeb.ProfileControllerTest do
  use PrzetargowiWeb.ConnCase, async: true

  import Przetargowi.AccountsFixtures
  import Przetargowi.ProfilesFixtures

  alias Przetargowi.Profiles

  setup :register_and_log_in_user

  describe "GET /profil-firmy" do
    test "renders empty index page", %{conn: conn} do
      conn = get(conn, ~p"/profil-firmy")
      response = html_response(conn, 200)
      assert response =~ "Profile firmy"
      assert response =~ "Nie masz jeszcze żadnych profili firmy"
    end

    test "renders profiles list", %{conn: conn, user: user} do
      profile = profile_fixture(user: user)
      conn = get(conn, ~p"/profil-firmy")
      response = html_response(conn, 200)
      assert response =~ "Profile firmy"
      assert response =~ profile.company_name
      assert response =~ profile.nip
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = get(conn, ~p"/profil-firmy")
      assert redirected_to(conn) == ~p"/logowanie"
    end
  end

  describe "GET /profil-firmy/nowy" do
    test "renders new profile form", %{conn: conn} do
      conn = get(conn, ~p"/profil-firmy/nowy")
      response = html_response(conn, 200)
      assert response =~ "Nowy profil firmy"
      assert response =~ "Dane identyfikacyjne"
    end
  end

  describe "POST /profil-firmy" do
    test "creates profile with valid data", %{conn: conn} do
      attrs = valid_profile_attributes() |> Map.delete(:user_id) |> stringify_keys()

      conn = post(conn, ~p"/profil-firmy", %{"company_profile" => attrs})
      assert redirected_to(conn) == ~p"/profil-firmy"

      conn = get(conn, ~p"/profil-firmy")
      response = html_response(conn, 200)
      assert response =~ attrs["company_name"]
    end

    test "returns errors with invalid data", %{conn: conn} do
      attrs = %{"company_name" => "", "nip" => "invalid"}

      conn = post(conn, ~p"/profil-firmy", %{"company_profile" => attrs})
      response = html_response(conn, 200)
      assert response =~ "Nowy profil firmy"
    end
  end

  describe "GET /profil-firmy/:id/edycja" do
    test "renders edit form for own profile", %{conn: conn, user: user} do
      profile = profile_fixture(user: user)
      conn = get(conn, ~p"/profil-firmy/#{profile.id}/edycja")
      response = html_response(conn, 200)
      assert response =~ "Edytuj profil firmy"
      assert response =~ profile.company_name
    end

    test "redirects when profile not found", %{conn: conn} do
      conn = get(conn, ~p"/profil-firmy/999999/edycja")
      assert redirected_to(conn) == ~p"/profil-firmy"
    end

    test "redirects when profile belongs to another user", %{conn: conn} do
      other_user = user_fixture()
      profile = profile_fixture(user: other_user)
      conn = get(conn, ~p"/profil-firmy/#{profile.id}/edycja")
      assert redirected_to(conn) == ~p"/profil-firmy"
    end
  end

  describe "PUT /profil-firmy/:id" do
    test "updates profile with valid data", %{conn: conn, user: user} do
      profile = profile_fixture(user: user)

      conn =
        put(conn, ~p"/profil-firmy/#{profile.id}", %{
          "company_profile" => %{"company_name" => "Updated Name"}
        })

      assert redirected_to(conn) == ~p"/profil-firmy"

      updated = Profiles.get_profile(profile.id)
      assert updated.company_name == "Updated Name"
    end

    test "returns errors with invalid data", %{conn: conn, user: user} do
      profile = profile_fixture(user: user)

      conn =
        put(conn, ~p"/profil-firmy/#{profile.id}", %{
          "company_profile" => %{"nip" => "invalid"}
        })

      response = html_response(conn, 200)
      assert response =~ "Edytuj profil firmy"
    end

    test "redirects when profile belongs to another user", %{conn: conn} do
      other_user = user_fixture()
      profile = profile_fixture(user: other_user)

      conn =
        put(conn, ~p"/profil-firmy/#{profile.id}", %{
          "company_profile" => %{"company_name" => "Hacked"}
        })

      assert redirected_to(conn) == ~p"/profil-firmy"

      # Profile should not be updated
      unchanged = Profiles.get_profile(profile.id)
      assert unchanged.company_name != "Hacked"
    end
  end

  describe "DELETE /profil-firmy/:id" do
    test "deletes own profile", %{conn: conn, user: user} do
      profile = profile_fixture(user: user)

      conn = delete(conn, ~p"/profil-firmy/#{profile.id}")
      assert redirected_to(conn) == ~p"/profil-firmy"

      assert Profiles.get_profile(profile.id) == nil
    end

    test "does not delete profile belonging to another user", %{conn: conn} do
      other_user = user_fixture()
      profile = profile_fixture(user: other_user)

      conn = delete(conn, ~p"/profil-firmy/#{profile.id}")
      assert redirected_to(conn) == ~p"/profil-firmy"

      # Profile should still exist
      assert Profiles.get_profile(profile.id) != nil
    end
  end

  describe "POST /profil-firmy/:id/ustaw-domyslny" do
    test "sets profile as primary", %{conn: conn, user: user} do
      profile = profile_fixture(user: user, is_primary: false)

      conn = post(conn, ~p"/profil-firmy/#{profile.id}/ustaw-domyslny")
      assert redirected_to(conn) == ~p"/profil-firmy"

      updated = Profiles.get_profile(profile.id)
      assert updated.is_primary == true
    end

    test "does not set another user's profile as primary", %{conn: conn} do
      other_user = user_fixture()
      profile = profile_fixture(user: other_user, is_primary: false)

      conn = post(conn, ~p"/profil-firmy/#{profile.id}/ustaw-domyslny")
      assert redirected_to(conn) == ~p"/profil-firmy"

      # Profile should not be changed
      unchanged = Profiles.get_profile(profile.id)
      assert unchanged.is_primary == false
    end
  end

  defp stringify_keys(map) do
    Map.new(map, fn
      {k, v} when is_map(v) -> {to_string(k), stringify_keys(v)}
      {k, v} when is_list(v) -> {to_string(k), Enum.map(v, &stringify_keys/1)}
      {k, v} when is_atom(k) -> {to_string(k), v}
      {k, v} -> {k, v}
    end)
  end
end
