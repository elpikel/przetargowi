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
  Lists all company profiles for a user.
  """
  def list_profiles_by_user(user_id) do
    CompanyProfile
    |> where([p], p.user_id == ^user_id)
    |> Repo.all()
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
end
