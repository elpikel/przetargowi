defmodule PrzetargowiWeb.UserSettingsHTML do
  use PrzetargowiWeb, :html

  embed_templates "user_settings_html/*"

  @plan_names %{
    "alert" => "Alerty",
    "wyszukiwarka" => "Wyszukiwarka",
    "razem" => "Razem"
  }

  @regions %{
    "02" => "Dolnośląskie",
    "04" => "Kujawsko-Pomorskie",
    "06" => "Lubelskie",
    "08" => "Lubuskie",
    "10" => "Łódzkie",
    "12" => "Małopolskie",
    "14" => "Mazowieckie",
    "16" => "Opolskie",
    "18" => "Podkarpackie",
    "20" => "Podlaskie",
    "22" => "Pomorskie",
    "24" => "Śląskie",
    "26" => "Świętokrzyskie",
    "28" => "Warmińsko-Mazurskie",
    "30" => "Wielkopolskie",
    "32" => "Zachodniopomorskie"
  }

  @categories %{
    "uslugi" => "Usługi",
    "dostawy" => "Dostawy",
    "roboty_budowlane" => "Roboty budowlane"
  }

  def format_plan_name(plan_type), do: Map.get(@plan_names, plan_type, "Nieznany plan")

  def format_region(region_code), do: Map.get(@regions, region_code, region_code)

  def format_category(category_code), do: Map.get(@categories, category_code, category_code)
end
