defmodule Przetargowi.Judgements do
  @moduledoc """
  The Judgements context for managing court decisions.
  """

  import Ecto.Query
  alias Przetargowi.Repo
  alias Przetargowi.Judgements.Judgement

  @doc """
  Returns the list of judgements.
  """
  def list_judgements(opts \\ []) do
    limit = Keyword.get(opts, :limit, 50)
    offset = Keyword.get(opts, :offset, 0)

    Judgement
    |> order_by(desc: :decision_date)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end

  @doc """
  Gets a single judgement by ID.
  """
  def get_judgement(id), do: Repo.get(Judgement, id)

  @doc """
  Gets a single judgement by UZP ID.
  """
  def get_judgement_by_uzp_id(uzp_id) do
    Repo.get_by(Judgement, uzp_id: uzp_id)
  end

  @doc """
  Creates a judgement.
  """
  def create_judgement(attrs \\ %{}) do
    %Judgement{}
    |> Judgement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a judgement.
  """
  def update_judgement(%Judgement{} = judgement, attrs) do
    judgement
    |> Judgement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Creates or updates a judgement from list page data.
  """
  def upsert_from_list(attrs) do
    case get_judgement_by_uzp_id(attrs.uzp_id) do
      nil ->
        %Judgement{}
        |> Judgement.list_changeset(attrs)
        |> Repo.insert()

      existing ->
        existing
        |> Judgement.list_changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Updates a judgement with details page data.
  """
  def update_with_details(%Judgement{} = judgement, attrs) do
    judgement
    |> Judgement.details_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns judgements that need details to be fetched.
  """
  def judgements_needing_details(limit \\ 100) do
    Judgement
    |> where([j], is_nil(j.details_synced_at))
    |> order_by(desc: :decision_date)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Counts total judgements.
  """
  def count_judgements do
    Repo.aggregate(Judgement, :count, :id)
  end

  @doc """
  Search judgements by query string.
  """
  def search_judgements(query, opts \\ []) do
    limit = Keyword.get(opts, :limit, 20)
    offset = Keyword.get(opts, :offset, 0)

    search_term = "%#{query}%"

    Judgement
    |> where(
      [j],
      ilike(j.signature, ^search_term) or
        ilike(j.contracting_authority, ^search_term) or
        ilike(j.content_html, ^search_term)
    )
    |> order_by(desc: :decision_date)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end
end
