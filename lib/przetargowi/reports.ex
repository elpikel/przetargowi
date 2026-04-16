defmodule Przetargowi.Reports do
  @moduledoc """
  Context module for managing tender reports.
  """

  import Ecto.Query

  alias Przetargowi.Repo
  alias Przetargowi.Reports.TenderReport

  @doc """
  Returns available filter options based on existing reports.
  """
  def get_filter_options do
    regions =
      from(r in TenderReport,
        where: not is_nil(r.region),
        select: r.region,
        distinct: true,
        order_by: r.region
      )
      |> Repo.all()

    report_types =
      from(r in TenderReport,
        select: r.report_type,
        distinct: true,
        order_by: r.report_type
      )
      |> Repo.all()

    years =
      from(r in TenderReport,
        where: not is_nil(r.year),
        select: r.year,
        distinct: true,
        order_by: [desc: r.year]
      )
      |> Repo.all()

    months =
      from(r in TenderReport,
        select: fragment("EXTRACT(MONTH FROM ?)::integer", r.report_month),
        distinct: true,
        order_by: fragment("1")
      )
      |> Repo.all()

    order_types =
      from(r in TenderReport,
        where: not is_nil(r.order_type),
        select: r.order_type,
        distinct: true,
        order_by: r.order_type
      )
      |> Repo.all()

    %{
      regions: regions,
      report_types: report_types,
      years: years,
      months: months,
      order_types: order_types
    }
  end

  @doc """
  Lists tender reports with pagination and filtering.

  ## Options

    * `:page` - Page number (default: 1)
    * `:per_page` - Results per page (default: 12)
    * `:query` - Text search query
    * `:region` - Filter by region
    * `:report_type` - Filter by report type
    * `:year` - Filter by year
    * `:month` - Filter by month (1-12)
    * `:order_type` - Filter by order type
  """
  def list_tender_reports(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 12)
    offset = (page - 1) * per_page

    base_query =
      from(r in TenderReport)
      |> apply_text_filter(Keyword.get(opts, :query))
      |> apply_region_filter(Keyword.get(opts, :region))
      |> apply_report_type_filter(Keyword.get(opts, :report_type))
      |> apply_year_filter(Keyword.get(opts, :year))
      |> apply_month_filter(Keyword.get(opts, :month))
      |> apply_order_type_filter(Keyword.get(opts, :order_type))

    total_count = base_query |> select([r], count(r.id)) |> Repo.one()

    reports =
      base_query
      |> order_by([r], desc: r.report_month, asc: r.region, asc: r.order_type)
      |> limit(^per_page)
      |> offset(^offset)
      |> Repo.all()

    %{
      reports: reports,
      total_count: total_count,
      page: page,
      per_page: per_page,
      total_pages: max(ceil(total_count / per_page), 1)
    }
  end

  defp apply_text_filter(query, nil), do: query
  defp apply_text_filter(query, ""), do: query

  defp apply_text_filter(query, search_term) do
    term = "%#{search_term}%"

    from(r in query,
      where:
        ilike(r.title, ^term) or
          ilike(r.region, ^term) or
          ilike(r.meta_description, ^term)
    )
  end

  defp apply_region_filter(query, nil), do: query
  defp apply_region_filter(query, ""), do: query
  defp apply_region_filter(query, region), do: from(r in query, where: r.region == ^region)

  defp apply_report_type_filter(query, nil), do: query
  defp apply_report_type_filter(query, ""), do: query

  defp apply_report_type_filter(query, report_type),
    do: from(r in query, where: r.report_type == ^report_type)

  defp apply_year_filter(query, nil), do: query
  defp apply_year_filter(query, ""), do: query

  defp apply_year_filter(query, year) when is_binary(year) do
    case Integer.parse(year) do
      {year_int, _} -> from(r in query, where: r.year == ^year_int)
      :error -> query
    end
  end

  defp apply_year_filter(query, year) when is_integer(year),
    do: from(r in query, where: r.year == ^year)

  defp apply_month_filter(query, nil), do: query
  defp apply_month_filter(query, ""), do: query

  defp apply_month_filter(query, month) when is_binary(month) do
    case Integer.parse(month) do
      {month_int, _} ->
        from(r in query,
          where: fragment("EXTRACT(MONTH FROM ?)::integer = ?", r.report_month, ^month_int)
        )

      :error ->
        query
    end
  end

  defp apply_month_filter(query, month) when is_integer(month) do
    from(r in query,
      where: fragment("EXTRACT(MONTH FROM ?)::integer = ?", r.report_month, ^month)
    )
  end

  defp apply_order_type_filter(query, nil), do: query
  defp apply_order_type_filter(query, ""), do: query

  defp apply_order_type_filter(query, order_type),
    do: from(r in query, where: r.order_type == ^order_type)

  @doc """
  Lists tender reports filtered by region with pagination.

  ## Options

    * `:region` - Region code (required)
    * `:page` - Page number (default: 1)
    * `:per_page` - Results per page (default: 12)

  ## Returns

  A map with:
    * `:reports` - List of reports
    * `:total_count` - Total number of reports
    * `:page` - Current page
    * `:per_page` - Results per page
    * `:total_pages` - Total number of pages

  """
  def list_tender_reports_by_region(region, opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 12)
    offset = (page - 1) * per_page

    base_query = from(r in TenderReport, where: r.region == ^region)

    total_count = base_query |> select([r], count(r.id)) |> Repo.one()

    reports =
      base_query
      |> order_by([r], desc: r.report_month, asc: r.order_type)
      |> limit(^per_page)
      |> offset(^offset)
      |> Repo.all()

    %{
      reports: reports,
      total_count: total_count,
      page: page,
      per_page: per_page,
      total_pages: max(ceil(total_count / per_page), 1)
    }
  end

  @doc """
  Gets a tender report by slug.

  ## Examples

      iex> get_report_by_slug("mazowieckie-delivery-2026-01-01")
      %TenderReport{}

      iex> get_report_by_slug("nonexistent")
      nil

  """
  def get_report_by_slug(slug) when is_binary(slug) do
    Repo.get_by(TenderReport, slug: slug)
  end

  @doc """
  Gets a tender report by ID.

  ## Examples

      iex> get_report(123)
      %TenderReport{}

      iex> get_report(999)
      nil

  """
  def get_report(id) do
    Repo.get(TenderReport, id)
  end

  @doc """
  Creates or updates a tender report.

  Uses upsert logic based on the unique constraints:
  - For detailed reports: region + order_type + report_month
  - For summary reports: report_type + region/order_type + report_month

  ## Examples

      iex> upsert_report(%{title: "Report", slug: "report-slug", ...})
      {:ok, %TenderReport{}}

      iex> upsert_report(%{invalid: "data"})
      {:error, %Ecto.Changeset{}}

  """
  def upsert_report(attrs) do
    existing = find_existing_report(attrs)

    changeset =
      case existing do
        nil -> TenderReport.changeset(%TenderReport{}, attrs)
        report -> TenderReport.changeset(report, attrs)
      end

    Repo.insert_or_update(changeset)
  end

  @doc """
  Deletes a tender report.

  ## Examples

      iex> delete_report(report)
      {:ok, %TenderReport{}}

  """
  def delete_report(%TenderReport{} = report) do
    Repo.delete(report)
  end

  # Private Functions

  defp find_existing_report(%{report_type: "detailed"} = attrs) do
    Repo.get_by(TenderReport,
      region: attrs[:region],
      order_type: attrs[:order_type],
      report_month: attrs[:report_month],
      report_type: "detailed"
    )
  end

  defp find_existing_report(%{report_type: "region_summary"} = attrs) do
    Repo.one(
      from(r in TenderReport,
        where: r.region == ^attrs[:region],
        where: is_nil(r.order_type),
        where: r.report_month == ^attrs[:report_month],
        where: r.report_type == "region_summary"
      )
    )
  end

  defp find_existing_report(%{report_type: "industry_summary"} = attrs) do
    Repo.one(
      from(r in TenderReport,
        where: is_nil(r.region),
        where: r.order_type == ^attrs[:order_type],
        where: r.report_month == ^attrs[:report_month],
        where: r.report_type == "industry_summary"
      )
    )
  end

  defp find_existing_report(%{report_type: "overall"} = attrs) do
    Repo.one(
      from(r in TenderReport,
        where: is_nil(r.region),
        where: is_nil(r.order_type),
        where: r.report_month == ^attrs[:report_month],
        where: r.report_type == "overall"
      )
    )
  end

  defp find_existing_report(_attrs), do: nil

  @doc """
  Returns report slugs and updated_at for sitemap generation.
  """
  def list_sitemap_entries(limit \\ nil, offset \\ 0) do
    TenderReport
    |> select([r], %{slug: r.slug, updated_at: r.updated_at})
    |> where([r], not is_nil(r.slug))
    |> order_by([r], asc: r.id)
    |> then(fn query ->
      case limit do
        nil -> query
        n -> query |> limit(^n) |> offset(^offset)
      end
    end)
    |> Repo.all()
  end

  @doc """
  Returns the count of reports with slugs for sitemap pagination.
  """
  def count_sitemap_entries do
    TenderReport
    |> where([r], not is_nil(r.slug))
    |> Repo.aggregate(:count)
  end
end
