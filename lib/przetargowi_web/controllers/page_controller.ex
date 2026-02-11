defmodule PrzetargowiWeb.PageController do
  use PrzetargowiWeb, :controller

  def home(conn, _params) do
    sample_results = [
      %{
        id: "kio-2024-1234",
        source: "KIO",
        signature: "KIO 1234/24",
        date: "2024-12-15",
        excerpt:
          "Izba uznała, że zamawiający prawidłowo wykluczył wykonawcę z postępowania na podstawie art. 109 ust. 1 pkt 7 ustawy Pzp, z uwagi na niewykonanie lub nienależyte wykonanie wcześniejszej umowy..."
      },
      %{
        id: "so-2024-5678",
        source: "SO",
        signature: "XXIII Ga 567/24",
        date: "2024-11-28",
        excerpt:
          "Sąd Okręgowy oddalił skargę na wyrok KIO dotyczącą oceny oferty pod kątem rażąco niskiej ceny. Zamawiający miał prawo żądać wyjaśnień w zakresie kalkulacji kosztów pracy..."
      },
      %{
        id: "kio-2024-9012",
        source: "KIO",
        signature: "KIO 2567/24",
        date: "2024-12-10",
        excerpt:
          "W sprawie dotyczącej wadium Izba stwierdziła, że gwarancja bankowa nie spełniała wymagań SIWZ, ponieważ nie obejmowała wszystkich przesłanek zatrzymania wadium określonych w ustawie..."
      },
      %{
        id: "sa-2024-3456",
        source: "SA",
        signature: "I ACa 234/24",
        date: "2024-10-20",
        excerpt:
          "Sąd Apelacyjny utrzymał w mocy wyrok sądu pierwszej instancji w sprawie odpowiedzialności wykonawcy za opóźnienie w realizacji zamówienia publicznego na roboty budowlane..."
      },
      %{
        id: "sn-2024-7890",
        source: "SN",
        signature: "III CZP 45/24",
        date: "2024-09-15",
        excerpt:
          "Sąd Najwyższy podjął uchwałę w składzie siedmiu sędziów dotyczącą wykładni przepisów o przedawnieniu roszczeń z tytułu kar umownych w zamówieniach publicznych..."
      },
      %{
        id: "kio-2024-4567",
        source: "KIO",
        signature: "KIO 3891/24",
        date: "2024-12-05",
        excerpt:
          "Izba uwzględniła odwołanie wykonawcy i nakazała unieważnienie czynności wyboru najkorzystniejszej oferty. Zamawiający nie dokonał prawidłowej oceny doświadczenia osób skierowanych do realizacji..."
      }
    ]

    conn
    |> assign(:page_title, "Strona Główna")
    |> assign(:sample_results, sample_results)
    |> render(:home)
  end
end
