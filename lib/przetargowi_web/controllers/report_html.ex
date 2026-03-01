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

  def build_pagination_params(query, page) do
    params = [{"page", page}]
    if query && query != "", do: [{"q", query} | params], else: params
  end
end
