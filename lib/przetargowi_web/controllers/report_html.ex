defmodule PrzetargowiWeb.ReportHTML do
  use PrzetargowiWeb, :html

  embed_templates "report_html/*"

  def format_order_type("Delivery"), do: "Dostawy"
  def format_order_type("Services"), do: "Usługi"
  def format_order_type("Works"), do: "Roboty budowlane"
  def format_order_type(nil), do: "Wszystkie kategorie"
  def format_order_type(other), do: other

  def format_region_name(nil), do: "Polska"

  def format_region_name(region) do
    region_map = %{
      "dolnoslaskie" => "Dolnośląskie",
      "kujawsko-pomorskie" => "Kujawsko-pomorskie",
      "lubelskie" => "Lubelskie",
      "lubuskie" => "Lubuskie",
      "lodzkie" => "Łódzkie",
      "malopolskie" => "Małopolskie",
      "mazowieckie" => "Mazowieckie",
      "opolskie" => "Opolskie",
      "podkarpackie" => "Podkarpackie",
      "podlaskie" => "Podlaskie",
      "pomorskie" => "Pomorskie",
      "slaskie" => "Śląskie",
      "swietokrzyskie" => "Świętokrzyskie",
      "warminsko-mazurskie" => "Warmińsko-mazurskie",
      "wielkopolskie" => "Wielkopolskie",
      "zachodniopomorskie" => "Zachodniopomorskie"
    }

    Map.get(region_map, region, region)
  end

  def format_report_date(date) do
    months = [
      "styczeń",
      "luty",
      "marzec",
      "kwiecień",
      "maj",
      "czerwiec",
      "lipiec",
      "sierpień",
      "wrzesień",
      "październik",
      "listopad",
      "grudzień"
    ]

    month_name = Enum.at(months, date.month - 1)
    "#{month_name} #{date.year}"
  end

  def build_pagination_params(query, filters, page) do
    params = [{"page", page}]

    params =
      if query && query != "", do: [{"q", query} | params], else: params

    params
    |> maybe_add_filter("region", filters.region)
    |> maybe_add_filter("report_type", filters.report_type)
    |> maybe_add_filter("year", filters.year)
    |> maybe_add_filter("month", filters.month)
    |> maybe_add_filter("order_type", filters.order_type)
  end

  defp maybe_add_filter(params, _key, nil), do: params
  defp maybe_add_filter(params, _key, ""), do: params
  defp maybe_add_filter(params, key, value), do: [{key, value} | params]

  def format_report_type("detailed"), do: "Szczegółowy"
  def format_report_type("region_summary"), do: "Podsumowanie regionu"
  def format_report_type("industry_summary"), do: "Podsumowanie branży"
  def format_report_type("overall"), do: "Ogólny"
  def format_report_type(other), do: other

  def format_month_name(1), do: "Styczeń"
  def format_month_name(2), do: "Luty"
  def format_month_name(3), do: "Marzec"
  def format_month_name(4), do: "Kwiecień"
  def format_month_name(5), do: "Maj"
  def format_month_name(6), do: "Czerwiec"
  def format_month_name(7), do: "Lipiec"
  def format_month_name(8), do: "Sierpień"
  def format_month_name(9), do: "Wrzesień"
  def format_month_name(10), do: "Październik"
  def format_month_name(11), do: "Listopad"
  def format_month_name(12), do: "Grudzień"
  def format_month_name(_), do: ""
end
