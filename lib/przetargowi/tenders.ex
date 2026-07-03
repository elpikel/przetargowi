defmodule Przetargowi.Tenders do
  @moduledoc """
  Context module for managing tenders.
  """

  import Ecto.Query

  alias Przetargowi.Repo
  alias Przetargowi.Tenders.BzpParser
  alias Przetargowi.Tenders.CpvWinnerAnalysis
  alias Przetargowi.Tenders.TenderDocument
  alias Przetargowi.Tenders.TenderNotice

  require Logger

  @doc """
  Gets the last inserted tender notice's object_id for the given notice type.
  """
  def get_last_object_id_by_notice_type(notice_type) do
    TenderNotice
    |> from(as: :tender_notice)
    |> where([tender_notice: tn], tn.notice_type == ^notice_type)
    |> order_by([tender_notice: tn], desc: tn.inserted_at)
    |> limit(1)
    |> select([tender_notice: tn], tn.object_id)
    |> Repo.one()
  end

  @doc """
  Gets a single tender notice by ID.
  """
  def get_tender_notice(id), do: Repo.get_by(TenderNotice, object_id: id)

  @doc """
  Gets a single tender notice by slug.
  """
  def get_tender_by_slug(slug), do: Repo.get_by(TenderNotice, slug: slug)

  @doc """
  Gets a single tender notice by BZP number.
  """
  def get_tender_by_bzp_number(bzp_number), do: Repo.get_by(TenderNotice, bzp_number: bzp_number)

  @doc """
  Gets the original contract notice for a given tender_id.
  """
  def get_contract_notice_by_tender_id(nil), do: nil

  def get_contract_notice_by_tender_id(tender_id) do
    TenderNotice
    |> from(as: :tender_notice)
    |> where([tender_notice: tn], tn.tender_id == ^tender_id)
    |> where([tender_notice: tn], tn.notice_type == "ContractNotice")
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Returns all notices that belong to the same procurement (same tender_id),
  ordered by publication date. A single procurement can have several notices
  (e.g. ContractNotice + TenderResultNotice) that we merge onto one page.
  """
  def get_notices_by_tender_id(nil), do: []

  def get_notices_by_tender_id(tender_id) do
    TenderNotice
    |> from(as: :tender_notice)
    |> where([tender_notice: tn], tn.tender_id == ^tender_id)
    |> order_by([tender_notice: tn], asc: tn.publication_date)
    |> Repo.all()
  end

  @doc """
  Picks the canonical notice for a procurement from a list of its notices.

  The ContractNotice is preferred (published first, richest details, stable
  URL across the tender lifecycle); otherwise the earliest by publication date.
  This is the notice whose slug owns the public URL — all other notices for the
  same tender_id 301-redirect to it.
  """
  def canonical_notice([]), do: nil

  def canonical_notice(notices) when is_list(notices) do
    Enum.find(notices, &(&1.notice_type == "ContractNotice")) ||
      Enum.min_by(notices, & &1.publication_date, DateTime)
  end

  @doc """
  Finds the notice carrying result/award data (contractors and contract
  details) among a procurement's notices, or nil if none is resolved yet.
  """
  def find_result_notice(notices) when is_list(notices) do
    Enum.find(notices, fn notice ->
      (notice.contractors_contract_details || []) != [] or (notice.contractors || []) != []
    end)
  end

  @doc """
  Searches tender notices with optional filters.

  ## Options
    * `:query` - text search in order_object and organization_name
    * `:regions` - list of regions to filter by (or single region string for backwards compatibility)
    * `:order_types` - list of order types (Delivery, Services, Works) or single string
    * `:notice_type` - filter by notice type (default: ContractNotice)
    * `:deadline_from` - filter tenders with deadline on or after this date (Date)
    * `:deadline_to` - filter tenders with deadline on or before this date (Date)
    * `:page` - page number (default: 1)
    * `:per_page` - results per page (default: 20)
  """
  def search_tender_notices(opts \\ []) do
    query = Keyword.get(opts, :query)
    regions = normalize_to_list(Keyword.get(opts, :regions))
    order_types = normalize_to_list(Keyword.get(opts, :order_types))
    cpv_prefixes = normalize_to_list(Keyword.get(opts, :cpv_prefixes))
    deadline_from = Keyword.get(opts, :deadline_from)
    deadline_to = Keyword.get(opts, :deadline_to)
    with_winner_analysis = Keyword.get(opts, :with_winner_analysis, false)
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    offset = (page - 1) * per_page

    # Default: only show future tenders unless deadline_from is specified
    min_deadline =
      if deadline_from do
        DateTime.new!(deadline_from, ~T[00:00:00], "Etc/UTC")
      else
        DateTime.utc_now()
      end

    base_query =
      TenderNotice
      |> from(as: :tender_notice)
      |> where([tender_notice: tn], tn.submitting_offers_date >= ^min_deadline)

    base_query =
      if deadline_to do
        max_deadline = DateTime.new!(deadline_to, ~T[23:59:59], "Etc/UTC")
        where(base_query, [tender_notice: tn], tn.submitting_offers_date <= ^max_deadline)
      else
        base_query
      end

    base_query =
      if query && query != "" do
        search_term = "%#{query}%"

        where(
          base_query,
          [tender_notice: tn],
          ilike(tn.order_object, ^search_term) or
            ilike(tn.organization_name, ^search_term) or
            ilike(tn.opis_przedmiotu, ^search_term)
        )
      else
        base_query
      end

    base_query =
      if regions == [] do
        base_query
      else
        province_codes = regions |> Enum.map(&region_to_province_code/1) |> Enum.filter(& &1)
        where(base_query, [tender_notice: tn], tn.organization_province in ^province_codes)
      end

    base_query =
      if order_types == [] do
        base_query
      else
        where(base_query, [tender_notice: tn], tn.order_type in ^order_types)
      end

    base_query =
      if cpv_prefixes == [] do
        base_query
      else
        conditions =
          Enum.reduce(cpv_prefixes, dynamic(false), fn prefix, acc ->
            dynamic([tender_notice: tn], ^acc or ilike(tn.cpv_main, ^(prefix <> "%")))
          end)

        where(base_query, ^conditions)
      end

    base_query =
      if with_winner_analysis do
        base_query
        |> where([tender_notice: tn], not is_nil(tn.cpv_main))
        |> where(
          [tender_notice: tn],
          exists(
            from(cwa in CpvWinnerAnalysis,
              where:
                cwa.cpv_main ==
                  fragment(
                    "substring(? from 1 for 10)",
                    parent_as(:tender_notice).cpv_main
                  ) and
                  cwa.order_type == coalesce(parent_as(:tender_notice).order_type, ""),
              select: 1
            )
          )
        )
      else
        base_query
      end

    total_count =
      base_query
      |> select([tender_notice: tn], count(tn.object_id))
      |> Repo.one()

    notices =
      base_query
      |> order_by([tender_notice: tn], asc: tn.submitting_offers_date)
      |> limit(^per_page)
      |> offset(^offset)
      |> Repo.all()

    total_pages = ceil(total_count / per_page)

    %{
      notices: notices,
      total_count: total_count,
      page: page,
      per_page: per_page,
      total_pages: total_pages
    }
  end

  defp normalize_to_list(nil), do: []
  defp normalize_to_list(""), do: []
  defp normalize_to_list(list) when is_list(list), do: Enum.filter(list, &(&1 != "" && &1 != nil))
  defp normalize_to_list(value) when is_binary(value), do: [value]

  defp region_to_province_code(region) do
    case region do
      "dolnoslaskie" -> "PL02"
      "kujawsko-pomorskie" -> "PL04"
      "lubelskie" -> "PL06"
      "lubuskie" -> "PL08"
      "lodzkie" -> "PL10"
      "malopolskie" -> "PL12"
      "mazowieckie" -> "PL14"
      "opolskie" -> "PL16"
      "podkarpackie" -> "PL18"
      "podlaskie" -> "PL20"
      "pomorskie" -> "PL22"
      "slaskie" -> "PL24"
      "swietokrzyskie" -> "PL26"
      "warminsko-mazurskie" -> "PL28"
      "wielkopolskie" -> "PL30"
      "zachodniopomorskie" -> "PL32"
      _ -> nil
    end
  end

  @doc """
  Upserts a single tender notice. Updates on conflict.
  Parses the html_body to extract additional structured data.
  """
  def upsert_tender_notice(attrs) do
    attrs =
      attrs
      |> enrich_with_parsed_data()
      |> maybe_backfill_cpv_main()

    %TenderNotice{}
    |> TenderNotice.changeset(attrs)
    |> Repo.insert(
      on_conflict: :replace_all,
      conflict_target: [:object_id]
    )
  end

  # Parse HTML body and extract additional fields
  # Handle atom keys (from BZP Client)
  defp enrich_with_parsed_data(%{html_body: html_body} = attrs)
       when is_binary(html_body) and html_body != "" do
    case BzpParser.parse(html_body) do
      {:ok, parsed} ->
        Map.merge(attrs, %{
          wadium: parsed.wadium,
          wadium_amount: parsed.wadium_amount,
          kryteria: parsed.kryteria,
          okres_realizacji_from: parsed.okres_realizacji[:from],
          okres_realizacji_to: parsed.okres_realizacji[:to],
          okres_realizacji_raw: parsed.okres_realizacji[:raw],
          opis_przedmiotu: parsed.opis_przedmiotu,
          warunki_udzialu: parsed.warunki_udzialu,
          cpv_main: parsed.cpv_main,
          cpv_additional: parsed.cpv_additional,
          numer_referencyjny: parsed.numer_referencyjny,
          oferty_czesciowe: parsed.oferty_czesciowe,
          zabezpieczenie: parsed.zabezpieczenie,
          organization_email: parsed.zamawiajacy[:email],
          organization_www: parsed.zamawiajacy[:www],
          organization_regon: parsed.zamawiajacy[:regon],
          organization_street: parsed.zamawiajacy[:ulica],
          organization_postal_code: parsed.zamawiajacy[:kod_pocztowy],
          evaluation_criteria: parsed.evaluation_criteria
        })

      {:error, reason} ->
        Logger.warning(
          "Failed to parse BZP HTML for tender #{attrs[:object_id]}: #{inspect(reason)}"
        )

        attrs
    end
  end

  # Handle string keys (for backwards compatibility with tests)
  defp enrich_with_parsed_data(%{"html_body" => html_body} = attrs)
       when is_binary(html_body) and html_body != "" do
    case BzpParser.parse(html_body) do
      {:ok, parsed} ->
        Map.merge(attrs, %{
          "wadium" => parsed.wadium,
          "wadium_amount" => parsed.wadium_amount,
          "kryteria" => parsed.kryteria,
          "okres_realizacji_from" => parsed.okres_realizacji[:from],
          "okres_realizacji_to" => parsed.okres_realizacji[:to],
          "okres_realizacji_raw" => parsed.okres_realizacji[:raw],
          "opis_przedmiotu" => parsed.opis_przedmiotu,
          "warunki_udzialu" => parsed.warunki_udzialu,
          "cpv_main" => parsed.cpv_main,
          "cpv_additional" => parsed.cpv_additional,
          "numer_referencyjny" => parsed.numer_referencyjny,
          "oferty_czesciowe" => parsed.oferty_czesciowe,
          "zabezpieczenie" => parsed.zabezpieczenie,
          "organization_email" => parsed.zamawiajacy[:email],
          "organization_www" => parsed.zamawiajacy[:www],
          "organization_regon" => parsed.zamawiajacy[:regon],
          "organization_street" => parsed.zamawiajacy[:ulica],
          "organization_postal_code" => parsed.zamawiajacy[:kod_pocztowy],
          "evaluation_criteria" => parsed.evaluation_criteria
        })

      {:error, reason} ->
        Logger.warning(
          "Failed to parse BZP HTML for tender #{attrs["object_id"]}: #{inspect(reason)}"
        )

        attrs
    end
  end

  defp enrich_with_parsed_data(attrs), do: attrs

  # Backfill cpv_main from cpv_codes[0] when cpv_main is not set (e.g. for result notices)
  defp maybe_backfill_cpv_main(%{cpv_main: nil, cpv_codes: [first | _]} = attrs) do
    Map.put(attrs, :cpv_main, extract_cpv_code(first))
  end

  defp maybe_backfill_cpv_main(%{"cpv_main" => nil, "cpv_codes" => [first | _]} = attrs) do
    Map.put(attrs, "cpv_main", extract_cpv_code(first))
  end

  defp maybe_backfill_cpv_main(attrs), do: attrs

  # Extracts the CPV code from strings like "33600000-6 (Produkty farmaceutyczne)"
  defp extract_cpv_code(cpv_string) when is_binary(cpv_string) do
    cpv_string |> String.split(" ") |> hd()
  end

  defp extract_cpv_code(other), do: other

  @doc """
  Upserts multiple tender notices in bulk.
  Returns `{success_count, failed_list}`.
  """
  def upsert_tender_notices(tender_notices_attrs) when is_list(tender_notices_attrs) do
    results =
      Enum.map(tender_notices_attrs, fn attrs ->
        case upsert_tender_notice(attrs) do
          {:ok, tender_notice} ->
            {:ok, tender_notice}

          {:error, changeset} ->
            Logger.error(
              "Failed to upsert tender notice #{inspect(attrs[:object_id])}: #{inspect(changeset)}"
            )

            {:error, attrs, changeset}
        end
      end)

    success_count = Enum.count(results, &match?({:ok, _}, &1))
    failed = Enum.filter(results, &match?({:error, _, _}, &1))

    {success_count, failed}
  end

  @closed_notice_types [
    "TenderResultNotice",
    "CompetitionResultNotice",
    "AgreementIntentionNotice",
    "AgreementUpdateNotice",
    "ContractPerformingNotice",
    "CircumstancesFulfillmentNotice",
    "SmallContractNotice",
    "ConcessionAgreementNotice",
    "ConcessionUpdateAgreementNotice"
  ]

  @doc """
  Returns precomputed winner analysis for a tender's CPV main + order type + province.
  Tries regional first, falls back to national if no regional data exists.
  Returns nil if no analysis exists or tender has no cpv_main.
  """
  def get_winner_analysis(%TenderNotice{cpv_main: nil}), do: nil

  def get_winner_analysis(%TenderNotice{} = tender) do
    cpv_main = normalize_cpv_code(tender.cpv_main)
    order_type = tender.order_type || ""
    province = tender.organization_province

    regional = if province, do: fetch_analysis(cpv_main, order_type, province), else: nil
    national = fetch_analysis(cpv_main, order_type, "")

    cond do
      regional && national ->
        %{"regional" => regional, "national" => national}

      national ->
        %{"regional" => nil, "national" => national}

      true ->
        nil
    end
  end

  # Extracts the CPV code (e.g. "45000000-7") from strings that may include
  # a description suffix (e.g. "45000000-7 - Roboty budowlane").
  defp normalize_cpv_code(cpv_main) do
    cpv_main |> String.split(" ") |> List.first()
  end

  defp fetch_analysis(cpv_main, order_type, province) do
    CpvWinnerAnalysis
    |> from(as: :analysis)
    |> where([analysis: a], a.cpv_main == ^cpv_main)
    |> where([analysis: a], a.order_type == ^order_type)
    |> where([analysis: a], a.province == ^province)
    |> Repo.one()
    |> case do
      nil -> nil
      analysis -> analysis.data
    end
  end

  @doc """
  Returns distinct cpv_main + order_type + province combinations from closed tender notices.
  Used by the ComputeWinnerAnalyses worker to know what to compute.
  """
  def list_cpv_order_type_combos do
    TenderNotice
    |> from(as: :tender_notice)
    |> where([tender_notice: tn], tn.notice_type in ^@closed_notice_types)
    |> where([tender_notice: tn], not is_nil(tn.cpv_main))
    |> group_by([tender_notice: tn], [tn.cpv_main, tn.order_type, tn.organization_province])
    |> select([tender_notice: tn], {tn.cpv_main, tn.order_type, tn.organization_province})
    |> Repo.all()
  end

  @doc """
  Computes and stores winner analysis for a given cpv_main + order_type + province combination.
  Province is nil or "" for national (all-province) analysis.
  Called by the ComputeWinnerAnalyses worker.
  """
  def compute_and_store_winner_analysis(cpv_main, order_type, province \\ nil) do
    base_query =
      TenderNotice
      |> from(as: :tender_notice)
      |> where([tender_notice: tn], tn.cpv_main == ^cpv_main)
      |> where([tender_notice: tn], tn.notice_type in ^@closed_notice_types)
      |> order_by([tender_notice: tn], desc: tn.publication_date)
      |> limit(200)

    base_query =
      if order_type do
        where(base_query, [tender_notice: tn], tn.order_type == ^order_type)
      else
        base_query
      end

    base_query =
      if province && province != "" do
        where(base_query, [tender_notice: tn], tn.organization_province == ^province)
      else
        base_query
      end

    tenders = Repo.all(base_query)

    if tenders == [] do
      :skip
    else
      data = build_winners_summary(tenders)

      %CpvWinnerAnalysis{}
      |> CpvWinnerAnalysis.changeset(%{
        cpv_main: cpv_main,
        order_type: order_type || "",
        province: province || "",
        data: serialize_analysis(data),
        computed_at: DateTime.utc_now() |> DateTime.truncate(:second)
      })
      |> Repo.insert(
        on_conflict: {:replace, [:data, :computed_at, :updated_at]},
        conflict_target: [:cpv_main, :order_type, :province]
      )
    end
  end

  defp serialize_analysis(data) do
    %{
      "total_similar_tenders" => data.total_similar_tenders,
      "top_contractors" =>
        Enum.map(data.top_contractors, fn c ->
          %{
            "name" => c.name,
            "city" => c.city,
            "win_count" => c.win_count,
            "avg_price" => decimal_to_string(c.avg_price),
            "total_value" => decimal_to_string(c.total_value)
          }
        end),
      "price_stats" => %{
        "avg" => decimal_to_string(data.price_stats.avg),
        "min" => decimal_to_string(data.price_stats.min),
        "max" => decimal_to_string(data.price_stats.max)
      },
      "recent_wins" =>
        Enum.map(data.recent_wins, fn w ->
          %{
            "tender_title" => w.tender_title,
            "tender_slug" => w.tender_slug,
            "contractor_name" => w.contractor_name,
            "winning_price" => decimal_to_string(w.winning_price),
            "contract_value" => decimal_to_string(w.contract_value),
            "publication_date" => to_string(w.publication_date)
          }
        end)
    }
  end

  defp decimal_to_string(nil), do: nil
  defp decimal_to_string(%Decimal{} = d), do: Decimal.to_string(d)

  defp build_winners_summary(tenders) do
    all_contracts =
      tenders
      |> Enum.flat_map(fn tender ->
        (tender.contractors_contract_details || [])
        |> Enum.filter(&(&1.status == :contract_signed))
        |> Enum.map(&Map.put(&1, :tender, tender))
      end)

    top_contractors =
      all_contracts
      |> Enum.group_by(fn c ->
        key = c.contractor_nip || c.contractor_name
        {key, c.contractor_name, c.contractor_city}
      end)
      |> Enum.map(fn {{_key, name, city}, contracts} ->
        prices =
          contracts
          |> Enum.map(& &1.winning_price)
          |> Enum.filter(&(&1 != nil))

        %{
          name: name,
          city: city,
          win_count: length(contracts),
          avg_price: safe_avg(prices),
          total_value:
            contracts
            |> Enum.map(& &1.contract_value)
            |> Enum.filter(&(&1 != nil))
            |> safe_sum()
        }
      end)
      |> Enum.sort_by(& &1.win_count, :desc)
      |> Enum.take(10)

    all_winning_prices =
      all_contracts
      |> Enum.map(& &1.winning_price)
      |> Enum.filter(&(&1 != nil))

    price_stats = %{
      avg: safe_avg(all_winning_prices),
      min: safe_min(all_winning_prices),
      max: safe_max(all_winning_prices)
    }

    recent_wins =
      all_contracts
      |> Enum.sort_by(fn c -> c.tender.publication_date end, {:desc, DateTime})
      |> Enum.take(10)
      |> Enum.map(fn c ->
        %{
          tender_title: c.tender.order_object,
          tender_slug: c.tender.slug,
          contractor_name: c.contractor_name,
          winning_price: c.winning_price,
          contract_value: c.contract_value,
          publication_date: c.tender.publication_date
        }
      end)

    %{
      total_similar_tenders: length(tenders),
      top_contractors: top_contractors,
      price_stats: price_stats,
      recent_wins: recent_wins
    }
  end

  defp safe_avg([]), do: nil

  defp safe_avg(decimals) do
    sum = Enum.reduce(decimals, Decimal.new(0), &Decimal.add/2)
    Decimal.div(sum, Decimal.new(length(decimals)))
  end

  defp safe_sum([]), do: nil
  defp safe_sum(decimals), do: Enum.reduce(decimals, Decimal.new(0), &Decimal.add/2)

  defp safe_min([]), do: nil
  defp safe_min(decimals), do: Enum.min(decimals, &(Decimal.compare(&1, &2) != :gt))

  defp safe_max([]), do: nil
  defp safe_max(decimals), do: Enum.max(decimals, &(Decimal.compare(&1, &2) != :lt))

  # Document functions

  @doc """
  Gets all documents for a tender by tender_id.
  """
  def get_documents_by_tender_id(tender_id) do
    TenderDocument
    |> from(as: :document)
    |> where([document: d], d.tender_id == ^tender_id)
    |> where([document: d], d.state == "Published")
    |> order_by([document: d], asc: d.published_date)
    |> Repo.all()
  end

  @doc """
  Upserts a single tender document. Updates on conflict.
  """
  def upsert_tender_document(attrs) do
    %TenderDocument{}
    |> TenderDocument.changeset(attrs)
    |> Repo.insert(
      on_conflict: :replace_all,
      conflict_target: [:object_id]
    )
  end

  @doc """
  Upserts multiple tender documents in bulk.
  Returns `{success_count, failed_list}`.
  """
  def upsert_tender_documents(documents_attrs) when is_list(documents_attrs) do
    results =
      Enum.map(documents_attrs, fn attrs ->
        case upsert_tender_document(attrs) do
          {:ok, document} ->
            {:ok, document}

          {:error, changeset} ->
            errors =
              Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
                Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
                  opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
                end)
              end)

            Logger.error("""
            Failed to upsert tender document:
              object_id: #{inspect(attrs[:object_id])}
              tender_id: #{inspect(attrs[:tender_id])}
              name: #{inspect(attrs[:name])}
              file_name: #{inspect(attrs[:file_name])}
              url: #{inspect(attrs[:url])}
              errors: #{inspect(errors)}
            """)

            {:error, attrs, changeset}
        end
      end)

    success_count = Enum.count(results, &match?({:ok, _}, &1))
    failed = Enum.filter(results, &match?({:error, _, _}, &1))

    {success_count, failed}
  end

  @doc """
  Gets tender IDs that don't have any documents yet.
  Used by the document fetching worker.
  """
  def get_tender_ids_without_documents(limit \\ 100) do
    subquery =
      TenderDocument
      |> select([d], d.tender_id)
      |> distinct(true)

    TenderNotice
    |> from(as: :tender_notice)
    |> where([tender_notice: tn], tn.notice_type == "ContractNotice")
    |> where([tender_notice: tn], tn.tender_id not in subquery(subquery))
    |> where([tender_notice: tn], not is_nil(tn.tender_id))
    |> select([tender_notice: tn], tn.tender_id)
    |> order_by([tender_notice: tn], desc: tn.publication_date)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Gets fillable documents that haven't been downloaded yet.
  Only returns documents for tenders published within the last 30 days.
  Used by the document download worker.
  """
  def get_documents_to_download(limit \\ 50) do
    cutoff_date = DateTime.utc_now() |> DateTime.add(-30, :day)

    TenderDocument
    |> from(as: :doc)
    |> join(:inner, [doc: d], tn in TenderNotice,
      on: d.tender_id == tn.tender_id,
      as: :tender_notice
    )
    |> where([doc: d], is_nil(d.content) and is_nil(d.download_error))
    |> where([tender_notice: tn], tn.publication_date >= ^cutoff_date)
    |> order_by([doc: d], asc: d.inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Updates a document with downloaded content.
  """
  def update_document_content(document, content) when is_binary(content) do
    document
    |> TenderDocument.download_changeset(%{
      content: content,
      downloaded_at: DateTime.utc_now() |> DateTime.truncate(:second),
      download_error: nil
    })
    |> Repo.update()
  end

  @doc """
  Marks a document download as failed.
  """
  def mark_document_download_failed(document, error) do
    error_string =
      case error do
        e when is_binary(e) -> e
        e when is_atom(e) -> Atom.to_string(e)
        e -> inspect(e)
      end

    document
    |> TenderDocument.download_changeset(%{
      download_error: error_string,
      downloaded_at: nil
    })
    |> Repo.update()
  end

  @doc """
  Gets a document by object_id.
  """
  def get_document(object_id) do
    Repo.get(TenderDocument, object_id)
  end

  @doc """
  Removes content from documents belonging to tenders older than the specified days.
  Returns the number of documents cleaned up.
  """
  def cleanup_old_document_content(days_old \\ 30) do
    cutoff_date = DateTime.utc_now() |> DateTime.add(-days_old, :day)

    {count, _} =
      TenderDocument
      |> from(as: :doc)
      |> join(:inner, [doc: d], tn in TenderNotice,
        on: d.tender_id == tn.tender_id,
        as: :tender_notice
      )
      |> where([doc: d], not is_nil(d.content))
      |> where([tender_notice: tn], tn.publication_date < ^cutoff_date)
      |> select([doc: d], d)
      |> Repo.update_all(set: [content: nil, downloaded_at: nil])

    count
  end

  @doc """
  Resets download errors for all failed documents so they can be retried.
  Returns the number of documents reset.
  """
  def reset_failed_document_downloads do
    {count, _} =
      TenderDocument
      |> from(as: :doc)
      |> where([doc: d], not is_nil(d.download_error))
      |> Repo.update_all(set: [download_error: nil, downloaded_at: nil])

    count
  end

  @doc """
  Returns count of documents by status.
  """
  def document_download_stats do
    total =
      TenderDocument
      |> Repo.aggregate(:count)

    downloaded =
      TenderDocument
      |> where([d], not is_nil(d.content))
      |> Repo.aggregate(:count)

    failed =
      TenderDocument
      |> where([d], not is_nil(d.download_error))
      |> Repo.aggregate(:count)

    pending = total - downloaded - failed

    %{total: total, downloaded: downloaded, failed: failed, pending: pending}
  end
end
