defmodule Przetargowi.Tenders.Hubs do
  @moduledoc """
  SEO hub pages for tenders — category landing pages that target real search
  demand ("przetargi budowlane", "przetargi na usługi") and aggregate matching
  tenders, as opposed to individual tender detail pages which have no search
  demand of their own.

  Two dimensions:
    * order type (Works / Delivery / Services) — URL `/przetargi/rodzaj/:slug`
    * CPV division prefix / industry category — URL `/przetargi/branza/:slug`
  """

  @order_type_hubs [
    %{
      slug: "roboty-budowlane",
      order_type: "Works",
      h1: "Przetargi na roboty budowlane",
      page_title: "Przetargi na roboty budowlane — aktualne ogłoszenia z BZP",
      meta_description:
        "Aktualne przetargi na roboty budowlane z Biuletynu Zamówień Publicznych. Budowa, remonty, modernizacje — przeglądaj ogłoszenia i terminy składania ofert.",
      intro:
        "Aktualne przetargi publiczne na roboty budowlane — budowę, przebudowę, remonty i modernizacje. Poniżej znajdziesz otwarte postępowania z BZP z terminami składania ofert."
    },
    %{
      slug: "dostawy",
      order_type: "Delivery",
      h1: "Przetargi na dostawy",
      page_title: "Przetargi na dostawy — aktualne ogłoszenia z BZP",
      meta_description:
        "Aktualne przetargi na dostawy z Biuletynu Zamówień Publicznych. Sprzęt, materiały, wyposażenie — przeglądaj otwarte postępowania i terminy.",
      intro:
        "Aktualne przetargi publiczne na dostawy towarów — sprzętu, materiałów i wyposażenia. Poniżej otwarte postępowania z BZP wraz z terminami składania ofert."
    },
    %{
      slug: "uslugi",
      order_type: "Services",
      h1: "Przetargi na usługi",
      page_title: "Przetargi na usługi — aktualne ogłoszenia z BZP",
      meta_description:
        "Aktualne przetargi na usługi z Biuletynu Zamówień Publicznych. Usługi eksperckie, utrzymaniowe i specjalistyczne — przeglądaj otwarte postępowania.",
      intro:
        "Aktualne przetargi publiczne na usługi — od eksperckich po utrzymaniowe. Poniżej otwarte postępowania z BZP wraz z terminami składania ofert."
    }
  ]

  @category_hubs [
    %{
      slug: "budowlane",
      cpv_prefixes: ["45"],
      h1: "Przetargi budowlane",
      page_title: "Przetargi budowlane — aktualne ogłoszenia z BZP",
      meta_description:
        "Przetargi budowlane (CPV 45) — budowa, przebudowa i remonty obiektów oraz infrastruktury. Aktualne ogłoszenia z BZP z terminami składania ofert.",
      intro:
        "Przetargi z zakresu robót budowlanych (kody CPV z działu 45) — budowa i przebudowa obiektów, infrastruktury oraz roboty remontowe. Poniżej aktualne, otwarte postępowania."
    },
    %{
      slug: "drogowe",
      cpv_prefixes: ["4523"],
      h1: "Przetargi drogowe",
      page_title: "Przetargi drogowe — budowa i remonty dróg (BZP)",
      meta_description:
        "Przetargi drogowe — budowa, przebudowa i remonty dróg, chodników i mostów. Aktualne ogłoszenia z BZP z terminami składania ofert.",
      intro:
        "Przetargi na roboty drogowe (CPV 4523) — budowa i przebudowa dróg, chodników, mostów oraz remonty nawierzchni. Poniżej aktualne, otwarte postępowania."
    },
    %{
      slug: "medyczne",
      cpv_prefixes: ["33"],
      h1: "Przetargi medyczne",
      page_title: "Przetargi medyczne — sprzęt i wyroby medyczne (BZP)",
      meta_description:
        "Przetargi medyczne (CPV 33) — sprzęt medyczny, wyroby, leki i produkty farmaceutyczne. Aktualne ogłoszenia szpitali i placówek z BZP.",
      intro:
        "Przetargi z branży medycznej (kody CPV z działu 33) — sprzęt i aparatura medyczna, wyroby jednorazowe, leki i produkty farmaceutyczne. Poniżej aktualne postępowania."
    },
    %{
      slug: "it",
      cpv_prefixes: ["72", "48"],
      h1: "Przetargi IT i oprogramowanie",
      page_title: "Przetargi IT — usługi informatyczne i oprogramowanie (BZP)",
      meta_description:
        "Przetargi IT (CPV 72 i 48) — usługi informatyczne, wdrożenia, oprogramowanie i licencje. Aktualne ogłoszenia z BZP z terminami składania ofert.",
      intro:
        "Przetargi z branży IT (kody CPV z działów 72 i 48) — usługi informatyczne, wdrożenia i utrzymanie systemów, oprogramowanie i licencje. Poniżej aktualne postępowania."
    },
    %{
      slug: "catering-zywnosc",
      cpv_prefixes: ["55", "15"],
      h1: "Przetargi na catering i żywność",
      page_title: "Przetargi na catering i żywność — ogłoszenia z BZP",
      meta_description:
        "Przetargi na catering, usługi żywieniowe i dostawy żywności (CPV 55 i 15). Aktualne ogłoszenia szkół, szpitali i instytucji z BZP.",
      intro:
        "Przetargi na usługi cateringowe i żywieniowe oraz dostawy artykułów spożywczych (kody CPV z działów 55 i 15) — m.in. dla szkół, szpitali i instytucji. Poniżej aktualne postępowania."
    },
    %{
      slug: "odpady",
      cpv_prefixes: ["905"],
      h1: "Przetargi na odbiór odpadów",
      page_title: "Przetargi na odbiór i wywóz odpadów — ogłoszenia z BZP",
      meta_description:
        "Przetargi na odbiór, wywóz i zagospodarowanie odpadów (CPV 905). Aktualne ogłoszenia gmin i instytucji z BZP z terminami składania ofert.",
      intro:
        "Przetargi na odbiór, transport i zagospodarowanie odpadów komunalnych (kody CPV z grupy 905). Poniżej aktualne, otwarte postępowania z terminami składania ofert."
    },
    %{
      slug: "sprzatanie",
      cpv_prefixes: ["9091", "9092"],
      h1: "Przetargi na usługi sprzątania",
      page_title: "Przetargi na sprzątanie i utrzymanie czystości (BZP)",
      meta_description:
        "Przetargi na usługi sprzątania i utrzymania czystości (CPV 9091, 9092). Aktualne ogłoszenia instytucji i placówek z BZP.",
      intro:
        "Przetargi na usługi sprzątania i utrzymania czystości obiektów (kody CPV z grup 9091 i 9092). Poniżej aktualne, otwarte postępowania z terminami składania ofert."
    },
    %{
      slug: "transport",
      cpv_prefixes: ["60"],
      h1: "Przetargi transportowe",
      page_title: "Przetargi transportowe — usługi przewozowe (BZP)",
      meta_description:
        "Przetargi transportowe (CPV 60) — przewozy osób i towarów, transport publiczny, dowóz uczniów. Aktualne ogłoszenia z BZP.",
      intro:
        "Przetargi na usługi transportowe (kody CPV z działu 60) — przewóz osób i towarów, transport publiczny, dowóz uczniów. Poniżej aktualne, otwarte postępowania."
    },
    %{
      slug: "projektowe",
      cpv_prefixes: ["71"],
      h1: "Przetargi na usługi projektowe",
      page_title: "Przetargi na usługi projektowe i nadzór (BZP)",
      meta_description:
        "Przetargi na usługi projektowe, architektoniczne, inżynieryjne i nadzór inwestorski (CPV 71). Aktualne ogłoszenia z BZP.",
      intro:
        "Przetargi na usługi projektowe (kody CPV z działu 71) — dokumentacja projektowa, usługi architektoniczne i inżynieryjne oraz nadzór inwestorski. Poniżej aktualne postępowania."
    },
    %{
      slug: "ochrona",
      cpv_prefixes: ["797"],
      h1: "Przetargi na usługi ochrony",
      page_title: "Przetargi na ochronę fizyczną i mienia (BZP)",
      meta_description:
        "Przetargi na usługi ochrony osób i mienia oraz monitoring (CPV 797). Aktualne ogłoszenia instytucji z BZP z terminami składania ofert.",
      intro:
        "Przetargi na usługi ochrony osób i mienia oraz monitoring (kody CPV z grupy 797). Poniżej aktualne, otwarte postępowania z terminami składania ofert."
    },
    %{
      slug: "energia",
      cpv_prefixes: ["09"],
      h1: "Przetargi na energię i paliwa",
      page_title: "Przetargi na energię elektryczną i paliwa (BZP)",
      meta_description:
        "Przetargi na dostawę energii elektrycznej, gazu i paliw (CPV 09). Aktualne ogłoszenia instytucji publicznych z BZP.",
      intro:
        "Przetargi na dostawy energii i paliw (kody CPV z działu 09) — energia elektryczna, gaz ziemny, paliwa płynne i opałowe. Poniżej aktualne, otwarte postępowania."
    },
    %{
      slug: "szkolenia",
      cpv_prefixes: ["80"],
      h1: "Przetargi na usługi szkoleniowe",
      page_title: "Przetargi na szkolenia i usługi edukacyjne (BZP)",
      meta_description:
        "Przetargi na usługi szkoleniowe i edukacyjne (CPV 80) — szkolenia zawodowe, kursy, usługi edukacyjne. Aktualne ogłoszenia z BZP.",
      intro:
        "Przetargi na usługi szkoleniowe i edukacyjne (kody CPV z działu 80) — szkolenia zawodowe, kursy i usługi edukacyjne. Poniżej aktualne, otwarte postępowania."
    }
  ]

  @doc "All order-type hubs."
  def order_type_hubs, do: @order_type_hubs

  @doc "All category (CPV) hubs."
  def category_hubs, do: @category_hubs

  @doc "Looks up an order-type hub by slug, or nil."
  def order_type_hub(slug), do: Enum.find(@order_type_hubs, &(&1.slug == slug))

  @doc "Looks up a category (CPV) hub by slug, or nil."
  def category_hub(slug), do: Enum.find(@category_hubs, &(&1.slug == slug))

  @doc "Every hub path, for the sitemap."
  def all_paths do
    Enum.map(@order_type_hubs, &"/przetargi/rodzaj/#{&1.slug}") ++
      Enum.map(@category_hubs, &"/przetargi/branza/#{&1.slug}")
  end
end
