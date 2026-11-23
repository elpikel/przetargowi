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

  alias Przetargowi.Judgements.Topics
  alias Przetargowi.Tenders.Hubs

  @order_type_labels Map.new(@order_type_options)

  def order_type_label(order_type), do: Map.get(@order_type_labels, order_type, order_type)

  def region_label(slug) do
    case Hubs.region(slug) do
      nil -> slug
      region -> region.name
    end
  end

  @doc "A tender notice as a result card."
  attr :notice, :map, required: true
  attr :compact, :boolean, default: false
  attr :current_scope, :any, default: nil
  attr :watched_ids, :list, default: []

  def tender_card(assigns) do
    ~H"""
    <.result_card
      href={"/przetargi/#{@notice.slug}"}
      title={truncate(@notice.order_object, if(@compact, do: 110, else: 200))}
      cue="Zobacz przetarg"
      compact={@compact}
    >
      <:meta>
        <span class={is_urgent?(@notice.submitting_offers_date) && "text-error font-medium"}>
          Termin: {format_datetime(@notice.submitting_offers_date)}
        </span>
        <.tag
          :if={days_until_deadline(@notice.submitting_offers_date)}
          tone={if(is_urgent?(@notice.submitting_offers_date), do: "urgent", else: "neutral")}
        >
          {days_until_deadline(@notice.submitting_offers_date)}
        </.tag>
      </:meta>
      <p class={["text-sm", @compact && "line-clamp-2"]}>
        {@notice.organization_name}
        <span :if={@notice.organization_city} class="text-base-content/50">
          · {@notice.organization_city}, {format_province_name(@notice.organization_province)}
        </span>
      </p>
      <div class="mt-3 flex flex-wrap gap-2">
        <.tag tone="accent">{format_order_type(@notice.order_type)}</.tag>
        <.tag>{@notice.bzp_number}</.tag>
        <.tag :if={@notice.estimated_value}>{format_value(@notice.estimated_value)}</.tag>
      </div>
      <:actions :if={@current_scope && !@compact}>
        <%= if @notice.object_id in @watched_ids do %>
          <.link
            href={"/obserwowane/przetarg/#{@notice.object_id}"}
            method="delete"
            class="btn-outline inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-sm"
            title="Usuń z obserwowanych"
          >
            <.icon name="hero-star-solid" class="size-4 text-amber-500" /> Obserwujesz
          </.link>
        <% else %>
          <form action="/obserwowane" method="post" class="inline">
            <input type="hidden" name="_csrf_token" value={Phoenix.Controller.get_csrf_token()} />
            <input type="hidden" name="tender_object_id" value={@notice.object_id} />
            <button
              type="submit"
              class="btn-outline inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-sm"
              title="Dodaj do obserwowanych"
            >
              <.icon name="hero-star" class="size-4" /> Obserwuj
            </button>
          </form>
        <% end %>
      </:actions>
    </.result_card>
    """
  end

  @doc "Columns for the \"browse tenders\" block: industries, order types, voivodeships."
  def browse_columns do
    [
      %{
        id: "browse-categories",
        title: "Według branży",
        links: Enum.map(Hubs.category_hubs(), &{Hubs.path(:category, &1.slug), &1.h1})
      },
      %{
        id: "browse-order-types",
        title: "Według rodzaju zamówienia",
        links:
          Enum.map(Hubs.order_type_hubs(), &{Hubs.path(:order_type, &1.slug), &1.h1}) ++
            [
              {"/analiza-rynku", "Analiza rynku — kto wygrywa przetargi"},
              {"/przetargi", "Wszystkie przetargi"}
            ]
      },
      %{
        id: "browse-regions",
        title: "Według województwa",
        links: Enum.map(Hubs.regions(), &{Hubs.path(:region, &1.slug), &1.name})
      }
    ]
  end

  @doc "Sidebar rows for the open-tender breakdowns of a hub or the landing page."
  def region_rows(stats),
    do:
      Enum.map(stats.by_region, fn {slug, count} ->
        {region_label(slug), Hubs.path(:region, slug), count}
      end)

  def order_type_rows(stats) do
    Enum.map(stats.by_order_type, fn {order_type, count} ->
      path =
        case Hubs.order_type_hub_for(order_type) do
          nil -> nil
          hub -> Hubs.path(:order_type, hub.slug)
        end

      {order_type_label(order_type), path, count}
    end)
  end

  def authority_rows(stats),
    do: Enum.map(stats.top_authorities, fn {name, count} -> {name, nil, count} end)

  def kio_topics(hub), do: Enum.flat_map(hub.content.kio_topics, &List.wrap(Topics.get(&1)))

  @landing_faqs [
    %{
      question: "Skąd pochodzą przetargi w wyszukiwarce?",
      answer:
        "Z Biuletynu Zamówień Publicznych (BZP) prowadzonego przez Urząd Zamówień Publicznych. Publikowane są tam ogłoszenia o zamówieniach o wartości poniżej progów unijnych. Bazę aktualizujemy codziennie."
    },
    %{
      question: "Jak znaleźć przetargi dla mojej firmy?",
      answer:
        "Wybierz branżę lub województwo z listy albo użyj wyszukiwarki ze słowami kluczowymi i filtrami. Po założeniu konta możesz ustawić alert — nowe ogłoszenia pasujące do Twoich kryteriów będą przychodzić e-mailem."
    },
    %{
      question: "Czy korzystanie z wyszukiwarki przetargów jest bezpłatne?",
      answer:
        "Tak. Przeglądanie i wyszukiwanie ogłoszeń o przetargach jest bezpłatne i nie wymaga rejestracji. Konto jest potrzebne do alertów, listy obserwowanych i automatycznego wypełniania dokumentów."
    },
    %{
      question: "Co oznacza termin składania ofert?",
      answer:
        "To dzień i godzina, do których oferta musi wpłynąć do zamawiającego na platformie zakupowej. Oferta złożona po terminie podlega odrzuceniu, a terminu nie można przywrócić."
    }
  ]

  def landing_faqs, do: @landing_faqs

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

  def format_decimal_string(nil), do: "-"

  def format_decimal_string(value) when is_binary(value) do
    value |> Decimal.new() |> format_value()
  end

  def format_decimal_string(value), do: format_value(value)

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

  def format_notice_type("CircumstancesFulfillmentNotice"),
    do: "Ogłoszenie o spełnieniu okoliczności"

  def format_notice_type("SmallContractNotice"), do: "Ogłoszenie o zamówieniu bagatelnym"
  def format_notice_type(nil), do: "-"
  def format_notice_type(other), do: other

  @doc """
  Derives the lifecycle status of a tender for display, from its deadline and
  any result notice enriching it. The tender page shows this instead of a raw
  BZP notice type, which is a per-notice artifact and not meaningful for the
  procurement as a whole.

  Returns one of `:rozstrzygniety`, `:uniewazniony`, `:po_terminie`, `:aktywny`.
  """
  def tender_status(result_notice, is_expired) do
    cond do
      result_notice && all_contracts_cancelled?(result_notice) -> :uniewazniony
      result_notice -> :rozstrzygniety
      is_expired -> :po_terminie
      true -> :aktywny
    end
  end

  defp all_contracts_cancelled?(result_notice) do
    details = result_notice.contractors_contract_details || []
    details != [] and Enum.all?(details, &(&1.status == :cancelled))
  end

  def tender_status_label(:rozstrzygniety), do: "Rozstrzygnięty"
  def tender_status_label(:uniewazniony), do: "Unieważniony"
  def tender_status_label(:po_terminie), do: "Po terminie składania ofert"
  def tender_status_label(:aktywny), do: "Aktywny"

  def tender_status_badge_class(:rozstrzygniety), do: "bg-primary/10 text-primary"
  def tender_status_badge_class(:uniewazniony), do: "bg-error/10 text-error"
  def tender_status_badge_class(:po_terminie), do: "bg-base-300 text-base-content/70"
  def tender_status_badge_class(:aktywny), do: "bg-success/10 text-success"

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
    today = Date.utc_today()
    deadline_date = DateTime.to_date(deadline)
    diff = Date.diff(deadline_date, today)

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
    today = Date.utc_today()
    deadline_date = DateTime.to_date(deadline)
    diff = Date.diff(deadline_date, today)
    diff >= 0 and diff <= 3
  end

  def build_pagination_params(
        query,
        regions,
        order_types,
        deadline_from,
        deadline_to,
        with_winner_analysis,
        page
      ) do
    params = []
    params = if query && query != "", do: [{"q", query} | params], else: params
    params = params ++ Enum.map(regions, &{"regions[]", &1})
    params = params ++ Enum.map(order_types, &{"order_types[]", &1})

    params =
      if deadline_from && deadline_from != "",
        do: [{"deadline_from", deadline_from} | params],
        else: params

    params =
      if deadline_to && deadline_to != "",
        do: [{"deadline_to", deadline_to} | params],
        else: params

    params = if with_winner_analysis, do: [{"with_winner_analysis", "1"} | params], else: params

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

  def document_icon(nil), do: "hero-document"

  def document_icon(file_name) when is_binary(file_name) do
    extension =
      file_name
      |> String.downcase()
      |> Path.extname()

    case extension do
      ".pdf" -> "hero-document-text"
      ".doc" -> "hero-document-text"
      ".docx" -> "hero-document-text"
      ".xls" -> "hero-table-cells"
      ".xlsx" -> "hero-table-cells"
      ".zip" -> "hero-archive-box"
      ".7z" -> "hero-archive-box"
      ".rar" -> "hero-archive-box"
      ".jpg" -> "hero-photo"
      ".jpeg" -> "hero-photo"
      ".png" -> "hero-photo"
      ".gif" -> "hero-photo"
      _ -> "hero-document"
    end
  end

  @doc """
  Groups criteria by their part number.
  Returns a list of tuples {part_number, criteria_list} sorted by part number.
  Criteria without a part are grouped under nil.
  """
  def group_kryteria_by_part(kryteria) when is_list(kryteria) do
    kryteria
    |> Enum.group_by(fn k -> k["part"] || k[:part] end)
    |> Enum.sort_by(fn {part, _} -> part || 0 end)
  end

  def group_kryteria_by_part(_), do: []

  @doc """
  Checks if any of the provided documents are fillable (.doc or .docx).
  """
  def has_fillable_documents?(documents) when is_list(documents) do
    Enum.any?(documents, fn doc ->
      Przetargowi.TenderDocuments.fillable?(doc.name, doc.file_name)
    end)
  end

  def has_fillable_documents?(_), do: false
end
