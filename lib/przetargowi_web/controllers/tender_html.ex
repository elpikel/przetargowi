defmodule PrzetargowiWeb.TenderHTML do
  use PrzetargowiWeb, :html

  embed_templates "tender_html/*"

  @region_options [
    {"dolnoslaskie", "Dolnośląskie"},
    {"kujawsko-pomorskie", "Kujawsko-pomorskie"},
    {"lubelskie", "Lubelskie"},
    {"lubuskie", "Lubuskie"},
    {"lodzkie", "Łódzkie"},
    {"malopolskie", "Małopolskie"},
    {"mazowieckie", "Mazowieckie"},
    {"opolskie", "Opolskie"},
    {"podkarpackie", "Podkarpackie"},
    {"podlaskie", "Podlaskie"},
    {"pomorskie", "Pomorskie"},
    {"slaskie", "Śląskie"},
    {"swietokrzyskie", "Świętokrzyskie"},
    {"warminsko-mazurskie", "Warmińsko-mazurskie"},
    {"wielkopolskie", "Wielkopolskie"},
    {"zachodniopomorskie", "Zachodniopomorskie"}
  ]

  @order_type_options [
    {"Delivery", "Dostawy"},
    {"Services", "Usługi"},
    {"Works", "Roboty budowlane"}
  ]

  def region_options, do: @region_options
  def order_type_options, do: @order_type_options

  def format_date(nil), do: "Brak daty"

  def format_date(%DateTime{} = datetime) do
    Calendar.strftime(datetime, "%d.%m.%Y")
  end

  def format_date(%Date{} = date) do
    Calendar.strftime(date, "%d.%m.%Y")
  end

  def format_datetime(nil), do: "Brak daty"

  def format_datetime(%DateTime{} = datetime) do
    Calendar.strftime(datetime, "%d.%m.%Y %H:%M")
  end

  def format_value(nil), do: "-"

  def format_value(value) do
    value
    |> Decimal.round(0)
    |> Decimal.to_string()
    |> String.replace(~r/(\d)(?=(\d{3})+(?!\d))/, "\\1 ")
    |> Kernel.<>(" PLN")
  end

  def format_order_type("Delivery"), do: "Dostawy"
  def format_order_type("Services"), do: "Usługi"
  def format_order_type("Works"), do: "Roboty budowlane"
  def format_order_type(nil), do: "-"
  def format_order_type(other), do: other

  def format_notice_type("ContractNotice"), do: "Ogłoszenie o zamówieniu"
  def format_notice_type("AgreementIntentionNotice"), do: "Ogłoszenie o zamiarze zawarcia umowy"
  def format_notice_type("TenderResultNotice"), do: "Ogłoszenie o wyniku postępowania"
  def format_notice_type("CompetitionNotice"), do: "Ogłoszenie o konkursie"
  def format_notice_type("CompetitionResultNotice"), do: "Ogłoszenie o wynikach konkursu"
  def format_notice_type("NoticeUpdateNotice"), do: "Ogłoszenie o zmianie ogłoszenia"
  def format_notice_type("AgreementUpdateNotice"), do: "Ogłoszenie o zmianie umowy"
  def format_notice_type("ContractPerformingNotice"), do: "Ogłoszenie o wykonaniu umowy"
  def format_notice_type("CircumstancesFulfillmentNotice"), do: "Ogłoszenie o spełnieniu okoliczności"
  def format_notice_type("SmallContractNotice"), do: "Ogłoszenie o zamówieniu bagatelnym"
  def format_notice_type(nil), do: "-"
  def format_notice_type(other), do: other

  def format_client_type("AAH"), do: "Administracja rządowa terenowa"
  def format_client_type("AAN"), do: "Administracja rządowa centralna"
  def format_client_type("ASI"), do: "Agencje wykonawcze"
  def format_client_type("INP"), do: "Inne podmioty"
  def format_client_type("JST"), do: "Jednostka samorządu terytorialnego"
  def format_client_type("NZO"), do: "Narodowy Fundusz Zdrowia"
  def format_client_type("ORG"), do: "Organy kontroli państwowej"
  def format_client_type("SPP"), do: "Spółki Skarbu Państwa"
  def format_client_type("UCZ"), do: "Uczelnie publiczne"
  def format_client_type("ZOZ"), do: "Zakłady opieki zdrowotnej"
  def format_client_type(nil), do: "-"
  def format_client_type(other), do: other

  def format_status("Active"), do: "Aktywne"
  def format_status("Cancelled"), do: "Unieważnione"
  def format_status("Completed"), do: "Zakończone"
  def format_status(nil), do: "-"
  def format_status(other), do: other

  def format_region_name(nil), do: "Polska"

  def format_region_name(region) do
    region_map = Map.new(@region_options)
    Map.get(region_map, region, region)
  end

  def format_province_name(nil), do: "-"

  def format_province_name(province_code) do
    province_map = %{
      "PL02" => "Dolnośląskie",
      "PL04" => "Kujawsko-pomorskie",
      "PL06" => "Lubelskie",
      "PL08" => "Lubuskie",
      "PL10" => "Łódzkie",
      "PL12" => "Małopolskie",
      "PL14" => "Mazowieckie",
      "PL16" => "Opolskie",
      "PL18" => "Podkarpackie",
      "PL20" => "Podlaskie",
      "PL22" => "Pomorskie",
      "PL24" => "Śląskie",
      "PL26" => "Świętokrzyskie",
      "PL28" => "Warmińsko-mazurskie",
      "PL30" => "Wielkopolskie",
      "PL32" => "Zachodniopomorskie"
    }

    Map.get(province_map, province_code, province_code)
  end

  def truncate(nil, _length), do: ""
  def truncate(string, length) when byte_size(string) <= length, do: string

  def truncate(string, length) do
    String.slice(string, 0, length) <> "..."
  end

  def days_until_deadline(nil), do: nil

  def days_until_deadline(%DateTime{} = deadline) do
    now = DateTime.utc_now()
    diff = DateTime.diff(deadline, now, :day)

    cond do
      diff < 0 -> nil
      diff == 0 -> "Dziś"
      diff == 1 -> "Jutro"
      diff <= 7 -> "#{diff} dni"
      true -> nil
    end
  end

  def is_urgent?(nil), do: false

  def is_urgent?(%DateTime{} = deadline) do
    now = DateTime.utc_now()
    diff = DateTime.diff(deadline, now, :day)
    diff >= 0 and diff <= 3
  end

  def build_pagination_params(query, regions, order_types, page) do
    params = []
    params = if query && query != "", do: [{"q", query} | params], else: params
    params = params ++ Enum.map(regions, &{"regions[]", &1})
    params = params ++ Enum.map(order_types, &{"order_types[]", &1})
    params = [{"page", page} | params]
    params
  end

  def build_alert_params(query, regions, order_types) do
    params = []
    params = if query && query != "", do: [{"keywords", query} | params], else: params
    params = params ++ Enum.map(regions, &{"regions[]", &1})
    params = params ++ Enum.map(order_types, &{"order_types[]", &1})
    params
  end

  def province_to_region(nil), do: ""

  def province_to_region(province_code) do
    province_map = %{
      "PL02" => "dolnoslaskie",
      "PL04" => "kujawsko-pomorskie",
      "PL06" => "lubelskie",
      "PL08" => "lubuskie",
      "PL10" => "lodzkie",
      "PL12" => "malopolskie",
      "PL14" => "mazowieckie",
      "PL16" => "opolskie",
      "PL18" => "podkarpackie",
      "PL20" => "podlaskie",
      "PL22" => "pomorskie",
      "PL24" => "slaskie",
      "PL26" => "swietokrzyskie",
      "PL28" => "warminsko-mazurskie",
      "PL30" => "wielkopolskie",
      "PL32" => "zachodniopomorskie"
    }

    Map.get(province_map, province_code, "")
  end
end
