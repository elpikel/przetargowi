defmodule PrzetargowiWeb.ProfileHTML do
  use PrzetargowiWeb, :html

  import PrzetargowiWeb.CoreComponents

  embed_templates "profile_html/*"

  alias Przetargowi.Profiles.CompanyProfile

  attr :form, :map, required: true

  def profile_form(assigns) do
    ~H"""
    <._form form={@form} />
    """
  end

  @voivodeships [
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

  def voivodeship_options, do: @voivodeships

  def format_voivodeship(key) do
    case Enum.find(@voivodeships, fn {k, _} -> k == key end) do
      {_, label} -> label
      nil -> key
    end
  end

  def legal_form_options do
    Enum.map(CompanyProfile.legal_forms(), fn form ->
      {form, format_legal_form(form)}
    end)
  end

  def format_legal_form(:osoba_fizyczna), do: "Osoba fizyczna prowadząca działalność"
  def format_legal_form(:spolka_cywilna), do: "Spółka cywilna"
  def format_legal_form(:sp_z_oo), do: "Spółka z o.o."
  def format_legal_form(:spolka_akcyjna), do: "Spółka akcyjna"
  def format_legal_form(:jednoosobowa_dg), do: "Jednoosobowa działalność gospodarcza"
  def format_legal_form(:other), do: "Inna"
  def format_legal_form(form), do: to_string(form)

  def msp_status_options do
    Enum.map(CompanyProfile.msp_statuses(), fn status ->
      {status, format_msp_status(status)}
    end)
  end

  def format_msp_status(:micro), do: "Mikroprzedsiębiorstwo"
  def format_msp_status(:small), do: "Małe przedsiębiorstwo"
  def format_msp_status(:medium), do: "Średnie przedsiębiorstwo"
  def format_msp_status(:large), do: "Duże przedsiębiorstwo"
  def format_msp_status(status), do: to_string(status)

  def format_representatives([]), do: "Brak"

  def format_representatives(representatives) do
    representatives
    |> Enum.map(fn rep ->
      if rep.is_primary do
        "#{rep.full_name} (#{rep.position}) - główny"
      else
        "#{rep.full_name} (#{rep.position})"
      end
    end)
    |> Enum.join(", ")
  end
end
