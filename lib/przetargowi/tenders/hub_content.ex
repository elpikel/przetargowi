defmodule Przetargowi.Tenders.HubContent do
  @moduledoc """
  Editorial content for the tender hubs defined in `Przetargowi.Tenders.Hubs`:
  explanatory copy, FAQ and the related KIO case-law topics, keyed by
  `{kind, slug}` where kind is `:order_type` or `:category`.

  Kept apart from the hub definitions (slug, CPV prefixes, titles) so the
  routing data stays short and the long-form copy can be edited on its own.
  """

  @content %{
    {:order_type, "roboty-budowlane"} => %{
      body: [
        "Roboty budowlane to największa wartościowo część rynku zamówień publicznych. Zamawiają je przede wszystkim gminy, powiaty, zarządy dróg, spółki komunalne i szpitale — od remontów szkół i świetlic po budowę dróg, sieci wodociągowych i obiektów kubaturowych. Większość postępowań poniżej progów unijnych prowadzona jest w trybie podstawowym i publikowana w Biuletynie Zamówień Publicznych.",
        "W przetargach na roboty zamawiający zwykle wymagają wykazania doświadczenia (wykaz robót z ostatnich 5 lat wraz z dowodami należytego wykonania), dysponowania kierownikiem budowy z odpowiednimi uprawnieniami oraz ubezpieczenia OC. Częste są też wadium i zabezpieczenie należytego wykonania umowy. Przed wyceną sprawdź, czy wynagrodzenie jest ryczałtowe czy kosztorysowe — od tego zależy, kto ponosi ryzyko błędów w przedmiarze."
      ],
      faqs: [
        %{
          question: "Gdzie publikowane są przetargi na roboty budowlane?",
          answer:
            "Postępowania o wartości poniżej progów unijnych są ogłaszane w Biuletynie Zamówień Publicznych, a o wartości równej progom lub wyższej — w Dzienniku Urzędowym Unii Europejskiej. Na tej stronie zbieramy aktualne ogłoszenia z BZP."
        },
        %{
          question: "Jakie doświadczenie trzeba wykazać w przetargu na roboty budowlane?",
          answer:
            "Zamawiający może żądać wykazu robót budowlanych wykonanych nie wcześniej niż w okresie ostatnich 5 lat, wraz z dowodami, że zostały wykonane należycie, np. referencjami. Zakres i wartość wymaganych robót określa warunek udziału w dokumentach zamówienia."
        },
        %{
          question: "Czy można startować w przetargu budowlanym bez własnego doświadczenia?",
          answer:
            "Tak — w konsorcjum albo polegając na zasobach innego podmiotu. W przypadku doświadczenia podmiot udostępniający zasoby musi jednak faktycznie wykonać roboty, do których te zdolności są wymagane."
        }
      ],
      kio_topics:
        ~w(razaco-niska-cena warunki-udzialu-w-postepowaniu konsorcjum-i-zasoby-podmiotu-trzeciego wadium),
      blog: {"najczestsze-bledy-oferty-przetargowe", "Najczęstsze błędy w ofertach przetargowych"}
    },
    {:order_type, "dostawy"} => %{
      body: [
        "Zamówienia na dostawy obejmują zakup, najem, dzierżawę i leasing rzeczy: sprzętu komputerowego, pojazdów, wyposażenia, żywności, leków, paliw czy energii. To najliczniejsza grupa postępowań, a duża ich część jest dzielona na części, co pozwala składać oferty także mniejszym firmom.",
        "O wyniku przetargu na dostawy najczęściej decyduje zgodność oferowanego produktu z opisem przedmiotu zamówienia. Zamawiający żądają przedmiotowych środków dowodowych — kart katalogowych, certyfikatów, próbek — a ich brak lub niezgodność parametrów prowadzi do odrzucenia oferty. Jeżeli opis wskazuje konkretny produkt, masz prawo zaoferować rozwiązanie równoważne, ale to Ty musisz wykazać równoważność."
      ],
      faqs: [
        %{
          question: "Jakie dokumenty są zwykle wymagane w przetargu na dostawy?",
          answer:
            "Oprócz oferty i oświadczenia o niepodleganiu wykluczeniu zamawiający często żąda przedmiotowych środków dowodowych potwierdzających parametry produktu, a przy warunku doświadczenia — wykazu dostaw wykonanych w ostatnich 3 latach wraz z dowodami należytego wykonania."
        },
        %{
          question:
            "Czy mogę zaoferować inny produkt niż wskazany w opisie przedmiotu zamówienia?",
          answer:
            "Tak, jeżeli jest równoważny. Zamawiający, który wskazuje znak towarowy lub pochodzenie, musi dopuścić rozwiązania równoważne i określić kryteria równoważności. Wykonawca udowadnia w ofercie, że proponowany produkt je spełnia."
        },
        %{
          question: "Czy można złożyć ofertę tylko na część zamówienia?",
          answer:
            "Tak, jeżeli zamawiający dopuścił składanie ofert częściowych. Dokumenty zamówienia wskazują, na ile części można złożyć ofertę i czy zamawiający ograniczył liczbę części, które mogą zostać udzielone jednemu wykonawcy."
        }
      ],
      kio_topics:
        ~w(przedmiotowe-srodki-dowodowe opis-przedmiotu-zamowienia niezgodnosc-oferty-z-warunkami-zamowienia),
      blog: {"najczestsze-bledy-oferty-przetargowe", "Najczęstsze błędy w ofertach przetargowych"}
    },
    {:order_type, "uslugi"} => %{
      body: [
        "Usługi to najbardziej zróżnicowana kategoria zamówień publicznych: od sprzątania, ochrony i wywozu odpadów, przez usługi projektowe i informatyczne, po szkolenia, catering i transport. Część z nich — usługi społeczne i inne szczególne usługi — udzielana jest w uproszczonej procedurze z wyższymi progami.",
        "W przetargach na usługi szczególnie często bada się rażąco niską cenę, bo głównym składnikiem kosztu jest praca. Wycena musi uwzględniać co najmniej minimalne wynagrodzenie i koszty zatrudnienia, a zamawiający może wymagać zatrudnienia osób wykonujących zamówienie na podstawie umowy o pracę. Rośnie też znaczenie kryteriów pozacenowych, takich jak doświadczenie personelu czy czas reakcji."
      ],
      faqs: [
        %{
          question: "Jak wykazać doświadczenie w przetargu na usługi?",
          answer:
            "Wykazem usług wykonanych, a w przypadku świadczeń powtarzających się lub ciągłych również wykonywanych, w okresie ostatnich 3 lat, wraz z dowodami należytego wykonania, np. referencjami od poprzednich zamawiających."
        },
        %{
          question: "Czy zamawiający może wymagać zatrudnienia na umowę o pracę?",
          answer:
            "Tak. Jeżeli czynności w ramach zamówienia polegają na wykonywaniu pracy w rozumieniu Kodeksu pracy, zamawiający określa w dokumentach zamówienia wymóg zatrudnienia na podstawie stosunku pracy osób, które je wykonują (art. 95 Pzp)."
        },
        %{
          question: "Czym są usługi społeczne w zamówieniach publicznych?",
          answer:
            "To m.in. usługi zdrowotne, edukacyjne, szkoleniowe, hotelowe, restauracyjne, prawne i ochroniarskie wymienione w załączniku do dyrektywy. Udziela się ich według uproszczonych zasad, a przepisy ustawy stosuje się do nich od wyższych progów wartości."
        }
      ],
      kio_topics: ~w(razaco-niska-cena kryteria-oceny-ofert warunki-udzialu-w-postepowaniu),
      blog: nil
    },
    {:category, "budowlane"} => %{
      body: [
        "Przetargi budowlane obejmują roboty z działu 45 Wspólnego Słownika Zamówień: budowę i remonty budynków, roboty inżynieryjne, instalacyjne i wykończeniowe. Zamawiającymi są głównie samorządy, które finansują inwestycje z budżetów własnych i programów dotacyjnych — dlatego liczba ogłoszeń rośnie po ogłoszeniu wyników naborów i na początku roku budżetowego.",
        "Najczęstsze przyczyny odrzucenia ofert w tej branży to błędy w kosztorysie ofertowym, niewykazanie wymaganego doświadczenia i rażąco niska cena. Coraz więcej inwestycji realizowanych jest w formule „zaprojektuj i wybuduj”, w której podstawą wyceny jest program funkcjonalno-użytkowy, a nie przedmiar — ryzyko niedoszacowania zakresu spoczywa wtedy na wykonawcy."
      ],
      faqs: [
        %{
          question: "Co oznacza kod CPV 45 w przetargach?",
          answer:
            "Dział 45 Wspólnego Słownika Zamówień obejmuje roboty budowlane: przygotowanie terenu, wznoszenie budynków i obiektów inżynieryjnych, instalacje budowlane oraz roboty wykończeniowe. Zamawiający oznacza kodem CPV główny przedmiot zamówienia."
        },
        %{
          question: "Czym różni się wynagrodzenie ryczałtowe od kosztorysowego?",
          answer:
            "Przy ryczałcie cena jest stała niezależnie od rzeczywistego zakresu prac, a kosztorys ma charakter pomocniczy. Przy wynagrodzeniu kosztorysowym rozliczenie następuje według faktycznie wykonanych ilości i cen jednostkowych z oferty, więc błąd w kosztorysie może oznaczać niezgodność oferty z warunkami zamówienia."
        },
        %{
          question: "Czy w przetargu budowlanym trzeba wnieść wadium?",
          answer:
            "Tylko jeżeli zamawiający tego zażądał. Wadium nie może przekraczać 1,5% wartości zamówienia poniżej progów unijnych i 3% powyżej progów. Często wymagane jest też zabezpieczenie należytego wykonania umowy, co do zasady do 5% ceny oferty."
        }
      ],
      kio_topics:
        ~w(razaco-niska-cena warunki-udzialu-w-postepowaniu wadium konsorcjum-i-zasoby-podmiotu-trzeciego),
      blog: {"najczestsze-bledy-oferty-przetargowe", "Najczęstsze błędy w ofertach przetargowych"}
    },
    {:category, "drogowe"} => %{
      body: [
        "Przetargi drogowe to budowa, przebudowa i remonty dróg gminnych, powiatowych i wojewódzkich, chodników, ścieżek rowerowych oraz obiektów mostowych. Zamawiają je zarządy dróg i samorządy, często z dofinansowaniem z rządowych programów drogowych, co powoduje wyraźną sezonowość ogłoszeń.",
        "Wycena robót drogowych jest wrażliwa na ceny asfaltu, kruszyw i paliw, dlatego w umowach dłuższych niż 6 miesięcy obowiązkowa jest klauzula waloryzacyjna. Warunki udziału dotyczą zwykle doświadczenia w budowie dróg określonej klasy lub długości oraz dysponowania kierownikiem z uprawnieniami w specjalności drogowej. Krótkie terminy realizacji i wysokie kary umowne są częstym przedmiotem odwołań na treść SWZ."
      ],
      faqs: [
        %{
          question: "Jakie uprawnienia są wymagane w przetargach drogowych?",
          answer:
            "Zamawiający zwykle wymaga dysponowania kierownikiem budowy lub robót z uprawnieniami budowlanymi w specjalności inżynieryjnej drogowej, a przy obiektach mostowych — w specjalności mostowej."
        },
        %{
          question: "Czy wynagrodzenie w umowie na roboty drogowe podlega waloryzacji?",
          answer:
            "Tak, jeżeli umowa zawierana jest na okres dłuższy niż 6 miesięcy. Musi wtedy określać zasady zmiany wynagrodzenia w razie zmiany cen materiałów lub kosztów związanych z realizacją zamówienia (art. 439 Pzp)."
        },
        %{
          question: "Kiedy ogłaszanych jest najwięcej przetargów drogowych?",
          answer:
            "Najwięcej postępowań pojawia się po uchwaleniu budżetów samorządów i rozstrzygnięciu naborów w programach dofinansowania dróg lokalnych, tak aby roboty mogły zostać wykonane w sezonie budowlanym."
        }
      ],
      kio_topics: ~w(razaco-niska-cena postanowienia-umowy warunki-udzialu-w-postepowaniu),
      blog: nil
    },
    {:category, "medyczne"} => %{
      body: [
        "Przetargi medyczne ogłaszają szpitale, przychodnie, stacje pogotowia i sanepid. Obejmują sprzęt i aparaturę medyczną, wyroby jednorazowe, odczynniki laboratoryjne, leki i produkty farmaceutyczne (dział 33 CPV). Większość postępowań jest dzielona na pakiety, często po kilkadziesiąt pozycji, a umowy zawierane są na 12–36 miesięcy z dostawami sukcesywnymi.",
        "Oferowane wyroby medyczne muszą być dopuszczone do obrotu — zamawiający żąda deklaracji zgodności, certyfikatów jednostki notyfikowanej i kart katalogowych. Spory przed KIO dotyczą najczęściej opisu przedmiotu zamówienia wskazującego na jednego producenta oraz oceny, czy zaoferowany produkt spełnia parametry graniczne. Przed terminem składania ofert warto zadawać pytania do SWZ i wnioskować o dopuszczenie parametrów równoważnych."
      ],
      faqs: [
        %{
          question: "Jakie dokumenty potwierdzają dopuszczenie wyrobu medycznego do obrotu?",
          answer:
            "Przede wszystkim deklaracja zgodności producenta i oznakowanie CE, a dla wyrobów wyższych klas ryzyka także certyfikat jednostki notyfikowanej. Zamawiający wskazuje w dokumentach zamówienia, których dokumentów żąda jako przedmiotowych środków dowodowych."
        },
        %{
          question:
            "Co zrobić, gdy opis przedmiotu zamówienia pasuje tylko do jednego producenta?",
          answer:
            "Najpierw zadać pytanie i wnioskować o dopuszczenie parametrów równoważnych. Jeżeli zamawiający odmówi, można wnieść odwołanie do KIO na treść dokumentów zamówienia — w terminie 10 dni powyżej progów unijnych lub 5 dni poniżej progów od ich publikacji."
        },
        %{
          question: "Czy można złożyć ofertę tylko na wybrane pakiety?",
          answer:
            "Tak, jeżeli postępowanie jest podzielone na części, co w przetargach medycznych jest regułą. Ofertę w ramach pakietu trzeba jednak zwykle złożyć na wszystkie jego pozycje."
        }
      ],
      kio_topics:
        ~w(opis-przedmiotu-zamowienia przedmiotowe-srodki-dowodowe niezgodnosc-oferty-z-warunkami-zamowienia),
      blog:
        {"dostarczanie-srodkow-medycznych-do-szpitali-pomorskie",
         "Jak rozpocząć dostarczanie środków medycznych do szpitali"}
    },
    {:category, "it"} => %{
      body: [
        "Przetargi IT obejmują usługi informatyczne (dział 72 CPV) oraz pakiety oprogramowania i systemy informatyczne (dział 48): wdrożenia systemów, utrzymanie i rozwój aplikacji, licencje, usługi chmurowe, cyberbezpieczeństwo i serwis sprzętu. Zamawiają je urzędy, uczelnie, szpitale i spółki komunalne, coraz częściej z funduszy na cyfryzację.",
        "W zamówieniach informatycznych cena rzadko jest jedynym kryterium — ocenia się doświadczenie zespołu, koncepcję wdrożenia, czas usunięcia awarii czy wynik prezentacji próbki systemu. Najwięcej sporów budzą opisy przedmiotu zamówienia uzależniające zamawiającego od dotychczasowego dostawcy (vendor lock-in), wymagania dotyczące przekazania kodów źródłowych i praw autorskich oraz zastrzeganie koncepcji wdrożenia jako tajemnicy przedsiębiorstwa."
      ],
      faqs: [
        %{
          question: "Jakie kryteria oceny ofert stosuje się w przetargach IT?",
          answer:
            "Poza ceną — doświadczenie i kwalifikacje osób wyznaczonych do realizacji, funkcjonalność oferowanego rozwiązania oceniana na próbce, parametry gwarancji i serwisu, termin wdrożenia. Kryteria muszą być opisane tak, aby ocena była weryfikowalna."
        },
        %{
          question: "Czy zamawiający może wymagać konkretnego oprogramowania?",
          answer:
            "Tylko gdy jest to uzasadnione, np. koniecznością zachowania zgodności z posiadanym środowiskiem, i z dopuszczeniem rozwiązań równoważnych. Opis wskazujący jednego producenta bez uzasadnienia narusza zasadę uczciwej konkurencji."
        },
        %{
          question: "Czym jest próbka systemu w przetargu informatycznym?",
          answer:
            "To demonstracja oferowanego oprogramowania według scenariuszy opisanych w dokumentach zamówienia. Może służyć potwierdzeniu zgodności z wymaganiami albo ocenie w kryteriach jakościowych — w tym drugim przypadku nie podlega uzupełnieniu."
        }
      ],
      kio_topics: ~w(opis-przedmiotu-zamowienia kryteria-oceny-ofert tajemnica-przedsiebiorstwa),
      blog: nil
    },
    {:category, "catering-zywnosc"} => %{
      body: [
        "W tej kategorii znajdziesz przetargi na dostawy żywności (dział 15 CPV) oraz usługi restauracyjne i cateringowe (dział 55): wyżywienie pacjentów szpitali, obiady w szkołach i przedszkolach, catering dla jednostek wojskowych i domów pomocy społecznej, a także sukcesywne dostawy mięsa, nabiału, pieczywa czy warzyw.",
        "Usługi cateringowe należą do usług społecznych, więc często udzielane są w uproszczonej procedurze. Zamawiający wymagają wdrożonego systemu HACCP, decyzji sanepidu zatwierdzającej zakład oraz doświadczenia w żywieniu zbiorowym. Przy dostawach żywności ceny jednostkowe obowiązują zwykle przez cały rok, dlatego kluczowe są klauzule waloryzacyjne i realna wycena przy zmiennych cenach surowców."
      ],
      faqs: [
        %{
          question: "Jakie wymagania sanitarne trzeba spełnić w przetargu na catering?",
          answer:
            "Wykonawca musi prowadzić zakład zatwierdzony przez Państwową Inspekcję Sanitarną i stosować system HACCP. Zamawiający może żądać decyzji sanepidu oraz dokumentów potwierdzających dopuszczenie środków transportu do przewozu żywności."
        },
        %{
          question: "Czy przetargi na dostawy żywności są dzielone na części?",
          answer:
            "Zazwyczaj tak — według asortymentu, np. mięso i wędliny, nabiał, pieczywo, warzywa i owoce, mrożonki. Pozwala to składać oferty lokalnym producentom i hurtowniom wyspecjalizowanym w jednej grupie produktów."
        },
        %{
          question: "Jak wycenić ofertę przy zmieniających się cenach żywności?",
          answer:
            "Sprawdź, czy umowa przewiduje waloryzację cen — przy umowach dłuższych niż 6 miesięcy klauzula waloryzacyjna jest obowiązkowa. Wycena poniżej realnych kosztów naraża na wezwanie do wyjaśnień rażąco niskiej ceny."
        }
      ],
      kio_topics: ~w(kryteria-oceny-ofert razaco-niska-cena przedmiotowe-srodki-dowodowe),
      blog:
        {"catering-szkoly-szpitale-haccp-przetargi",
         "Catering dla szkół i szpitali — wymogi sanitarne i HACCP"}
    },
    {:category, "odpady"} => %{
      body: [
        "Przetargi na odbiór i zagospodarowanie odpadów (grupa 905 CPV) ogłaszają przede wszystkim gminy, które mają ustawowy obowiązek zorganizowania odbioru odpadów komunalnych od mieszkańców. Są to zwykle umowy jedno- lub kilkuletnie o dużej wartości, rozliczane za tonę odebranych odpadów albo ryczałtem.",
        "Wykonawca musi być wpisany do rejestru działalności regulowanej w danej gminie oraz do bazy BDO, dysponować odpowiednią flotą pojazdów i bazą magazynowo-transportową. Na wielu rynkach lokalnych konkurencja jest ograniczona, dlatego spory dotyczą warunków udziału zawężających krąg wykonawców, podziału ryzyka wzrostu masy odpadów oraz cen za zagospodarowanie w instalacjach."
      ],
      faqs: [
        %{
          question: "Jakie wpisy i zezwolenia są potrzebne w przetargu na odbiór odpadów?",
          answer:
            "Wpis do rejestru działalności regulowanej w zakresie odbierania odpadów komunalnych prowadzonego przez gminę, wpis do bazy danych o odpadach (BDO) oraz — zależnie od zakresu — zezwolenie na transport, zbieranie lub przetwarzanie odpadów."
        },
        %{
          question: "Jak rozliczane są umowy na odbiór odpadów komunalnych?",
          answer:
            "Najczęściej według ceny jednostkowej za tonę odebranych i zagospodarowanych odpadów danej frakcji. Stosowany bywa też ryczałt miesięczny, przy którym ryzyko wzrostu ilości odpadów ponosi wykonawca."
        },
        %{
          question: "Czy gmina może udzielić zamówienia na odpady bez przetargu?",
          answer:
            "W określonych przypadkach tak — np. własnej spółce komunalnej w trybie zamówienia in-house, po spełnieniu ustawowych przesłanek. Zamiar udzielenia takiego zamówienia podlega ogłoszeniu i może zostać zaskarżony do KIO."
        }
      ],
      kio_topics: ~w(razaco-niska-cena warunki-udzialu-w-postepowaniu postanowienia-umowy),
      blog: nil
    },
    {:category, "sprzatanie"} => %{
      body: [
        "Przetargi na sprzątanie obejmują utrzymanie czystości w budynkach — urzędach, szkołach, szpitalach, sądach — oraz sprzątanie ulic, placów i terenów zielonych (grupy 9091 i 9092 CPV). Umowy zawierane są zwykle na 12–36 miesięcy, a w szpitalach obejmują także transport wewnętrzny i dezynfekcję.",
        "To branża o bardzo dużej konkurencji cenowej, w której niemal cały koszt stanowi praca. Zamawiający powszechnie wymagają zatrudnienia pracowników na umowę o pracę, a oferty poniżej kosztów minimalnego wynagrodzenia są odrzucane jako zawierające rażąco niską cenę. Wycena musi uwzględniać zapowiedziane podwyżki płacy minimalnej, a umowy wieloletnie — mechanizm zmiany wynagrodzenia."
      ],
      faqs: [
        %{
          question: "Jak skalkulować ofertę w przetargu na sprzątanie?",
          answer:
            "Podstawą jest liczba roboczogodzin potrzebnych do utrzymania powierzchni i pełny koszt zatrudnienia — co najmniej minimalne wynagrodzenie ze składkami, urlopami i zastępstwami — a następnie środki czystości, sprzęt, nadzór i zysk. Taką kalkulację trzeba będzie przedstawić przy wyjaśnianiu rażąco niskiej ceny."
        },
        %{
          question: "Czy wynagrodzenie zmieni się, gdy wzrośnie płaca minimalna?",
          answer:
            "W umowach zawieranych na okres dłuższy niż 12 miesięcy zamawiający musi przewidzieć zasady zmiany wynagrodzenia m.in. w razie zmiany minimalnego wynagrodzenia za pracę i stawek składek (art. 436 pkt 4 Pzp)."
        },
        %{
          question: "Czy zamawiający może wymagać umów o pracę dla osób sprzątających?",
          answer:
            "Tak. Czynności sprzątania mają charakter pracy w rozumieniu Kodeksu pracy, więc zamawiający określa wymóg zatrudnienia na podstawie stosunku pracy i sposób jego weryfikacji w trakcie realizacji umowy."
        }
      ],
      kio_topics: ~w(razaco-niska-cena czyn-nieuczciwej-konkurencji postanowienia-umowy),
      blog: nil
    },
    {:category, "transport"} => %{
      body: [
        "Przetargi transportowe (dział 60 CPV) to przede wszystkim dowóz uczniów do szkół, publiczny transport zbiorowy organizowany przez gminy i powiaty, przewóz osób niepełnosprawnych oraz usługi transportu towarów i przesyłek. Dowóz uczniów ogłaszany jest masowo przed rozpoczęciem roku szkolnego.",
        "Wykonawca musi posiadać licencję lub zezwolenie na wykonywanie zawodu przewoźnika drogowego oraz dysponować odpowiednią liczbą pojazdów i kierowców. Zamawiający często punktują wiek lub normę emisji spalin taboru i czas podstawienia pojazdu zastępczego. Rozliczenie następuje za kilometr albo na podstawie biletów miesięcznych, co wpływa na rozkład ryzyka między stronami."
      ],
      faqs: [
        %{
          question: "Jakie uprawnienia są wymagane w przetargu na przewóz osób?",
          answer:
            "Zezwolenie na wykonywanie zawodu przewoźnika drogowego lub licencja na krajowy transport drogowy osób, a przy przewozach regularnych — zezwolenie na linię. Zamawiający może też wymagać wykazu pojazdów i kierowców."
        },
        %{
          question: "Kiedy ogłaszane są przetargi na dowóz uczniów?",
          answer:
            "Najczęściej od maja do sierpnia, tak aby umowa mogła zostać zawarta przed początkiem roku szkolnego. Część gmin ogłasza je osobno na rok kalendarzowy, pod koniec roku."
        },
        %{
          question: "Czy wiek pojazdów może być kryterium oceny ofert?",
          answer:
            "Tak. Rok produkcji, norma emisji spalin czy wyposażenie pojazdów są związane z przedmiotem zamówienia i mogą być punktowane, o ile kryterium jest opisane jednoznacznie."
        }
      ],
      kio_topics: ~w(opis-przedmiotu-zamowienia warunki-udzialu-w-postepowaniu razaco-niska-cena),
      blog: nil
    },
    {:category, "projektowe"} => %{
      body: [
        "Przetargi projektowe (dział 71 CPV) obejmują opracowanie dokumentacji projektowej budynków, dróg i sieci, nadzór inwestorski i autorski, usługi geodezyjne, badania geologiczne oraz ekspertyzy techniczne. To zwykle pierwszy etap inwestycji publicznej, poprzedzający przetarg na roboty budowlane.",
        "Warunki udziału dotyczą doświadczenia w projektowaniu obiektów podobnej klasy oraz dysponowania projektantami z uprawnieniami w odpowiednich specjalnościach. Ponieważ jakość dokumentacji przesądza o kosztach późniejszej budowy, zamawiający coraz częściej oceniają doświadczenie projektantów. Istotnym ryzykiem są krótkie terminy uzależnione od uzyskania decyzji administracyjnych, na które projektant ma ograniczony wpływ."
      ],
      faqs: [
        %{
          question: "Kto może startować w przetargu na dokumentację projektową?",
          answer:
            "Wykonawca, który wykaże wymagane doświadczenie i dysponuje projektantami z uprawnieniami budowlanymi do projektowania w specjalnościach wskazanych w dokumentach zamówienia, np. architektonicznej, konstrukcyjno-budowlanej, drogowej, instalacyjnej."
        },
        %{
          question: "Czy doświadczenie projektanta może być kryterium oceny ofert?",
          answer:
            "Tak. Organizacja, kwalifikacje zawodowe i doświadczenie osób wyznaczonych do realizacji zamówienia mogą być kryterium, jeżeli mają znaczący wpływ na jakość jego wykonania — co w usługach projektowych jest regułą."
        },
        %{
          question: "Kto odpowiada za opóźnienie w uzyskaniu pozwolenia na budowę?",
          answer:
            "Zależy od umowy, ale zamawiający nie może obciążać wykonawcy odpowiedzialnością za okoliczności, za które wyłączną odpowiedzialność ponosi sam zamawiający (art. 433 Pzp). Kary za opóźnienia niezależne od projektanta są częstym przedmiotem odwołań."
        }
      ],
      kio_topics: ~w(kryteria-oceny-ofert warunki-udzialu-w-postepowaniu razaco-niska-cena),
      blog: nil
    },
    {:category, "ochrona"} => %{
      body: [
        "Przetargi na ochronę (grupa 797 CPV) dotyczą fizycznej ochrony osób i mienia w urzędach, sądach, szpitalach, jednostkach wojskowych i na obiektach komunalnych, a także monitoringu, konwojowania wartości i obsługi systemów alarmowych. Usługi ochroniarskie należą do usług społecznych.",
        "Wykonawca musi posiadać koncesję MSWiA na prowadzenie działalności w zakresie ochrony osób i mienia, a przy obiektach podlegających obowiązkowej ochronie — pracowników wpisanych na listę kwalifikowanych pracowników ochrony fizycznej. Podobnie jak w sprzątaniu, o wyniku decyduje kalkulacja kosztów pracy: stawka za roboczogodzinę poniżej kosztów minimalnego wynagrodzenia oznacza rażąco niską cenę."
      ],
      faqs: [
        %{
          question: "Czy do startu w przetargu na ochronę potrzebna jest koncesja?",
          answer:
            "Tak. Działalność gospodarcza w zakresie usług ochrony osób i mienia wymaga koncesji wydawanej przez ministra właściwego do spraw wewnętrznych. Zamawiający żąda jej jako potwierdzenia uprawnień do prowadzenia działalności."
        },
        %{
          question: "Jaka jest minimalna stawka za roboczogodzinę w ochronie?",
          answer:
            "Stawka musi pokrywać co najmniej minimalne wynagrodzenie za pracę albo minimalną stawkę godzinową wraz z kosztami pracodawcy, a także nadzór, wyposażenie i zysk. Niższa wycena prowadzi do odrzucenia oferty z powodu rażąco niskiej ceny."
        },
        %{
          question: "Czy pracownicy ochrony muszą być zatrudnieni na umowę o pracę?",
          answer:
            "Zamawiający może i zazwyczaj powinien tego wymagać, ponieważ czynności ochrony wykonywane są w warunkach charakterystycznych dla stosunku pracy. Wymóg i sposób jego kontroli określają dokumenty zamówienia."
        }
      ],
      kio_topics: ~w(razaco-niska-cena warunki-udzialu-w-postepowaniu wykluczenie-wykonawcy),
      blog:
        {"przetargi-ochrona-fizyczna-jak-startowac",
         "Przetargi na ochronę fizyczną — jak startować i wygrywać"}
    },
    {:category, "energia"} => %{
      body: [
        "W tej kategorii znajdują się przetargi na dostawy energii elektrycznej, gazu ziemnego, oleju opałowego, węgla i paliw płynnych (dział 09 CPV). Zamawiają je samorządy, szpitale, uczelnie i spółki komunalne — często w formie grup zakupowych, w których jeden przetarg obejmuje kilkadziesiąt jednostek.",
        "Sprzedawca energii elektrycznej lub gazu musi posiadać koncesję Prezesa URE i umowę z właściwym operatorem systemu dystrybucyjnego. Cena oferty opiera się na prognozie zużycia i notowaniach giełdowych, dlatego termin związania ofertą bywa krótki, a umowy przewidują zmianę ceny w razie zmiany stawek podatku akcyzowego lub VAT. Przy paliwach płynnych powszechną praktyką jest stały upust od ceny hurtowej producenta."
      ],
      faqs: [
        %{
          question: "Kto może złożyć ofertę w przetargu na energię elektryczną?",
          answer:
            "Przedsiębiorstwo energetyczne posiadające koncesję na obrót energią elektryczną wydaną przez Prezesa Urzędu Regulacji Energetyki oraz zawartą umowę dystrybucyjną z operatorem, do którego sieci przyłączone są obiekty zamawiającego."
        },
        %{
          question: "Czym jest grupa zakupowa energii?",
          answer:
            "To wspólne zamówienie kilku lub kilkudziesięciu zamawiających, np. gminy i jej jednostek, którzy łączą wolumen, aby uzyskać lepszą cenę. Postępowanie prowadzi jeden upoważniony zamawiający, a umowy zawiera każdy uczestnik."
        },
        %{
          question: "Jak określa się cenę w przetargu na paliwa?",
          answer:
            "Zazwyczaj jako cenę hurtową producenta z określonego dnia pomniejszoną o stały upust albo powiększoną o stałą marżę, które obowiązują przez cały okres umowy. Ocenie podlega więc w praktyce wysokość upustu lub marży."
        }
      ],
      kio_topics: ~w(postanowienia-umowy blad-w-obliczeniu-ceny opis-przedmiotu-zamowienia),
      blog: nil
    },
    {:category, "szkolenia"} => %{
      body: [
        "Przetargi szkoleniowe (dział 80 CPV) obejmują kursy zawodowe dla osób bezrobotnych zamawiane przez urzędy pracy, szkolenia dla pracowników administracji, studia podyplomowe, kursy językowe oraz zajęcia dodatkowe dla uczniów. Duża część jest finansowana z funduszy europejskich, co wpływa na wymagania dotyczące dokumentowania realizacji.",
        "Usługi edukacyjne i szkoleniowe są usługami społecznymi, więc procedura bywa uproszczona. Kluczowym kryterium jest zwykle doświadczenie trenerów, a wykonawca musi często posiadać wpis do rejestru instytucji szkoleniowych. Przy wycenie trzeba ustalić właściwą stawkę VAT — szkolenia finansowane w całości lub w co najmniej 70% ze środków publicznych korzystają ze zwolnienia, a błędna stawka oznacza błąd w obliczeniu ceny."
      ],
      faqs: [
        %{
          question: "Czy do udziału w przetargu na szkolenia potrzebny jest wpis do RIS?",
          answer:
            "Wpis do Rejestru Instytucji Szkoleniowych jest wymagany przy szkoleniach zlecanych przez urzędy pracy i finansowanych ze środków publicznych przeznaczonych na aktywizację zawodową. W innych postępowaniach zależy to od wymagań zamawiającego."
        },
        %{
          question: "Jaką stawkę VAT zastosować w ofercie na szkolenie?",
          answer:
            "Usługi kształcenia zawodowego finansowane w całości ze środków publicznych, a na podstawie przepisów wykonawczych także w co najmniej 70%, są zwolnione z VAT. W pozostałych przypadkach stosuje się stawkę podstawową. Zastosowanie niewłaściwej stawki może skutkować odrzuceniem oferty."
        },
        %{
          question: "Jak oceniane są oferty w przetargach szkoleniowych?",
          answer:
            "Oprócz ceny zamawiający najczęściej punktują doświadczenie trenerów — liczbę przeprowadzonych szkoleń o danej tematyce — oraz program, metody prowadzenia zajęć lub certyfikaty jakości."
        }
      ],
      kio_topics: ~w(kryteria-oceny-ofert warunki-udzialu-w-postepowaniu blad-w-obliczeniu-ceny),
      blog: nil
    }
  }

  @empty %{body: [], faqs: [], kio_topics: [], blog: nil}

  @doc "Returns the editorial content for a hub, or empty content when none is written."
  def get(kind, slug), do: Map.get(@content, {kind, slug}, @empty)
end
