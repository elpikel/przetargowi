defmodule PrzetargowiWeb.LandingController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements

  def orzecznictwo_kio(conn, _params) do
    # Get recent judgements for internal linking
    recent_judgements = Judgements.list_recent_judgements(6)

    # Get stats for the page
    total_count = Judgements.count_sitemap_entries()

    canonical_url = "https://przetargowi.pl/orzecznictwo-kio"

    breadcrumbs = [
      %{name: "Strona główna", url: "https://przetargowi.pl"},
      %{name: "Orzecznictwo KIO", url: canonical_url}
    ]

    faqs = [
      %{
        question: "Czym jest orzecznictwo KIO?",
        answer:
          "Orzecznictwo KIO to zbiór wyroków i postanowień wydawanych przez Krajową Izbę Odwoławczą — organ rozpatrujący odwołania w sprawach zamówień publicznych. Orzeczenia KIO stanowią ważne źródło interpretacji przepisów ustawy Prawo zamówień publicznych."
      },
      %{
        question: "Jak szukać orzeczeń KIO?",
        answer:
          "Na Przetargowi.pl możesz wyszukiwać orzeczenia KIO po słowach kluczowych, sygnaturze sprawy, dacie wydania lub rodzaju rozstrzygnięcia. Dostępne jest również wyszukiwanie semantyczne z AI, które znajduje orzeczenia podobne znaczeniowo do Twojego zapytania."
      },
      %{
        question: "Czy orzeczenia KIO są wiążące?",
        answer:
          "Orzeczenia KIO są wiążące dla stron danego postępowania odwoławczego. Choć formalnie nie stanowią precedensów, w praktyce są szeroko stosowane jako wskazówki interpretacyjne przez zamawiających, wykonawców i inne składy orzekające KIO."
      },
      %{
        question: "Ile orzeczeń KIO jest w bazie?",
        answer:
          "Nasza baza zawiera #{total_count} orzeczeń Krajowej Izby Odwoławczej i jest regularnie aktualizowana. Znajdziesz tu wyroki, postanowienia oraz uchwały KIO dotyczące zamówień publicznych."
      },
      %{
        question: "Jak długo trwa postępowanie przed KIO?",
        answer:
          "KIO rozpoznaje odwołanie w terminie 15 dni od dnia jego doręczenia. W sprawach pilnych termin może być krótszy. Wyrok jest ogłaszany na posiedzeniu jawnym i doręczany stronom wraz z uzasadnieniem."
      }
    ]

    conn
    |> assign(:page_title, "Orzecznictwo KIO — baza wyroków Krajowej Izby Odwoławczej")
    |> assign(
      :meta_description,
      "Orzecznictwo KIO wyszukiwarka — przeglądaj #{total_count} wyroków i orzeczeń Krajowej Izby Odwoławczej. Wyszukiwanie po słowach kluczowych i semantyczne z AI."
    )
    |> assign(:canonical_url, canonical_url)
    |> assign(:og_url, canonical_url)
    |> assign(:breadcrumbs, breadcrumbs)
    |> assign(:faqs, faqs)
    |> assign(:recent_judgements, recent_judgements)
    |> assign(:total_count, total_count)
    |> render(:orzecznictwo_kio)
  end
end
