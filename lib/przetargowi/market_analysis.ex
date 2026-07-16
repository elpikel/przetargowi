defmodule Przetargowi.MarketAnalysis do
  @moduledoc """
  Context module for market analysis dashboard.
  Aggregates tender data by CPV code and region.
  """

  import Ecto.Query

  alias Przetargowi.Repo
  alias Przetargowi.Tenders.TenderNotice

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
  Returns full market analysis for given CPV prefix and optional province.
  """
  def analyze(cpv_prefix, province \\ nil) do
    tenders = fetch_closed_tenders(cpv_prefix, province)
    contracts = extract_signed_contracts(tenders)
    open_tenders = fetch_open_tenders(cpv_prefix, province)

    %{
      total_tenders: length(tenders),
      total_contracts: length(contracts),
      total_open: length(open_tenders),
      price_distribution: compute_price_distribution(contracts),
      criteria: compute_criteria(open_tenders),
      top_contractors: compute_top_contractors(contracts),
      top_ordering_parties: compute_top_ordering_parties(tenders),
      trends: compute_monthly_trends(tenders),
      best_segments: compute_best_segments(tenders)
    }
  end

  defp fetch_closed_tenders(cpv_prefix, province) do
    cpv_like = cpv_prefix <> "%"

    TenderNotice
    |> from(as: :tn)
    |> where([tn: tn], tn.notice_type in ^@closed_notice_types)
    |> where([tn: tn], like(tn.cpv_main, ^cpv_like))
    |> order_by([tn: tn], desc: tn.publication_date)
    |> limit(1000)
    |> maybe_filter_province(province)
    |> Repo.all()
  end

  defp fetch_open_tenders(cpv_prefix, province) do
    cpv_like = cpv_prefix <> "%"

    TenderNotice
    |> from(as: :tn)
    |> where([tn: tn], tn.notice_type == "ContractNotice")
    |> where([tn: tn], like(tn.cpv_main, ^cpv_like))
    |> limit(1000)
    |> maybe_filter_province(province)
    |> Repo.all()
  end

  defp maybe_filter_province(query, nil), do: query
  defp maybe_filter_province(query, ""), do: query

  defp maybe_filter_province(query, province) do
    where(query, [tn: tn], tn.organization_province == ^province)
  end

  defp extract_signed_contracts(tenders) do
    tenders
    |> Enum.flat_map(fn tender ->
      (tender.contractors_contract_details || [])
      |> Enum.filter(&(&1.status == :contract_signed))
      |> Enum.map(&Map.put(&1, :_tender, tender))
    end)
  end

  defp compute_price_distribution(contracts) do
    prices =
      contracts
      |> Enum.flat_map(fn c ->
        [c.winning_price, c.contract_value]
        |> Enum.filter(&(&1 != nil && Decimal.gt?(&1, Decimal.new(0))))
      end)
      |> Enum.map(&Decimal.to_float/1)
      |> Enum.uniq()
      |> Enum.sort()

    if prices == [] do
      %{buckets: [], labels: [], min: nil, max: nil, median: nil, avg: nil, count: 0}
    else
      count = length(prices)

      %{
        buckets: build_buckets(prices, min(8, count)) |> Enum.map(& &1.count),
        labels: build_buckets(prices, min(8, count)) |> Enum.map(& &1.label),
        min: List.first(prices),
        max: List.last(prices),
        median: Enum.at(prices, div(count, 2)),
        avg: Enum.sum(prices) / count,
        count: count
      }
    end
  end

  defp build_buckets(_prices, num_buckets) when num_buckets < 1, do: []

  defp build_buckets(prices, _num_buckets) do
    min_val = List.first(prices)
    max_val = List.last(prices)

    if min_val == max_val do
      [%{label: format_pln(min_val), count: length(prices)}]
    else
      num_buckets = min(8, length(prices))
      step = (max_val - min_val) / num_buckets

      Enum.map(0..(num_buckets - 1), fn i ->
        lower = min_val + step * i
        upper = min_val + step * (i + 1)

        count =
          Enum.count(prices, fn p ->
            if i == num_buckets - 1, do: p >= lower && p <= upper, else: p >= lower && p < upper
          end)

        label = "#{format_pln(lower)} - #{format_pln(upper)}"
        %{label: label, count: count}
      end)
    end
  end

  defp compute_criteria(open_tenders) do
    all_criteria =
      open_tenders
      |> Enum.flat_map(&(&1.kryteria || []))
      |> Enum.filter(&(is_map(&1) && &1["name"]))

    if all_criteria == [] do
      %{price_only_pct: nil, top_criteria: [], total_tenders_with_criteria: 0}
    else
      tenders_with_criteria =
        open_tenders
        |> Enum.filter(fn t -> (t.kryteria || []) != [] end)

      price_only =
        tenders_with_criteria
        |> Enum.count(fn t ->
          criteria = t.kryteria || []
          length(criteria) == 1 && String.downcase(List.first(criteria)["name"] || "") =~ "cena"
        end)

      price_only_pct =
        if tenders_with_criteria != [] do
          Float.round(price_only / length(tenders_with_criteria) * 100, 1)
        else
          0.0
        end

      top_criteria =
        all_criteria
        |> Enum.map(fn k ->
          name = (k["name"] || "") |> String.trim() |> String.downcase()
          weight = k["weight"]
          {name, weight}
        end)
        |> Enum.filter(fn {name, _} -> name != "" end)
        |> Enum.group_by(fn {name, _} -> normalize_criterion_name(name) end)
        |> Enum.map(fn {name, entries} ->
          weights = entries |> Enum.map(&elem(&1, 1)) |> Enum.filter(&(&1 != nil))

          avg_weight =
            if weights != [], do: Float.round(Enum.sum(weights) / length(weights), 1), else: nil

          %{name: name, count: length(entries), avg_weight: avg_weight}
        end)
        |> Enum.sort_by(& &1.count, :desc)
        |> Enum.take(10)

      %{
        price_only_pct: price_only_pct,
        top_criteria: top_criteria,
        total_tenders_with_criteria: length(tenders_with_criteria)
      }
    end
  end

  defp normalize_criterion_name(name) do
    cond do
      name =~ "cena" -> "Cena"
      name =~ "gwaranc" -> "Gwarancja"
      name =~ "termin" -> "Termin realizacji"
      name =~ "doswiadcz" or name =~ "doświadcz" -> "Doświadczenie"
      name =~ "jako" -> "Jakość"
      name =~ "okres" and name =~ "gwar" -> "Okres gwarancji"
      true -> String.capitalize(name)
    end
  end

  defp compute_top_contractors(contracts) do
    contracts
    |> Enum.filter(fn c -> c.contractor_name != nil && c.contractor_name != "" end)
    |> Enum.group_by(fn c ->
      cond do
        c.contractor_nip && c.contractor_nip != "" -> normalize_nip(c.contractor_nip)
        true -> normalize_name(c.contractor_name)
      end
    end)
    |> Enum.map(fn {_key, group} ->
      # Pick the most common name variant as display name
      {name, city} = pick_display_name(group, :contractor_name, :contractor_city)

      prices =
        group
        |> Enum.flat_map(fn c -> [c.winning_price, c.contract_value] end)
        |> Enum.filter(&(&1 != nil && Decimal.gt?(&1, Decimal.new(0))))

      total_value =
        if prices != [],
          do: prices |> Enum.reduce(Decimal.new(0), &Decimal.add/2) |> Decimal.to_float(),
          else: nil

      %{name: name, city: city, wins: length(group), total_value: total_value}
    end)
    |> Enum.sort_by(& &1.wins, :desc)
    |> Enum.take(15)
  end

  defp compute_top_ordering_parties(tenders) do
    tenders
    |> Enum.filter(& &1.organization_name)
    |> Enum.group_by(fn t -> normalize_name(t.organization_name) end)
    |> Enum.map(fn {_key, group} ->
      {name, city} = pick_display_name(group, :organization_name, :organization_city)
      %{name: name, city: city, count: length(group)}
    end)
    |> Enum.sort_by(& &1.count, :desc)
    |> Enum.take(15)
  end

  defp normalize_name(name) when is_binary(name) do
    name
    |> String.downcase()
    |> String.replace(~r/\s+/, " ")
    |> String.replace(~r/["""„]/, "")
    |> String.replace(~r/sp\.\s*z\s*o\.?\s*o\.?/, "")
    |> String.replace(
      ~r/sp[oó][łl]ka\s*(z\s*ograniczon[aą]\s*odpowiedzialno[sś]ci[aą]?|akcyjna|komandytowa|komandytowo-akcyjna|cywilna|jawna)/,
      ""
    )
    |> String.replace(~r/\s*s\.?\s*a\.?\s*$/, "")
    |> String.trim()
  end

  defp normalize_name(_), do: ""

  defp normalize_nip(nip) do
    nip
    |> String.replace(~r/[^0-9]/, "")
    |> String.trim()
  end

  defp pick_display_name(group, name_field, city_field) do
    # Pick the most frequent name variant
    name =
      group
      |> Enum.map(&Map.get(&1, name_field))
      |> Enum.filter(& &1)
      |> Enum.frequencies()
      |> Enum.max_by(&elem(&1, 1), fn -> {nil, 0} end)
      |> elem(0)

    city =
      group
      |> Enum.map(&Map.get(&1, city_field))
      |> Enum.filter(& &1)
      |> List.first()

    {name, city}
  end

  defp compute_monthly_trends(tenders) do
    tenders
    |> Enum.filter(& &1.publication_date)
    |> Enum.group_by(fn t ->
      date = DateTime.to_date(t.publication_date)
      "#{date.year}-#{String.pad_leading(Integer.to_string(date.month), 2, "0")}"
    end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.take(-12)
    |> Enum.map(fn {month, group} ->
      %{month: month, count: length(group)}
    end)
  end

  defp compute_best_segments(tenders) do
    tenders
    |> Enum.group_by(& &1.order_type)
    |> Enum.map(fn {order_type, group} ->
      contracts =
        group
        |> Enum.flat_map(fn t ->
          (t.contractors_contract_details || [])
          |> Enum.filter(&(&1.status == :contract_signed))
        end)

      %{
        order_type: translate_order_type(order_type),
        tender_count: length(group),
        contract_count: length(contracts)
      }
    end)
    |> Enum.sort_by(& &1.tender_count, :desc)
  end

  @doc false
  def translate_order_type("Works"), do: "Roboty budowlane"
  def translate_order_type("Services"), do: "Usługi"
  def translate_order_type("Delivery"), do: "Dostawy"
  def translate_order_type(nil), do: "Nieokreślone"
  def translate_order_type(other), do: other

  defp format_pln(value) when is_float(value) and value >= 1_000_000 do
    "#{Float.round(value / 1_000_000, 1)}M"
  end

  defp format_pln(value) when is_float(value) and value >= 1_000 do
    "#{Float.round(value / 1_000, 0)}K"
  end

  defp format_pln(value) when is_number(value), do: "#{round(value)}"
  defp format_pln(_), do: "-"

  @doc """
  Returns the list of province codes with Polish names.
  """
  def provinces do
    [
      {"", "Cała Polska"},
      {"PL02", "Dolnośląskie"},
      {"PL04", "Kujawsko-pomorskie"},
      {"PL06", "Lubelskie"},
      {"PL08", "Lubuskie"},
      {"PL10", "Łódzkie"},
      {"PL12", "Małopolskie"},
      {"PL14", "Mazowieckie"},
      {"PL16", "Opolskie"},
      {"PL18", "Podkarpackie"},
      {"PL20", "Podlaskie"},
      {"PL22", "Pomorskie"},
      {"PL24", "Śląskie"},
      {"PL26", "Świętokrzyskie"},
      {"PL28", "Warmińsko-mazurskie"},
      {"PL30", "Wielkopolskie"},
      {"PL32", "Zachodniopomorskie"}
    ]
  end
end
