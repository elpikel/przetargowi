defmodule PrzetargowiWeb.ReportHTML do
  use PrzetargowiWeb, :html

  embed_templates "report_html/*"

  alias Przetargowi.Tenders.Hubs

  @doc "A monthly report as a result card."
  attr :report, :map, required: true
  attr :compact, :boolean, default: false

  def report_card(assigns) do
    ~H"""
    <.result_card
      href={"/raporty/#{@report.slug}"}
      title={@report.title}
      cue="Zobacz raport"
      compact={@compact}
    >
      <:meta>
        <span>{format_report_date(@report.report_month)}</span>
      </:meta>
      <p :if={@report.meta_description} class={["text-sm", @compact && "line-clamp-3"]}>
        {@report.meta_description}
      </p>
      <div class="mt-3 flex flex-wrap gap-2">
        <.tag :if={@report.region} tone="accent">{format_region_name(@report.region)}</.tag>
        <.tag :if={@report.order_type}>{format_order_type(@report.order_type)}</.tag>
      </div>
    </.result_card>
    """
  end

  @doc "Columns for the \"browse reports\" block: every region hub plus related sections."
  def browse_columns do
    {first, second} = Enum.split(Hubs.regions(), 8)
    link = fn region -> {"/raporty/#{region.slug}", format_region_name(region.slug)} end

    [
      %{
        id: "browse-report-regions",
        title: "Raporty według województwa",
        links: Enum.map(first, link)
      },
      %{
        id: "browse-report-regions-2",
        title: "Kolejne województwa",
        links: Enum.map(second, link)
      },
      %{
        id: "browse-report-related",
        title: "Zobacz też",
        links: [
          {"/raporty", "Wszystkie raporty"},
          {"/przetargi", "Aktualne przetargi publiczne"},
          {"/analiza-rynku", "Analiza rynku — kto wygrywa przetargi"},
          {"/orzecznictwo-kio/statystyki", "Statystyki KIO"}
        ]
      }
    ]
  end

  @doc "Items for the region grid on the landing page."
  def region_items(by_region) do
    for region <- Hubs.regions() do
      count = Map.get(by_region, region.slug, 0)

      %{
        path: "/raporty/#{region.slug}",
        name: "Województwo #{region.name}",
        lead:
          "Miesięczne raporty rynku zamówień publicznych w województwie #{region.locative}" <>
            if(count > 0, do: " — #{count} w archiwum.", else: ".")
      }
    end
  end

  def region_locative(slug) do
    case Hubs.region(slug) do
      nil -> slug
      region -> region.locative
    end
  end

  def region_name(slug) do
    case Hubs.region(slug) do
      nil -> slug
      region -> region.name
    end
  end

  @landing_faqs [
    %{
      question: "Co zawiera raport przetargowy?",
      answer:
        "Raport podsumowuje jeden miesiąc na rynku zamówień publicznych w danym województwie lub rodzaju zamówienia: liczbę i wartość ogłoszonych przetargów, najaktywniejszych zamawiających, najczęstsze kategorie CPV oraz zmiany względem poprzednich okresów, z wykresami i krótką analizą."
    },
    %{
      question: "Skąd pochodzą dane w raportach?",
      answer:
        "Z ogłoszeń publikowanych w Biuletynie Zamówień Publicznych. Raporty powstają automatycznie na podstawie tych samych danych, które zasilają naszą wyszukiwarkę przetargów."
    },
    %{
      question: "Jak często publikowane są raporty?",
      answer:
        "Raz w miesiącu, na początku miesiąca, za miesiąc poprzedni — osobno dla każdego województwa oraz dla dostaw, usług i robót budowlanych."
    },
    %{
      question: "Czy raporty są bezpłatne?",
      answer: "Tak. Wszystkie raporty można przeglądać bezpłatnie i bez rejestracji."
    }
  ]

  def landing_faqs, do: @landing_faqs

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
