defmodule PrzetargowiWeb.JudgementController do
  use PrzetargowiWeb, :controller

  def show(conn, %{"id" => id}) do
    # Mock judgement data - in production this would come from database
    judgement = get_mock_judgement(id)

    conn
    |> assign(:page_title, judgement.signature)
    |> assign(:judgement, judgement)
    |> render(:show)
  end

  defp get_mock_judgement(id) do
    %{
      id: id,
      signature: "KIO 1234/24",
      source: "KIO",
      decision_date: "2024-12-15",
      issuing_authority: "Krajowa Izba Odwoławcza",
      document_type: "Wyrok",
      chairman: "Jan Kowalski",
      contracting_authority: "Gmina Warszawa - Urząd Miasta Stołecznego Warszawy",
      location: "Warszawa",
      procedure_type: "Przetarg nieograniczony",
      order_type: "Usługi",
      resolution_method: "Oddalenie odwołania",
      key_provisions: [
        "Art. 226 ust. 1 pkt 2 lit. a",
        "Art. 226 ust. 1 pkt 5",
        "Art. 109 ust. 1 pkt 7"
      ],
      thematic_issues: [
        "Odrzucenie oferty",
        "Wykluczenie wykonawcy",
        "Zasada przejrzystości"
      ],
      meritum: """
      Izba uznała, że zamawiający prawidłowo wykluczył wykonawcę z postępowania na podstawie
      art. 109 ust. 1 pkt 7 ustawy Pzp, z uwagi na niewykonanie lub nienależyte wykonanie
      wcześniejszej umowy w sprawie zamówienia publicznego, co skutkowało wypowiedzeniem tej umowy.
      """,
      content: """
      Krajowa Izba Odwoławcza w składzie:

      Przewodniczący: Jan Kowalski
      Protokolant: Anna Nowak

      po rozpoznaniu na rozprawie w dniu 15 grudnia 2024 r. w Warszawie odwołania wniesionego
      do Prezesa Krajowej Izby Odwoławczej w dniu 5 grudnia 2024 r. przez wykonawcę ABC Sp. z o.o.
      z siedzibą w Krakowie w postępowaniu prowadzonym przez Gminę Warszawa - Urząd Miasta
      Stołecznego Warszawy

      orzeka:

      1. Oddala odwołanie.
      2. Kosztami postępowania obciąża odwołującego.

      UZASADNIENIE

      Zamawiający - Gmina Warszawa prowadzi postępowanie o udzielenie zamówienia publicznego
      na "Świadczenie usług utrzymania czystości w obiektach użyteczności publicznej".

      Odwołujący wniósł odwołanie wobec czynności wykluczenia go z postępowania na podstawie
      art. 109 ust. 1 pkt 7 ustawy z dnia 11 września 2019 r. - Prawo zamówień publicznych.

      Izba ustaliła następujący stan faktyczny:

      Zamawiający w dniu 28 listopada 2024 r. wykluczył odwołującego z postępowania, wskazując
      na niewykonanie wcześniejszej umowy zawartej z innym zamawiającym publicznym, która została
      rozwiązana z winy wykonawcy.

      Izba zważyła, co następuje:

      Odwołanie nie zasługuje na uwzględnienie. Zamawiający prawidłowo zastosował przesłankę
      wykluczenia z art. 109 ust. 1 pkt 7 ustawy Pzp. Z dokumentacji postępowania wynika,
      że odwołujący w sposób zawiniony nie wykonał wcześniejszej umowy w sprawie zamówienia
      publicznego, co doprowadziło do jej rozwiązania.

      Biorąc powyższe pod uwagę, Izba orzekła jak w sentencji.
      """,
      pdf_url: "#"
    }
  end
end
