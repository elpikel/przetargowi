defmodule PrzetargowiWeb.AlertHTML do
  use PrzetargowiWeb, :html

  embed_templates "alert_html/*"

  def format_region(nil), do: "Wszystkie regiony"

  def format_region(region) do
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

  def format_category(nil), do: "Wszystkie kategorie"
  def format_category(category), do: category

  @regions [
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

  @categories [
    {"Dostawy", "Dostawy"},
    {"Usługi", "Usługi"},
    {"Roboty budowlane", "Roboty budowlane"}
  ]

  def region_options, do: @regions
  def category_options, do: @categories
end
