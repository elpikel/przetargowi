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
  def get_judgement(id) when is_integer(id), do: Repo.get(Judgement, id)

  def get_judgement(id) when is_binary(id) do
    case Integer.parse(id) do
      {int_id, ""} -> Repo.get(Judgement, int_id)
      _ -> get_judgement_by_signature(id)
    end
  end

  @doc """
  Gets a single judgement by signature (case-insensitive).
  """
  def get_judgement_by_signature(signature) do
    # Normalize signature: "kio-1234-24" -> "KIO 1234/24"
    normalized = normalize_signature(signature)

    Judgement
    |> where([j], fragment("LOWER(?)", j.signature) == ^String.downcase(normalized))
    |> Repo.one()
  end

  defp normalize_signature(sig) do
    sig
    |> String.upcase()
    |> String.replace("-", " ", global: false)
    |> String.replace("-", "/")
  end

  @doc """
  Gets a single judgement by UZP ID.
  """
  def get_judgement_by_uzp_id(uzp_id) do
    Repo.get_by(Judgement, uzp_id: uzp_id)
  end

  @doc """
  Checks if a judgement with the given UZP ID exists.
  """
  def exists_by_uzp_id?(uzp_id) do
    Judgement
    |> where([j], j.uzp_id == ^uzp_id)
    |> Repo.exists?()
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
  Search judgements by query string and filters.
  """
  def search_judgements(query, opts \\ []) do
    limit = Keyword.get(opts, :limit, 20)
    offset = Keyword.get(opts, :offset, 0)
    filters = Keyword.get(opts, :filters, %{})

    base_query = Judgement

    base_query =
      if query != "" do
        search_term = "%#{query}%"
        base_query |> where([j], ^build_search_conditions(search_term))
      else
        base_query
      end

    base_query
    |> apply_filters(filters)
    |> order_by(desc: :decision_date)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end

  @doc """
  Count search results with filters.
  """
  def count_search_results(query, filters \\ %{}) do
    base_query = Judgement

    base_query =
      if query != "" do
        search_term = "%#{query}%"
        base_query |> where([j], ^build_search_conditions(search_term))
      else
        base_query
      end

    base_query
    |> apply_filters(filters)
    |> Repo.aggregate(:count, :id)
  end

  defp build_search_conditions(search_term) do
    dynamic(
      [j],
      ilike(j.signature, ^search_term) or
        ilike(j.contracting_authority, ^search_term) or
        ilike(j.document_type, ^search_term) or
        ilike(j.issuing_authority, ^search_term) or
        ilike(j.resolution_method, ^search_term) or
        ilike(j.procedure_type, ^search_term) or
        fragment("EXISTS (SELECT 1 FROM unnest(?) AS t WHERE t ILIKE ?)", j.thematic_issues, ^search_term) or
        ilike(j.content_html, ^search_term)
    )
  end

  defp apply_filters(query, filters) do
    Enum.reduce(filters, query, fn
      {:document_type, value}, q when value != "" ->
        where(q, [j], j.document_type == ^value)

      {:issuing_authority, value}, q when value != "" ->
        where(q, [j], j.issuing_authority == ^value)

      {:resolution_method, value}, q when value != "" ->
        where(q, [j], j.resolution_method == ^value)

      {:procedure_type, value}, q when value != "" ->
        where(q, [j], j.procedure_type == ^value)

      {:date_from, value}, q when value != "" ->
        case Date.from_iso8601(value) do
          {:ok, date} -> where(q, [j], j.decision_date >= ^date)
          _ -> q
        end

      {:date_to, value}, q when value != "" ->
        case Date.from_iso8601(value) do
          {:ok, date} -> where(q, [j], j.decision_date <= ^date)
          _ -> q
        end

      _, q ->
        q
    end)
  end

  @doc """
  Get distinct values for filter dropdowns.
  """
  def get_filter_options do
    %{
      document_types: get_distinct_values(:document_type),
      issuing_authorities: get_distinct_values(:issuing_authority),
      resolution_methods: get_distinct_values(:resolution_method),
      procedure_types: get_distinct_values(:procedure_type)
    }
  end

  defp get_distinct_values(field) do
    Judgement
    |> select([j], field(j, ^field))
    |> where([j], not is_nil(field(j, ^field)))
    |> distinct(true)
    |> order_by([j], field(j, ^field))
    |> Repo.all()
  end

  @doc """
  Returns judgements that need deliberation extraction (have content but no deliberation).
  """
  def judgements_needing_extraction(limit \\ 100) do
    Judgement
    |> where([j], not is_nil(j.content_html) and is_nil(j.deliberation))
    |> select([j], %{id: j.id, content_html: j.content_html})
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns count of judgements needing extraction.
  """
  def count_judgements_needing_extraction do
    Judgement
    |> where([j], not is_nil(j.content_html) and is_nil(j.deliberation))
    |> Repo.aggregate(:count)
  end

  @doc """
  Updates only deliberation and meritum fields.
  """
  def update_deliberation(%Judgement{} = judgement, attrs) do
    judgement
    |> Ecto.Changeset.cast(attrs, [:deliberation, :meritum])
    |> Repo.update()
  end

  @doc """
  Updates deliberation and meritum by judgement ID.
  """
  def update_deliberation_by_id(id, attrs) do
    Judgement
    |> where([j], j.id == ^id)
    |> Repo.update_all(set: [
      deliberation: attrs.deliberation,
      meritum: attrs.meritum,
      updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
    ])
    |> case do
      {1, _} -> {:ok, id}
      {0, _} -> {:error, :not_found}
    end
  end
end
