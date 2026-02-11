defmodule PrzetargowiWeb.SearchController do
  use PrzetargowiWeb, :controller

  def index(conn, params) do
    query = Map.get(params, "q", "")
    sources = Map.get(params, "sources", ["KIO", "SO", "SA", "SN"])

    # Convert sources to list if it's a single string
    sources = if is_list(sources), do: sources, else: [sources]

    # Static demo results - will be replaced with actual search later
    results =
      if query != "" do
        get_demo_results(query, sources)
      else
        []
      end

    conn
    |> assign(:page_title, if(query != "", do: "Wyniki: #{query}", else: "Wyszukiwarka"))
    |> assign(
      :meta_description,
      "Wyszukaj orzeczenia KIO, SO, SA i SN dotyczące zamówień publicznych."
    )
    |> assign(:query, query)
    |> assign(:sources, sources)
    |> assign(:results, results)
    |> assign(:total_count, length(results))
    |> render(:index)
  end

  defp get_demo_results(_query, sources) do
    all_results = [
      %{
        id: "kio-2024-1234",
        source: "KIO",
        signature: "KIO 1234/24",
        date: "2024-12-15",
        relevance: 0.95,
        excerpt:
          "Izba uznała, że zamawiający prawidłowo wykluczył wykonawcę z postępowania na podstawie art. 109 ust. 1 pkt 7 ustawy Pzp, z uwagi na niewykonanie lub nienależyte wykonanie wcześniejszej umowy. Wykonawca nie przedstawił dowodów na podjęcie działań naprawczych.",
        meritum:
          "Wykluczenie wykonawcy na podstawie art. 109 ust. 1 pkt 7 Pzp wymaga wykazania przez zamawiającego, że wykonawca w sposób zawiniony poważnie naruszył obowiązki zawodowe."
      },
      %{
        id: "so-2024-5678",
        source: "SO",
        signature: "XXIII Ga 567/24",
        date: "2024-11-28",
        relevance: 0.89,
        excerpt:
          "Sąd Okręgowy oddalił skargę na wyrok KIO dotyczącą oceny oferty pod kątem rażąco niskiej ceny. Zamawiający miał prawo żądać wyjaśnień w zakresie kalkulacji kosztów pracy i materiałów.",
        meritum:
          "Ciężar dowodu w zakresie wykazania, że oferta nie zawiera rażąco niskiej ceny spoczywa na wykonawcy, który został wezwany do złożenia wyjaśnień."
      },
      %{
        id: "kio-2024-9012",
        source: "KIO",
        signature: "KIO 2567/24",
        date: "2024-12-10",
        relevance: 0.87,
        excerpt:
          "W sprawie dotyczącej wadium Izba stwierdziła, że gwarancja bankowa nie spełniała wymagań SIWZ, ponieważ nie obejmowała wszystkich przesłanek zatrzymania wadium określonych w ustawie Pzp.",
        meritum:
          "Gwarancja wadialna musi obejmować wszystkie przesłanki zatrzymania wadium określone w art. 98 ust. 6 ustawy Pzp, w tym odmowę zawarcia umowy i nieprzedłożenie dokumentów."
      },
      %{
        id: "sa-2024-3456",
        source: "SA",
        signature: "I ACa 234/24",
        date: "2024-10-20",
        relevance: 0.82,
        excerpt:
          "Sąd Apelacyjny utrzymał w mocy wyrok sądu pierwszej instancji w sprawie odpowiedzialności wykonawcy za opóźnienie w realizacji zamówienia publicznego na roboty budowlane.",
        meritum:
          "Wykonawca ponosi odpowiedzialność za opóźnienie w realizacji zamówienia, chyba że wykaże, że opóźnienie nastąpiło z przyczyn od niego niezależnych."
      },
      %{
        id: "sn-2024-7890",
        source: "SN",
        signature: "III CZP 45/24",
        date: "2024-09-15",
        relevance: 0.78,
        excerpt:
          "Sąd Najwyższy podjął uchwałę w składzie siedmiu sędziów dotyczącą wykładni przepisów o przedawnieniu roszczeń z tytułu kar umownych w zamówieniach publicznych.",
        meritum:
          "Roszczenia z tytułu kar umownych w zamówieniach publicznych przedawniają się na zasadach ogólnych przewidzianych w Kodeksie cywilnym."
      },
      %{
        id: "kio-2024-4567",
        source: "KIO",
        signature: "KIO 3891/24",
        date: "2024-12-05",
        relevance: 0.75,
        excerpt:
          "Izba uwzględniła odwołanie wykonawcy i nakazała unieważnienie czynności wyboru najkorzystniejszej oferty. Zamawiający nie dokonał prawidłowej oceny doświadczenia osób skierowanych do realizacji zamówienia.",
        meritum:
          "Ocena kwalifikacji osób skierowanych do realizacji zamówienia musi być przeprowadzona w sposób obiektywny i zgodny z kryteriami określonymi w dokumentacji postępowania."
      },
      %{
        id: "kio-2024-8901",
        source: "KIO",
        signature: "KIO 4123/24",
        date: "2024-11-30",
        relevance: 0.72,
        excerpt:
          "Odwołanie zostało oddalone. Izba stwierdziła, że zamawiający prawidłowo odrzucił ofertę wykonawcy z powodu niezgodności treści oferty z warunkami zamówienia określonymi w SWZ.",
        meritum:
          "Niezgodność treści oferty z warunkami zamówienia stanowi przesłankę odrzucenia oferty, jeżeli niezgodność ma charakter merytoryczny i nie może być usunięta w trybie wyjaśnień."
      },
      %{
        id: "so-2024-2345",
        source: "SO",
        signature: "XXIII Ga 891/24",
        date: "2024-11-15",
        relevance: 0.68,
        excerpt:
          "Sąd Okręgowy zmienił wyrok KIO i nakazał zamawiającemu ponowną ocenę ofert. Izba błędnie przyjęła, że wykonawca nie spełnił warunku udziału w postępowaniu dotyczącego zdolności technicznej.",
        meritum:
          "Warunki udziału w postępowaniu należy interpretować w sposób proporcjonalny do przedmiotu zamówienia i nie mogą one nadmiernie ograniczać konkurencji."
      }
    ]

    # Filter by selected sources
    Enum.filter(all_results, fn result -> result.source in sources end)
  end
end
