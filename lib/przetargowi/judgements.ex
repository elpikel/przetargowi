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
      _ -> get_judgement_by_slug(id)
    end
  end

  @doc """
  Gets a single judgement by slug.
  """
  def get_judgement_by_slug(slug) do
    Repo.get_by(Judgement, slug: slug)
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
        base_query |> where([j], ^build_search_conditions(query))
      else
        base_query
      end

    base_query
    |> apply_filters(filters)
    |> order_by(desc: :decision_date)
    |> select([j], %{
      id: j.id,
      slug: j.slug,
      signature: j.signature,
      decision_date: j.decision_date,
      document_type: j.document_type,
      resolution_method: j.resolution_method,
      contracting_authority: j.contracting_authority,
      meritum: j.meritum
    })
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
        base_query |> where([j], ^build_search_conditions(query))
      else
        base_query
      end

    base_query
    |> apply_filters(filters)
    |> Repo.aggregate(:count, :id)
  end

  defp build_search_conditions(query) do
    # Use full-text search on the search_vector column (GIN indexed)
    # Falls back to ILIKE for signature pattern match
    search_pattern = "%#{query}%"

    dynamic(
      [j],
      fragment("? @@ plainto_tsquery('simple', ?)", j.search_vector, ^query) or
        ilike(j.signature, ^search_pattern)
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
  Returns judgements that have deliberation but are missing meritum.
  """
  def judgements_needing_meritum(limit \\ 100) do
    Judgement
    |> where([j], not is_nil(j.deliberation) and j.deliberation != "" and (is_nil(j.meritum) or j.meritum == ""))
    |> select([j], %{id: j.id, deliberation: j.deliberation})
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns count of judgements needing meritum generation.
  """
  def count_judgements_needing_meritum do
    Judgement
    |> where([j], not is_nil(j.deliberation) and j.deliberation != "" and (is_nil(j.meritum) or j.meritum == ""))
    |> Repo.aggregate(:count)
  end

  @doc """
  Updates only the meritum field by judgement ID.
  """
  def update_meritum_by_id(id, meritum) do
    Judgement
    |> where([j], j.id == ^id)
    |> Repo.update_all(set: [
      meritum: meritum,
      updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
    ])
    |> case do
      {1, _} -> {:ok, id}
      {0, _} -> {:error, :not_found}
    end
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

  @doc """
  Normalizes document type to standard lowercase form.
  """
  def normalize_document_type(nil), do: nil
  def normalize_document_type("-"), do: nil

  def normalize_document_type(type) when is_binary(type) do
    type
    |> String.downcase()
    |> String.trim()
    |> fix_document_type_typos()
  end

  defp fix_document_type_typos("wyok"), do: "wyrok"
  defp fix_document_type_typos(type), do: type

  @doc """
  Returns judgements with non-normalized document types.
  """
  def judgements_needing_document_type_fix(limit \\ 100) do
    # Find documents with uppercase letters, typos, or "-"
    Judgement
    |> where([j], j.document_type == "-" or j.document_type == "wyok" or
                  j.document_type == "Wyrok" or j.document_type == "Postanowienie")
    |> select([j], %{id: j.id, document_type: j.document_type, content_html: j.content_html})
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns count of judgements needing document type fix.
  """
  def count_judgements_needing_document_type_fix do
    Judgement
    |> where([j], j.document_type == "-" or j.document_type == "wyok" or
                  j.document_type == "Wyrok" or j.document_type == "Postanowienie")
    |> Repo.aggregate(:count)
  end

  @doc """
  Detects document type from HTML content.
  """
  def detect_document_type_from_content(nil), do: nil

  def detect_document_type_from_content(content_html) when is_binary(content_html) do
    content_lower = String.downcase(content_html)

    cond do
      # Check uppercase headers first
      String.contains?(content_html, "WYROK") -> "wyrok"
      String.contains?(content_html, "POSTANOWIENIE") -> "postanowienie"
      String.contains?(content_html, "UCHWAŁA") -> "uchwała"
      # Check in title tag (lowercase)
      String.contains?(content_lower, "<title>wyrok") -> "wyrok"
      String.contains?(content_lower, "<title>postanowienie") -> "postanowienie"
      String.contains?(content_lower, "<title>uchwała") -> "uchwała"
      true -> nil
    end
  end

  @doc """
  Returns judgements with NULL document_type that have content for detection.
  """
  def judgements_with_null_document_type(limit \\ 100) do
    Judgement
    |> where([j], is_nil(j.document_type) and not is_nil(j.content_html))
    |> select([j], %{id: j.id, content_html: j.content_html})
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns count of judgements with NULL document_type.
  """
  def count_judgements_with_null_document_type do
    Judgement
    |> where([j], is_nil(j.document_type) and not is_nil(j.content_html))
    |> Repo.aggregate(:count)
  end

  @doc """
  Updates document type by judgement ID.
  """
  def update_document_type_by_id(id, document_type) do
    Judgement
    |> where([j], j.id == ^id)
    |> Repo.update_all(set: [
      document_type: document_type,
      updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
    ])
    |> case do
      {1, _} -> {:ok, id}
      {0, _} -> {:error, :not_found}
    end
  end

  @doc """
  Normalizes resolution method to standard form.
  """
  def normalize_resolution_method(nil), do: nil
  def normalize_resolution_method("-"), do: nil

  def normalize_resolution_method(method) when is_binary(method) do
    method
    |> String.downcase()
    |> String.trim()
    |> String.replace(~r/[.=*]+$/, "")
    |> String.replace(~r/^[=*]+/, "")
    |> String.replace(~r/^\d+:\s*\**\s*/, "")
    |> String.replace(~r/^sposób rozstrzygnięcia:\s*/, "")
    |> String.trim()
    |> map_resolution_method()
  end

  defp map_resolution_method("oddalone"), do: "oddalone"
  defp map_resolution_method("oddalne"), do: "oddalone"
  defp map_resolution_method("oddala"), do: "oddalone"
  defp map_resolution_method("oddala skargę"), do: "oddalone"
  defp map_resolution_method("nie uwzględnia"), do: "oddalone"

  defp map_resolution_method("uwzględnione"), do: "uwzględnione"
  defp map_resolution_method("uwzglednione"), do: "uwzględnione"
  defp map_resolution_method("uwzględnia"), do: "uwzględnione"
  defp map_resolution_method("uwzględnienie"), do: "uwzględnione"
  defp map_resolution_method("uznane"), do: "uwzględnione"
  defp map_resolution_method("uwzględnia w części"), do: "uwzględnione w części"
  defp map_resolution_method("częściowo uwzględnione"), do: "uwzględnione w części"

  defp map_resolution_method("umorzenie postępowania"), do: "umorzone"
  defp map_resolution_method("umorzone"), do: "umorzone"
  defp map_resolution_method("umarza postępowanie"), do: "umorzone"
  defp map_resolution_method("umarza postępowanie odwoławcze"), do: "umorzone"
  defp map_resolution_method("umarzenie postępowania"), do: "umorzone"
  defp map_resolution_method("umorzone (art. 568 ust. 2 ustawy pzp)"), do: "umorzone"
  defp map_resolution_method("umorzone (568 pkt 2)"), do: "umorzone"
  defp map_resolution_method("umorzenie postępowania wszczętego na skutek złożenia wniosku o uchylenie zakazu zawarcia umowy"), do: "umorzone"

  defp map_resolution_method("umorzone (wycofanie)"), do: "umorzone (wycofanie)"
  defp map_resolution_method("wycofanie"), do: "umorzone (wycofanie)"

  defp map_resolution_method("umorzone (uwzględnienie zarzutów przez zamawiającego w całości)"), do: "umorzone (uwzględnienie zarzutów)"
  defp map_resolution_method("umorzone (uwzględnienie zarzutów w całosci przez zamawiającego)"), do: "umorzone (uwzględnienie zarzutów)"
  defp map_resolution_method("umorzone (uwzględnienie zarzutów przez zamawiającego)"), do: "umorzone (uwzględnienie zarzutów)"
  defp map_resolution_method("uwzględnienie zarzutów przez zamawiającego w całości"), do: "umorzone (uwzględnienie zarzutów)"

  defp map_resolution_method("odrzucone"), do: "odrzucone"
  defp map_resolution_method("odrzucenie"), do: "odrzucone"
  defp map_resolution_method("odrzucenie odwołania"), do: "odrzucone"
  defp map_resolution_method("odrzuca skargę"), do: "odrzucone"

  defp map_resolution_method("zwrócone"), do: "zwrócone"
  defp map_resolution_method("zwrócenie"), do: "zwrócone"
  defp map_resolution_method("zwrot"), do: "zwrócone"

  defp map_resolution_method("postanowienie"), do: "postanowienie"

  defp map_resolution_method("odmowa uchylenia zakazu zawarcia umowy"), do: "odmowa uchylenia zakazu"
  defp map_resolution_method("uchylenie zakazu zawarcia umowy"), do: "uchylenie zakazu"

  defp map_resolution_method("wyrok"), do: nil

  defp map_resolution_method(other), do: other

  @doc """
  Returns judgements with non-normalized resolution methods.
  """
  def judgements_needing_resolution_method_fix(limit \\ 100) do
    normalized_values = [
      "oddalone", "uwzględnione", "uwzględnione w części",
      "umorzone", "umorzone (wycofanie)", "umorzone (uwzględnienie zarzutów)",
      "odrzucone", "zwrócone", "postanowienie",
      "odmowa uchylenia zakazu", "uchylenie zakazu"
    ]

    Judgement
    |> where([j], not is_nil(j.resolution_method) and j.resolution_method not in ^normalized_values)
    |> select([j], %{id: j.id, resolution_method: j.resolution_method})
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns count of judgements needing resolution method fix.
  """
  def count_judgements_needing_resolution_method_fix do
    normalized_values = [
      "oddalone", "uwzględnione", "uwzględnione w części",
      "umorzone", "umorzone (wycofanie)", "umorzone (uwzględnienie zarzutów)",
      "odrzucone", "zwrócone", "postanowienie",
      "odmowa uchylenia zakazu", "uchylenie zakazu"
    ]

    Judgement
    |> where([j], not is_nil(j.resolution_method) and j.resolution_method not in ^normalized_values)
    |> Repo.aggregate(:count)
  end

  @doc """
  Updates resolution method by judgement ID.
  """
  def update_resolution_method_by_id(id, resolution_method) do
    Judgement
    |> where([j], j.id == ^id)
    |> Repo.update_all(set: [
      resolution_method: resolution_method,
      updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
    ])
    |> case do
      {1, _} -> {:ok, id}
      {0, _} -> {:error, :not_found}
    end
  end

  @doc """
  Normalizes procedure type to standard form.
  """
  def normalize_procedure_type(nil), do: nil
  def normalize_procedure_type(""), do: nil

  def normalize_procedure_type(type) when is_binary(type) do
    type
    |> String.downcase()
    |> String.trim()
    |> String.replace(~r/\.+$/, "")
    |> String.replace(~r/^tryb postępowania:\s*/, "")
    |> String.trim()
    |> map_procedure_type()
  end

  defp map_procedure_type("nie wiem"), do: nil
  defp map_procedure_type("brak danych"), do: nil

  defp map_procedure_type("przetarg nieograniczony"), do: "przetarg nieograniczony"
  defp map_procedure_type("przetarg nieogranoczony"), do: "przetarg nieograniczony"
  defp map_procedure_type("przetarg nieograniczny"), do: "przetarg nieograniczony"
  defp map_procedure_type("przetarg nieograniczonej"), do: "przetarg nieograniczony"
  defp map_procedure_type("przetag nieograniczony"), do: "przetarg nieograniczony"

  defp map_procedure_type("tryb podstawowy"), do: "tryb podstawowy"
  defp map_procedure_type("przetarg podstawowy"), do: "tryb podstawowy"

  defp map_procedure_type("przetarg ograniczony"), do: "przetarg ograniczony"
  defp map_procedure_type("dialog konkurencyjny"), do: "dialog konkurencyjny"
  defp map_procedure_type("negocjacje z ogłoszeniem"), do: "negocjacje z ogłoszeniem"
  defp map_procedure_type("sektorowe negocjacje z ogłoszeniem"), do: "negocjacje z ogłoszeniem"
  defp map_procedure_type("zamówienie z wolnej ręki"), do: "zamówienie z wolnej ręki"
  defp map_procedure_type("negocjacje bez ogłoszenia"), do: "negocjacje bez ogłoszenia"
  defp map_procedure_type("umowa ramowa"), do: "umowa ramowa"
  defp map_procedure_type("konkurs"), do: "konkurs"
  defp map_procedure_type("zapytanie o cenę"), do: "zapytanie o cenę"
  defp map_procedure_type("licytacja elektroniczna"), do: "licytacja elektroniczna"
  defp map_procedure_type("poza ustawą"), do: "poza ustawą"
  defp map_procedure_type("partnerstwo innowacyjne"), do: "partnerstwo innowacyjne"
  defp map_procedure_type("dynamiczny system zakupów"), do: "dynamiczny system zakupów"
  defp map_procedure_type("usługi społeczne"), do: "usługi społeczne"

  defp map_procedure_type(other), do: other

  @normalized_procedure_types [
    "przetarg nieograniczony", "przetarg ograniczony", "tryb podstawowy",
    "dialog konkurencyjny", "negocjacje z ogłoszeniem", "zamówienie z wolnej ręki",
    "negocjacje bez ogłoszenia", "umowa ramowa", "konkurs", "zapytanie o cenę",
    "licytacja elektroniczna", "poza ustawą", "partnerstwo innowacyjne",
    "dynamiczny system zakupów", "usługi społeczne"
  ]

  @doc """
  Returns judgements with non-normalized procedure types.
  """
  def judgements_needing_procedure_type_fix(limit \\ 100) do
    Judgement
    |> where([j], not is_nil(j.procedure_type) and j.procedure_type not in ^@normalized_procedure_types)
    |> select([j], %{id: j.id, procedure_type: j.procedure_type})
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns count of judgements needing procedure type fix.
  """
  def count_judgements_needing_procedure_type_fix do
    Judgement
    |> where([j], not is_nil(j.procedure_type) and j.procedure_type not in ^@normalized_procedure_types)
    |> Repo.aggregate(:count)
  end

  @doc """
  Updates procedure type by judgement ID.
  """
  def update_procedure_type_by_id(id, procedure_type) do
    Judgement
    |> where([j], j.id == ^id)
    |> Repo.update_all(set: [
      procedure_type: procedure_type,
      updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
    ])
    |> case do
      {1, _} -> {:ok, id}
      {0, _} -> {:error, :not_found}
    end
  end

  @doc """
  Returns all judgement IDs and updated_at for sitemap generation.
  Streams results to handle large datasets efficiently.
  """
  def stream_sitemap_entries do
    Judgement
    |> select([j], %{id: j.id, slug: j.slug, updated_at: j.updated_at})
    |> where([j], not is_nil(j.slug))
    |> order_by(desc: :updated_at)
    |> Repo.stream()
  end
end
