defmodule Przetargowi.Profiles do
  @moduledoc """
  Context for managing company profiles used in public procurement documents.
  """
  import Ecto.Query

  alias Przetargowi.Profiles.CompanyProfile
  alias Przetargowi.Repo

  @doc """
  Gets a company profile by ID.
  Returns nil if not found.
  """
  def get_profile(id) do
    Repo.get(CompanyProfile, id)
  end

  @doc """
  Gets a company profile by ID.
  Raises if not found.
  """
  def get_profile!(id) do
    Repo.get!(CompanyProfile, id)
  end

  @doc """
  Gets a company profile by ID only if it belongs to the given user.
  Returns nil if not found or not owned by user.
  """
  def get_user_profile(user_id, profile_id) do
    CompanyProfile
    |> where([p], p.id == ^profile_id and p.user_id == ^user_id)
    |> Repo.one()
  end

  @doc """
  Lists all company profiles for a user.
  """
  def list_profiles_by_user(user_id) do
    CompanyProfile
    |> where([p], p.user_id == ^user_id)
    |> order_by([p], desc: p.is_primary, asc: p.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets the primary profile for a user.
  Returns nil if no primary profile is set.
  """
  def get_primary_profile(user_id) do
    CompanyProfile
    |> where([p], p.user_id == ^user_id and p.is_primary == true)
    |> Repo.one()
  end

  @doc """
  Sets a profile as the primary profile for a user.
  Unsets any other primary profiles for the same user.
  """
  def set_primary_profile(user_id, profile_id) do
    Repo.transaction(fn ->
      # Unset all primary profiles for this user
      from(p in CompanyProfile, where: p.user_id == ^user_id and p.is_primary == true)
      |> Repo.update_all(set: [is_primary: false])

      # Set the new primary profile
      case get_user_profile(user_id, profile_id) do
        nil ->
          Repo.rollback(:not_found)

        profile ->
          profile
          |> CompanyProfile.update_changeset(%{is_primary: true})
          |> Repo.update()
      end
    end)
  end

  @doc """
  Returns a changeset for tracking profile changes.
  """
  def change_profile(%CompanyProfile{} = profile, attrs \\ %{}) do
    CompanyProfile.update_changeset(profile, attrs)
  end

  @doc """
  Creates a new company profile.
  """
  def create_profile(attrs) do
    %CompanyProfile{}
    |> CompanyProfile.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an existing company profile.
  """
  def update_profile(%CompanyProfile{} = profile, attrs) do
    profile
    |> CompanyProfile.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company profile.
  """
  def delete_profile(%CompanyProfile{} = profile) do
    Repo.delete(profile)
  end
end
