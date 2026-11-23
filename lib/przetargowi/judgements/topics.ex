defmodule Przetargowi.Judgements.Topics do
  @moduledoc """
  Curated topic hubs for KIO case law — `/orzecznictwo-kio/:slug`.

  Each hub targets a real search query ("rażąco niska cena orzecznictwo KIO",
  "tajemnica przedsiębiorstwa wyroki KIO") and aggregates the rulings tagged
  with the matching `thematic_issues`, together with hand-written editorial
  copy and live outcome statistics.

  The list is curated on purpose. The raw data holds 3000+ distinct issue
  labels, most of them with a handful of rulings; generating a page per label
  would recreate the thin-content problem that search result URLs caused.
  Only add a topic here when it has search demand and its own copy.
  """

  @topics [
    %{
      slug: "razaco-niska-cena",
      name: "Rażąco niska cena",
      issues: [
        "rażąco niska cena",
        "rażaco niska cena",
        "cena rażąco niska",
        "wyjaśnienia rażąco niskiej ceny",
        "wezwanie do wyjaśnienia rażąco niskiej ceny",
        "wyjaśnienia ceny",
        "oferta zawierająca rażąco niską cenę",
        "odrzucenie oferty z uwagi na rażąco niską cenę i niezgodność z ustawą"
      ],
      lead:
        "Orzeczenia Krajowej Izby Odwoławczej dotyczące rażąco niskiej ceny: wezwania do wyjaśnień, oceny złożonych wyjaśnień i dowodów oraz odrzucenia oferty.",
      body: [
        "Ustawa Pzp nie definiuje rażąco niskiej ceny. W orzecznictwie KIO przyjmuje się, że jest to cena nierealistyczna, za którą nie da się wykonać zamówienia bez straty i z należytą starannością. Ocenie podlega nie tylko cena całkowita, ale również jej istotne części składowe.",
        "Zamawiający wzywa wykonawcę do wyjaśnień, gdy cena budzi wątpliwości, a obowiązkowo wtedy, gdy jest niższa o co najmniej 30% od wartości zamówienia powiększonej o VAT lub od średniej arytmetycznej cen złożonych ofert. Ciężar wykazania, że oferta nie zawiera rażąco niskiej ceny, spoczywa na wykonawcy. Wyjaśnienia ogólnikowe, bez kalkulacji i dowodów, Izba konsekwentnie traktuje jak brak wyjaśnień.",
        "Najczęstsze spory dotyczą tego, czy zamawiający miał obowiązek wezwać do wyjaśnień, czy złożone wyjaśnienia były wystarczająco konkretne oraz czy dopuszczalne jest ponowne wezwanie wykonawcy."
      ],
      articles: [
        {"224", "art. 224 — wyjaśnienia rażąco niskiej ceny"},
        {"226", "art. 226 ust. 1 pkt 8 — odrzucenie oferty z rażąco niską ceną"},
        {"537", "art. 537 — ciężar dowodu w postępowaniu odwoławczym"}
      ],
      faqs: [
        %{
          question: "Kiedy zamawiający musi wezwać do wyjaśnienia rażąco niskiej ceny?",
          answer:
            "Wezwanie jest obowiązkowe, gdy cena całkowita oferty jest niższa o co najmniej 30% od wartości zamówienia powiększonej o VAT lub od średniej arytmetycznej cen wszystkich złożonych ofert niepodlegających odrzuceniu, chyba że rozbieżność wynika z okoliczności oczywistych. Zamawiający może też wezwać do wyjaśnień zawsze, gdy cena lub jej istotna część budzi wątpliwości."
        },
        %{
          question: "Kto musi udowodnić, że cena nie jest rażąco niska?",
          answer:
            "Wykonawca, który został wezwany do wyjaśnień. W postępowaniu odwoławczym ciężar dowodu również spoczywa na wykonawcy, który złożył ofertę, a jeżeli nie jest on uczestnikiem postępowania — na zamawiającym (art. 537 Pzp)."
        },
        %{
          question: "Co powinny zawierać wyjaśnienia rażąco niskiej ceny?",
          answer:
            "Szczegółową kalkulację ceny — koszty pracy nie niższe niż wynikające z minimalnego wynagrodzenia, materiały, sprzęt, koszty ogólne i zysk — oraz dowody, które ją potwierdzają: oferty dostawców i podwykonawców, umowy, faktury. Wyjaśnienia ograniczone do zapewnień o doświadczeniu i sprawnej organizacji Izba traktuje jak brak wyjaśnień."
        },
        %{
          question: "Czy zamawiający może wezwać do wyjaśnień rażąco niskiej ceny drugi raz?",
          answer:
            "Tak, ale tylko po to, by doprecyzować wyjaśnienia, które były rzetelne i konkretne. Ponowne wezwanie nie może służyć naprawieniu wyjaśnień ogólnikowych lub pozbawionych dowodów — taką ofertę zamawiający odrzuca."
        },
        %{
          question: "Czy rażąco niska może być tylko część ceny?",
          answer:
            "Tak. Art. 224 ust. 1 Pzp obejmuje również istotne części składowe ceny lub kosztu. Zamawiający może więc żądać wyjaśnień dotyczących jednej pozycji, jeżeli ma ona znaczenie dla całości wynagrodzenia lub jest odrębnie rozliczana."
        }
      ],
      blog:
        {"razaco-niska-cena-wyjasnienia-jak-uzasadnic-oferte",
         "Rażąco niska cena — jak uzasadnić swoją ofertę"}
    },
    %{
      slug: "odrzucenie-oferty",
      name: "Odrzucenie oferty",
      issues: [
        "odrzucenie oferty",
        "zaniechanie odrzucenia oferty",
        "oferta nieważna",
        "oferta złożona po upływie terminu składania ofert",
        "niezgodna z ustawą Prawo zamówień publicznych lub innymi przepisami"
      ],
      lead:
        "Wyroki i postanowienia KIO w sprawach o odrzucenie oferty oraz o zaniechanie odrzucenia oferty konkurenta — przegląd przesłanek z art. 226 ustawy Pzp.",
      body: [
        "Katalog przesłanek odrzucenia oferty jest zamknięty i zawarty w art. 226 ust. 1 ustawy Pzp. Zamawiający nie może odrzucić oferty z powodu, którego ustawa nie przewiduje, a przesłanki odrzucenia — jako wyjątek od zasady wyboru najkorzystniejszej oferty — wykłada się ściśle.",
        "Odwołania w tej grupie mają dwa kierunki: wykonawca kwestionuje odrzucenie własnej oferty albo zarzuca zamawiającemu, że nie odrzucił oferty konkurenta. Izba bada, czy zamawiający wskazał w uzasadnieniu konkretną podstawę prawną i faktyczną — uzasadnienie odrzucenia wyznacza granice późniejszego sporu.",
        "Przed odrzuceniem zamawiający powinien rozważyć, czy wątpliwości nie da się usunąć w drodze wyjaśnień treści oferty albo poprawienia omyłki."
      ],
      articles: [
        {"226", "art. 226 — przesłanki odrzucenia oferty"},
        {"223", "art. 223 — wyjaśnienia treści oferty i poprawianie omyłek"},
        {"253", "art. 253 — informacja o odrzuceniu ofert"}
      ],
      faqs: [
        %{
          question:
            "Czy zamawiający może odrzucić ofertę z innego powodu niż wymienione w art. 226 Pzp?",
          answer:
            "Nie. Katalog z art. 226 ust. 1 Pzp jest zamknięty. Odrzucenie oferty na podstawie nieprzewidzianej w ustawie stanowi naruszenie przepisów i może zostać skutecznie zakwestionowane w odwołaniu do KIO."
        },
        %{
          question: "W jakim terminie można zaskarżyć odrzucenie oferty?",
          answer:
            "Odwołanie wnosi się w terminie 10 dni od przekazania informacji o odrzuceniu przy użyciu środków komunikacji elektronicznej w postępowaniach o wartości równej progom unijnym lub wyższej, a w postępowaniach poniżej progów — w terminie 5 dni."
        },
        %{
          question: "Czy zamawiający musi uzasadnić odrzucenie oferty?",
          answer:
            "Tak. Informacja o odrzuceniu musi zawierać uzasadnienie faktyczne i prawne (art. 253 ust. 1 pkt 2 Pzp). Izba ocenia czynność w granicach tego uzasadnienia — zamawiający nie może na rozprawie powołać się na nowe powody odrzucenia."
        },
        %{
          question: "Czy można odrzucić ofertę bez wezwania wykonawcy do wyjaśnień?",
          answer:
            "Jeżeli wątpliwości co do treści oferty dają się usunąć w drodze wyjaśnień albo poprawienia omyłki, odrzucenie bez skorzystania z tych instrumentów jest w orzecznictwie KIO uznawane za przedwczesne."
        },
        %{
          question: "Czy zamawiający może wycofać się z odrzucenia oferty?",
          answer:
            "Tak. Do chwili zawarcia umowy zamawiający może unieważnić własną czynność i powtórzyć badanie i ocenę ofert, jeżeli uzna, że odrzucenie było wadliwe. Często robi to po otrzymaniu odwołania, uwzględniając jego zarzuty."
        }
      ],
      blog: {"najczestsze-bledy-oferty-przetargowe", "Najczęstsze błędy w ofertach przetargowych"}
    },
    %{
      slug: "niezgodnosc-oferty-z-warunkami-zamowienia",
      name: "Niezgodność oferty z warunkami zamówienia",
      issues: [
        "niezgodność z warunkami zamówienia",
        "oferta niezgodna z warunkami zamówienia",
        "odrzucenie oferty z uwagi na niezgodność z treścią Specyfikacji istotnych warunków zamówienia",
        "niezgodna z treścią Specyfikacji istotnych warunków zamówienia lub z ustawą",
        "warunki zamówienia"
      ],
      lead:
        "Orzecznictwo KIO dotyczące odrzucenia oferty, której treść jest niezgodna z warunkami zamówienia (art. 226 ust. 1 pkt 5 Pzp, dawniej niezgodność z SIWZ).",
      body: [
        "Niezgodność z warunkami zamówienia to najczęściej stosowana podstawa odrzucenia oferty. Dotyczy merytorycznej treści oferty: zaoferowanego przedmiotu, sposobu i terminu realizacji albo innych elementów, które zamawiający opisał w dokumentach zamówienia.",
        "Zgodnie z utrwaloną linią orzeczniczą niezgodność musi być jednoznaczna i odnosić się do wymagań wyrażonych w dokumentach zamówienia w sposób jasny. Wątpliwości i nieprecyzyjne postanowienia SWZ rozstrzyga się na korzyść wykonawcy. Zamawiający ma obowiązek wskazać, który konkretnie element oferty nie odpowiada któremu wymaganiu.",
        "Odrzucenie jest dopuszczalne dopiero wtedy, gdy niezgodności nie można usunąć przez poprawienie omyłki na podstawie art. 223 ust. 2 pkt 3 Pzp."
      ],
      articles: [
        {"226", "art. 226 ust. 1 pkt 5 — niezgodność z warunkami zamówienia"},
        {"223", "art. 223 ust. 2 pkt 3 — poprawienie innych omyłek"},
        {"7", "art. 7 pkt 29 — definicja warunków zamówienia"}
      ],
      faqs: [
        %{
          question: "Czy każda rozbieżność między ofertą a SWZ uzasadnia odrzucenie?",
          answer:
            "Nie. Odrzucenie wymaga niezgodności merytorycznej z jasno sformułowanym wymaganiem. Jeżeli rozbieżność jest omyłką niepowodującą istotnych zmian w treści oferty, zamawiający powinien ją poprawić, a jeżeli wymaganie było niejednoznaczne — wątpliwości nie mogą obciążać wykonawcy."
        },
        %{
          question:
            "Czym różni się niezgodność z warunkami zamówienia od niespełnienia warunków udziału?",
          answer:
            "Warunki zamówienia dotyczą tego, co i jak wykonawca oferuje (treść oferty). Warunki udziału w postępowaniu dotyczą samego wykonawcy — jego doświadczenia, potencjału i sytuacji finansowej. Są to odrębne podstawy odrzucenia oferty."
        },
        %{
          question: "Kto musi wykazać niezgodność oferty z warunkami zamówienia?",
          answer:
            "Zamawiający, który odrzuca ofertę — musi wskazać konkretny element oferty i konkretne wymaganie dokumentów zamówienia, z którym jest on sprzeczny. W odwołaniu na zaniechanie odrzucenia oferty konkurenta ciężar ten spoczywa na odwołującym."
        },
        %{
          question: "Co, jeżeli wymaganie w SWZ było niejednoznaczne?",
          answer:
            "Wątpliwości interpretacyjne rozstrzyga się na korzyść wykonawcy. Zamawiający nie może odrzucić oferty na podstawie wymagania, które nie zostało wyrażone wprost, ani nadawać postanowieniom SWZ nowego znaczenia po otwarciu ofert."
        },
        %{
          question: "Czy wykonawca może usunąć niezgodność w ramach wyjaśnień?",
          answer:
            "Nie. Wyjaśnienia mogą jedynie doprecyzować treść oferty. Jeżeli w ich wyniku wykonawca zaoferowałby inny produkt lub inne warunki realizacji, doszłoby do niedozwolonej zmiany treści oferty."
        }
      ],
      blog: {"najczestsze-bledy-oferty-przetargowe", "Najczęstsze błędy w ofertach przetargowych"}
    },
    %{
      slug: "wykluczenie-wykonawcy",
      name: "Wykluczenie wykonawcy",
      issues: [
        "wykluczenie wykonawcy",
        "wykluczenie",
        "oferta złożona przez wykonawcę podlegającego wykluczeniu",
        "fakultatywne podstawy wykluczenia",
        "przesłanki wykluczenia",
        "podstawy wykluczenia",
        "brak podstaw wykluczenia",
        "naruszenie obowiązków zawodowych",
        "naruszenie obowiązków dotyczących płatności",
        "nieproporcjonalność wykluczenia",
        "wprowadzenie zamawiającego w błąd",
        "informacje wprowadzające w błąd",
        "niewykonanie lub nienależyte wykonanie zobowiązania"
      ],
      lead:
        "Orzeczenia KIO dotyczące obligatoryjnych i fakultatywnych podstaw wykluczenia wykonawcy z postępowania, w tym wprowadzenia zamawiającego w błąd i nienależytego wykonania wcześniejszych umów.",
      body: [
        "Ustawa Pzp rozróżnia obligatoryjne podstawy wykluczenia (art. 108), stosowane w każdym postępowaniu, oraz fakultatywne (art. 109), które obowiązują tylko wtedy, gdy zamawiający przewidział je w ogłoszeniu lub dokumentach zamówienia.",
        "W orzecznictwie dominują spory o wprowadzenie zamawiającego w błąd przy przedstawianiu informacji, poważne naruszenie obowiązków zawodowych oraz nienależyte wykonanie wcześniejszej umowy. Izba podkreśla, że wykluczenie jest sankcją dotkliwą, dlatego przesłanki należy interpretować ściśle, a zamawiający musi je wykazać — nie wystarczy samo podejrzenie.",
        "Wykluczenie na podstawach fakultatywnych wymaga dodatkowo oceny proporcjonalności, a wykonawca może uniknąć wykluczenia, przeprowadzając samooczyszczenie."
      ],
      articles: [
        {"108", "art. 108 — obligatoryjne podstawy wykluczenia"},
        {"109", "art. 109 — fakultatywne podstawy wykluczenia"},
        {"110", "art. 110 — samooczyszczenie"},
        {"111", "art. 111 — okres wykluczenia"}
      ],
      faqs: [
        %{
          question: "Czy zamawiający musi stosować fakultatywne podstawy wykluczenia?",
          answer:
            "Nie. Podstawy z art. 109 ust. 1 Pzp stosuje się tylko wtedy, gdy zamawiający wskazał je w ogłoszeniu o zamówieniu lub w dokumentach zamówienia. Podstawy z art. 108 Pzp obowiązują zawsze."
        },
        %{
          question: "Czy wykluczenie za wprowadzenie w błąd wymaga winy umyślnej?",
          answer:
            "Nie zawsze. Art. 109 ust. 1 pkt 8 Pzp dotyczy zamierzonego działania lub rażącego niedbalstwa, natomiast pkt 10 obejmuje także lekkomyślność i niedbalstwo, jeżeli informacje mogły mieć istotny wpływ na decyzje zamawiającego."
        },
        %{
          question: "Jak długo trwa wykluczenie z postępowań?",
          answer:
            "Zależy od podstawy (art. 111 Pzp). Przy poważnym naruszeniu obowiązków zawodowych i nienależytym wykonaniu umowy — 3 lata od zdarzenia, przy wprowadzeniu w błąd w wyniku zamierzonego działania lub rażącego niedbalstwa — 2 lata, a przy wprowadzeniu w błąd z lekkomyślności lub niedbalstwa — 1 rok."
        },
        %{
          question: "Czy zaległości podatkowe zawsze oznaczają wykluczenie?",
          answer:
            "Nie. Wykonawca nie podlega wykluczeniu, jeżeli przed upływem terminu składania ofert zapłacił należne podatki lub składki wraz z odsetkami albo zawarł wiążące porozumienie w sprawie ich spłaty."
        },
        %{
          question:
            "Czy podstawy wykluczenia bada się także wobec konsorcjantów i podmiotów trzecich?",
          answer:
            "Tak. Brak podstaw wykluczenia musi wykazać każdy z wykonawców wspólnie ubiegających się o zamówienie oraz podmiot udostępniający zasoby. Podmiot udostępniający zasoby, wobec którego zachodzą podstawy wykluczenia, można zastąpić innym (art. 122 Pzp)."
        }
      ],
      blog:
        {"wykluczenie-wykonawcy-z-przetargu-podstawy-i-samooczyszczenie",
         "Wykluczenie wykonawcy z przetargu — podstawy i samooczyszczenie"}
    },
    %{
      slug: "samooczyszczenie",
      name: "Samooczyszczenie (self-cleaning)",
      issues: ["samooczyszczenie"],
      lead:
        "Orzeczenia KIO oceniające skuteczność samooczyszczenia wykonawcy — procedury pozwalającej uniknąć wykluczenia mimo zaistnienia podstawy wykluczenia.",
      body: [
        "Samooczyszczenie (self-cleaning) uregulowane w art. 110 ust. 2 ustawy Pzp pozwala wykonawcy wykazać rzetelność mimo wystąpienia podstawy wykluczenia. Wymaga łącznego spełnienia trzech przesłanek: naprawienia lub zobowiązania się do naprawienia szkody, wyczerpującego wyjaśnienia faktów i okoliczności we współpracy z właściwymi organami lub zamawiającym oraz podjęcia konkretnych środków technicznych, organizacyjnych i kadrowych zapobiegających dalszym naruszeniom.",
        "Kluczowe w orzecznictwie jest to, że samooczyszczenie zakłada przyznanie się do nieprawidłowości. Wykonawca, który jednocześnie zaprzecza istnieniu podstawy wykluczenia, co do zasady nie może skutecznie się na nie powołać. Izba bada też moment złożenia wyjaśnień — powinny one zostać przedstawione z własnej inicjatywy, najpóźniej wraz z oświadczeniem o niepodleganiu wykluczeniu."
      ],
      articles: [
        {"110", "art. 110 — samooczyszczenie"},
        {"109", "art. 109 — fakultatywne podstawy wykluczenia"}
      ],
      faqs: [
        %{
          question: "Kiedy należy przeprowadzić samooczyszczenie?",
          answer:
            "Co do zasady wraz ze złożeniem oświadczenia o niepodleganiu wykluczeniu (np. w JEDZ), w którym wykonawca ujawnia zaistnienie podstawy wykluczenia. Zatajenie tej okoliczności i próba samooczyszczenia dopiero po jej wykryciu przez zamawiającego jest z reguły uznawana za spóźnioną."
        },
        %{
          question: "Jakie warunki musi spełnić samooczyszczenie?",
          answer:
            "Łącznie trzy: naprawienie lub zobowiązanie się do naprawienia szkody, wyczerpujące wyjaśnienie faktów i okoliczności we współpracy z organami lub zamawiającym oraz podjęcie konkretnych środków technicznych, organizacyjnych i kadrowych zapobiegających dalszym nieprawidłowościom."
        },
        %{
          question: "Czy samooczyszczenie jest możliwe przy każdej podstawie wykluczenia?",
          answer:
            "Nie. Art. 110 ust. 2 Pzp dopuszcza je przy podstawach z art. 108 ust. 1 pkt 1, 2 i 5 oraz art. 109 ust. 1 pkt 2–5 i 7–10. Nie obejmuje m.in. prawomocnie orzeczonego zakazu ubiegania się o zamówienia, a przy zaległościach podatkowych działa odrębny mechanizm — zapłata lub porozumienie w sprawie spłaty."
        },
        %{
          question: "Kto ocenia, czy samooczyszczenie było skuteczne?",
          answer:
            "Zamawiający. Ocenia, czy podjęte przez wykonawcę czynności są wystarczające do wykazania jego rzetelności, uwzględniając wagę i szczególne okoliczności czynu. Ocena ta podlega kontroli KIO."
        }
      ],
      blog:
        {"wykluczenie-wykonawcy-z-przetargu-podstawy-i-samooczyszczenie",
         "Wykluczenie wykonawcy z przetargu — podstawy i samooczyszczenie"}
    },
    %{
      slug: "warunki-udzialu-w-postepowaniu",
      name: "Warunki udziału w postępowaniu",
      issues: [
        "warunki udziału w postępowaniu",
        "oferta złożona przez wykonawcę niespełniającego warunków udziału w postępowaniu",
        "spełnienie warunków udziału w postępowaniu",
        "spełnianie warunków udziału w postępowaniu",
        "zdolność techniczna lub zawodowa",
        "sytuacja ekonomiczna lub finansowa",
        "doświadczenie",
        "wiedza i doświadczenie",
        "referencje"
      ],
      lead:
        "Orzecznictwo KIO o warunkach udziału w postępowaniu: proporcjonalność wymagań zamawiającego, ocena doświadczenia i referencji oraz skutki niewykazania spełnienia warunków.",
      body: [
        "Warunki udziału w postępowaniu mogą dotyczyć zdolności do występowania w obrocie gospodarczym, uprawnień do prowadzenia działalności, sytuacji ekonomicznej lub finansowej oraz zdolności technicznej lub zawodowej. Zamawiający określa je w sposób proporcjonalny do przedmiotu zamówienia, jako minimalne poziomy zdolności.",
        "Spory przed KIO mają dwa etapy. Na etapie SWZ wykonawcy zarzucają, że warunek jest nadmierny i ogranicza konkurencję. Po otwarciu ofert spór dotyczy tego, czy doświadczenie wykazane przez wykonawcę odpowiada literalnej treści warunku — Izba stoi na stanowisku, że warunku nie można po terminie składania ofert interpretować ani rozszerzająco, ani zawężająco.",
        "Jeżeli wykonawca nie wykazał spełnienia warunku, zamawiający przed odrzuceniem oferty musi wezwać go do uzupełnienia podmiotowych środków dowodowych."
      ],
      articles: [
        {"112", "art. 112 — warunki udziału w postępowaniu"},
        {"116", "art. 116 — zdolność techniczna lub zawodowa"},
        {"118", "art. 118 — poleganie na zasobach podmiotów udostępniających"},
        {"226", "art. 226 ust. 1 pkt 2 lit. b — odrzucenie oferty"}
      ],
      faqs: [
        %{
          question: "Czy można zaskarżyć zbyt wygórowany warunek udziału?",
          answer:
            "Tak, ale w terminie liczonym od publikacji ogłoszenia lub zamieszczenia dokumentów zamówienia na stronie internetowej (10 dni powyżej progów unijnych, 5 dni poniżej). Po upływie tego terminu treść warunku jest wiążąca i nie może być kwestionowana przy okazji odwołania od oceny ofert."
        },
        %{
          question: "Czy doświadczenie konsorcjum można wykorzystać samodzielnie?",
          answer:
            "Tylko w zakresie, w jakim wykonawca faktycznie i konkretnie uczestniczył w realizacji zamówienia. Zgodnie z orzecznictwem TSUE (sprawa Esaprojekt) i KIO nie można powoływać się na doświadczenie całego konsorcjum, jeżeli samemu wykonało się jedynie część prac."
        },
        %{
          question: "Czy można wykazać spełnienie warunku zasobami innego podmiotu?",
          answer:
            "Tak, na podstawie art. 118 Pzp, składając wraz z ofertą zobowiązanie podmiotu udostępniającego zasoby. W przypadku wykształcenia, kwalifikacji zawodowych i doświadczenia podmiot ten musi faktycznie wykonać roboty lub usługi, do których zdolności te są wymagane."
        },
        %{
          question: "Czy zamawiający może po otwarciu ofert złagodzić albo zaostrzyć warunek?",
          answer:
            "Nie. Ocena spełniania warunku odbywa się według jego literalnego brzmienia z dokumentów zamówienia. Zmiana wykładni po terminie składania ofert narusza zasadę równego traktowania wykonawców."
        },
        %{
          question: "Co się dzieje, gdy wykonawca nie wykaże spełnienia warunku?",
          answer:
            "Zamawiający najpierw wzywa do uzupełnienia lub poprawienia podmiotowych środków dowodowych (art. 128 ust. 1 Pzp). Dopiero gdy wezwanie okaże się bezskuteczne, oferta podlega odrzuceniu na podstawie art. 226 ust. 1 pkt 2 lit. b Pzp."
        }
      ],
      blog: nil
    },
    %{
      slug: "wezwanie-do-uzupelnienia-dokumentow",
      name: "Wezwanie do uzupełnienia dokumentów",
      issues: [
        "wezwanie do uzupełnienia dokumentów lub oświadczeń",
        "wezwanie do uzupełnienia dokumentów",
        "uzupełnienie oświadczeń i dokumentów",
        "podmiotowe środki dowodowe",
        "podmiotowy środek dowodowy",
        "oferta złożona przez wykonawcę, który nie złożył dokumentów lub oświadczeń",
        "aktualność dokumentów",
        "wyjaśnienia oświadczeń lub dokumentów",
        "wezwanie do wyjaśnienia dokumentów lub oświadczeń",
        "JEDZ"
      ],
      lead:
        "Orzeczenia KIO dotyczące wezwania do złożenia, poprawienia lub uzupełnienia podmiotowych środków dowodowych i oświadczeń (art. 128 Pzp) oraz zasady jednokrotności wezwania.",
      body: [
        "Jeżeli wykonawca nie złożył oświadczenia o niepodleganiu wykluczeniu i spełnianiu warunków, podmiotowych środków dowodowych lub innych dokumentów albo są one niekompletne lub zawierają błędy, zamawiający wzywa go do ich złożenia, poprawienia lub uzupełnienia w wyznaczonym terminie. Wezwanie jest obowiązkiem zamawiającego, a nie jego uprawnieniem.",
        "Orzecznictwo KIO ukształtowało zasadę jednokrotności wezwania: w odniesieniu do tego samego braku zamawiający wzywa tylko raz. Warunkiem jest jednak, by wezwanie było precyzyjne — wezwanie ogólnikowe, które nie wskazuje, czego brakuje, nie zamyka drogi do ponownego wezwania.",
        "Uzupełniane dokumenty muszą potwierdzać spełnianie warunków i brak podstaw wykluczenia na dzień ich złożenia. Sporne bywa także zastępowanie pierwotnie wskazanego doświadczenia nowym."
      ],
      articles: [
        {"128", "art. 128 — uzupełnianie i wyjaśnianie dokumentów"},
        {"126", "art. 126 — wezwanie do złożenia podmiotowych środków dowodowych"},
        {"125", "art. 125 — oświadczenie wstępne (JEDZ)"}
      ],
      faqs: [
        %{
          question: "Ile razy zamawiający może wezwać do uzupełnienia tego samego dokumentu?",
          answer:
            "Co do zasady raz. Zasada jednokrotności wezwania wynika z orzecznictwa KIO i zasady równego traktowania wykonawców. Ponowne wezwanie jest dopuszczalne, gdy pierwsze było wadliwe lub niejednoznaczne albo dotyczy innego braku."
        },
        %{
          question: "Czy przedmiotowe środki dowodowe też podlegają uzupełnieniu?",
          answer:
            "Tylko jeżeli zamawiający przewidział taką możliwość w ogłoszeniu lub dokumentach zamówienia (art. 107 ust. 2 Pzp). W przeciwnym razie brak przedmiotowego środka dowodowego skutkuje odrzuceniem oferty."
        },
        %{
          question: "Na jaki dzień dokumenty muszą być aktualne?",
          answer:
            "Podmiotowe środki dowodowe mają być aktualne na dzień ich złożenia (art. 126 ust. 1 Pzp). Muszą przy tym potwierdzać, że wykonawca spełniał warunki udziału i nie podlegał wykluczeniu przez cały czas trwania postępowania."
        },
        %{
          question: "Co grozi za nieuzupełnienie dokumentów na wezwanie?",
          answer:
            "Odrzucenie oferty na podstawie art. 226 ust. 1 pkt 2 lit. c Pzp, a jeżeli brak uzupełnienia wynikał z przyczyn leżących po stronie wykonawcy i uniemożliwił wybór jego oferty — także zatrzymanie wadium."
        },
        %{
          question: "Czy przy uzupełnieniu można wskazać inne doświadczenie niż pierwotnie?",
          answer:
            "W orzecznictwie KIO dopuszcza się zastąpienie pierwotnie wskazanej realizacji inną, jeżeli pierwsza nie potwierdzała spełnienia warunku. Nie jest to możliwe, gdy pierwotna informacja była nieprawdziwa i wprowadzała zamawiającego w błąd."
        }
      ],
      blog: nil
    },
    %{
      slug: "przedmiotowe-srodki-dowodowe",
      name: "Przedmiotowe środki dowodowe",
      issues: ["przedmiotowe środki dowodowe", "certyfikat", "certyfikat/atest"],
      lead:
        "Orzecznictwo KIO o przedmiotowych środkach dowodowych: certyfikatach, kartach katalogowych, próbkach oraz o możliwości ich uzupełnienia.",
      body: [
        "Przedmiotowe środki dowodowe potwierdzają, że oferowane dostawy, usługi lub roboty spełniają wymagania, cechy lub kryteria określone przez zamawiającego. Składa się je wraz z ofertą. Zamawiający może ich żądać tylko wtedy, gdy wskazał je w ogłoszeniu lub dokumentach zamówienia, a żądanie musi być proporcjonalne i związane z przedmiotem zamówienia.",
        "Najwięcej sporów dotyczy uzupełniania: przedmiotowy środek dowodowy można uzupełnić wyłącznie wtedy, gdy zamawiający zastrzegł to w dokumentach zamówienia, i nigdy wtedy, gdy służy on ocenie w kryteriach oceny ofert. Izba rozróżnia też dokument, który jest środkiem dowodowym, od dokumentu, który stanowi treść oferty — ten drugi uzupełnieniu nie podlega.",
        "Zamawiający musi akceptować równoważne środki dowodowe, w tym równoważne certyfikaty i etykiety."
      ],
      articles: [
        {"104", "art. 104 — etykiety"},
        {"105", "art. 105 — certyfikaty"},
        {"106", "art. 106 — przedmiotowe środki dowodowe"},
        {"107", "art. 107 — składanie i uzupełnianie"}
      ],
      faqs: [
        %{
          question: "Czy brak karty katalogowej można uzupełnić?",
          answer:
            "Tylko gdy zamawiający przewidział uzupełnianie przedmiotowych środków dowodowych w dokumentach zamówienia. Jeżeli karta katalogowa służy identyfikacji oferowanego produktu, KIO często uznaje ją za treść oferty, której uzupełnić nie można."
        },
        %{
          question: "Czym przedmiotowe środki dowodowe różnią się od podmiotowych?",
          answer:
            "Przedmiotowe dotyczą tego, co wykonawca oferuje — potwierdzają zgodność dostaw, usług lub robót z wymaganiami. Podmiotowe dotyczą samego wykonawcy: braku podstaw wykluczenia i spełniania warunków udziału w postępowaniu."
        },
        %{
          question: "Czy zamawiający musi zaakceptować równoważny certyfikat?",
          answer:
            "Tak. Jeżeli żąda określonego certyfikatu lub etykiety, musi akceptować certyfikaty i etykiety równoważne, a w uzasadnionych przypadkach także inne odpowiednie środki dowodowe potwierdzające spełnienie wymagań."
        },
        %{
          question:
            "Czy zamawiający może żądać wyjaśnień do złożonych przedmiotowych środków dowodowych?",
          answer:
            "Tak. Art. 107 ust. 4 Pzp pozwala żądać wyjaśnień dotyczących treści przedmiotowych środków dowodowych — niezależnie od tego, czy zamawiający przewidział możliwość ich uzupełniania."
        }
      ],
      blog: nil
    },
    %{
      slug: "tajemnica-przedsiebiorstwa",
      name: "Tajemnica przedsiębiorstwa",
      issues: [
        "tajemnica przedsiębiorstwa",
        "zastrzeżenie tajemnicy przedsiębiorstwa",
        "zasada jawności postępowania",
        "zasada jawności"
      ],
      lead:
        "Orzeczenia KIO w sprawach o odtajnienie informacji zastrzeżonych jako tajemnica przedsiębiorstwa — wykazów, wyjaśnień rażąco niskiej ceny i części ofert.",
      body: [
        "Postępowanie o udzielenie zamówienia jest jawne, a zastrzeżenie tajemnicy przedsiębiorstwa stanowi wyjątek od tej zasady. Zgodnie z art. 18 ust. 3 ustawy Pzp wykonawca musi zastrzec informacje i wykazać, że stanowią one tajemnicę przedsiębiorstwa, wraz z ich przekazaniem — nie później.",
        "Izba wymaga wykazania wszystkich przesłanek z art. 11 ust. 2 ustawy o zwalczaniu nieuczciwej konkurencji: że informacja ma wartość gospodarczą, nie jest powszechnie znana i że podjęto konkretne działania w celu utrzymania jej w poufności. Ogólnikowe uzasadnienie, powielane w wielu postępowaniach i niepoparte dowodami, prowadzi do nakazania odtajnienia.",
        "Nie można zastrzec informacji odczytywanych podczas otwarcia ofert, w szczególności ceny. Częstym przedmiotem sporu są zastrzeżone wyjaśnienia rażąco niskiej ceny i wykazy osób."
      ],
      articles: [
        {"18", "art. 18 — zasada jawności i tajemnica przedsiębiorstwa"},
        {"74", "art. 74 — jawność protokołu postępowania"},
        {"222", "art. 222 — informacje podawane po otwarciu ofert"}
      ],
      faqs: [
        %{
          question: "Kiedy trzeba uzasadnić zastrzeżenie tajemnicy przedsiębiorstwa?",
          answer:
            "Jednocześnie z przekazaniem zastrzeganych informacji. Uzasadnienie złożone później — np. dopiero na wezwanie zamawiającego albo w toku postępowania odwoławczego — jest spóźnione i nie sanuje braku."
        },
        %{
          question: "Czy można zastrzec całość wyjaśnień rażąco niskiej ceny?",
          answer:
            "KIO podchodzi do tego krytycznie. Zastrzeżenie powinno obejmować tylko te informacje, które rzeczywiście mają wartość gospodarczą. Zastrzeżenie całego dokumentu, łącznie z ogólnymi twierdzeniami i informacjami publicznie dostępnymi, zwykle kończy się nakazem odtajnienia."
        },
        %{
          question: "Co trzeba wykazać, zastrzegając tajemnicę przedsiębiorstwa?",
          answer:
            "Trzy przesłanki z art. 11 ust. 2 ustawy o zwalczaniu nieuczciwej konkurencji: że informacja ma wartość gospodarczą, że nie jest powszechnie znana ani łatwo dostępna oraz że wykonawca podjął konkretne działania w celu utrzymania jej w poufności."
        },
        %{
          question: "Czy cenę oferty można objąć tajemnicą przedsiębiorstwa?",
          answer:
            "Nie. Nazw wykonawców oraz cen lub kosztów zawartych w ofertach, które zamawiający udostępnia po otwarciu ofert (art. 222 ust. 5 Pzp), nie można zastrzec."
        },
        %{
          question: "Jak doprowadzić do odtajnienia dokumentów konkurenta?",
          answer:
            "Trzeba wnieść odwołanie do KIO na zaniechanie odtajnienia, w terminie liczonym od dnia, w którym zamawiający odmówił udostępnienia dokumentów. W odwołaniu wykazuje się, że uzasadnienie zastrzeżenia nie spełnia ustawowych przesłanek."
        }
      ],
      blog:
        {"tajemnica-przedsiebiorstwa-w-przetargu-jak-skutecznie-zastrzec",
         "Tajemnica przedsiębiorstwa w przetargu — jak skutecznie zastrzec informacje"}
    },
    %{
      slug: "czyn-nieuczciwej-konkurencji",
      name: "Czyn nieuczciwej konkurencji",
      issues: [
        "czyn nieuczciwej konkurencji",
        "oferta złożona w warunkach czynu nieuczciwej konkurencji",
        "odrzucenie oferty z uwagi na: jej złożenie stanowi czyn nieuczciwej konkurencji",
        "nieuczciwa konkurencja",
        "zmowa przetargowa"
      ],
      lead:
        "Orzecznictwo KIO dotyczące ofert złożonych w warunkach czynu nieuczciwej konkurencji: manipulacji cenami jednostkowymi, inżynierii cenowej i zmów przetargowych.",
      body: [
        "Zamawiający odrzuca ofertę, która została złożona w warunkach czynu nieuczciwej konkurencji w rozumieniu ustawy o zwalczaniu nieuczciwej konkurencji (art. 226 ust. 1 pkt 7 Pzp). Podstawą jest najczęściej klauzula generalna z art. 3 ust. 1 tej ustawy — działanie sprzeczne z prawem lub dobrymi obyczajami, które zagraża lub narusza interes innego przedsiębiorcy lub klienta.",
        "Typowe stany faktyczne to przerzucanie kosztów między pozycjami cenowymi w celu uzyskania przewagi w kryteriach oceny ofert, wycena wybranych pozycji na poziomie symbolicznym oraz składanie oferty w celu utrudnienia dostępu do rynku. Izba wymaga od odwołującego konkretnego wykazania przesłanek czynu — samo stwierdzenie nietypowej struktury ceny nie wystarcza.",
        "Odrębną kategorią jest zmowa przetargowa, która stanowi podstawę wykluczenia z art. 108 ust. 1 pkt 5 Pzp i może być wykazywana dowodami pośrednimi."
      ],
      articles: [
        {"226", "art. 226 ust. 1 pkt 7 — odrzucenie oferty"},
        {"108", "art. 108 ust. 1 pkt 5 — porozumienie zakłócające konkurencję"}
      ],
      faqs: [
        %{
          question: "Czy manipulacja cenami jednostkowymi jest czynem nieuczciwej konkurencji?",
          answer:
            "Może nim być. KIO uznaje za czyn nieuczciwej konkurencji takie ukształtowanie cen, które nie ma uzasadnienia ekonomicznego i służy wyłącznie uzyskaniu wyższej punktacji lub wcześniejszych płatności kosztem konkurentów i zamawiającego."
        },
        %{
          question: "Kto musi udowodnić czyn nieuczciwej konkurencji?",
          answer:
            "Ten, kto się na niego powołuje — zamawiający odrzucający ofertę albo odwołujący, który domaga się odrzucenia oferty konkurenta. Trzeba wykazać wszystkie przesłanki czynu, w tym zagrożenie lub naruszenie interesu innego przedsiębiorcy lub klienta."
        },
        %{
          question: "Czy zaniżona cena jest czynem nieuczciwej konkurencji?",
          answer:
            "Sama niska cena — nie. Czynem nieuczciwej konkurencji jest sprzedaż poniżej kosztów w celu eliminacji innych przedsiębiorców (art. 15 ust. 1 pkt 1 uznk), co wymaga wykazania tego celu. Zaniżoną cenę bada się przede wszystkim w procedurze rażąco niskiej ceny."
        },
        %{
          question: "Czy oferty spółek z jednej grupy kapitałowej oznaczają zmowę przetargową?",
          answer:
            "Nie automatycznie. Wykonawcy należący do tej samej grupy kapitałowej, którzy złożyli odrębne oferty, podlegają wykluczeniu, chyba że wykażą, że przygotowali je niezależnie od siebie (art. 108 ust. 1 pkt 5 Pzp)."
        }
      ],
      blog: nil
    },
    %{
      slug: "blad-w-obliczeniu-ceny",
      name: "Błąd w obliczeniu ceny",
      issues: ["błąd w obliczeniu ceny", "podatek VAT", "VAT"],
      lead:
        "Wyroki KIO dotyczące odrzucenia oferty z powodu błędu w obliczeniu ceny lub kosztu, w tym zastosowania nieprawidłowej stawki VAT.",
      body: [
        "Oferta zawierająca błąd w obliczeniu ceny lub kosztu podlega odrzuceniu na podstawie art. 226 ust. 1 pkt 10 ustawy Pzp. Błąd ten należy odróżnić od omyłki rachunkowej: omyłka polega na wadliwym wykonaniu działania arytmetycznego i podlega poprawieniu, natomiast błąd w obliczeniu ceny dotyczy przyjęcia nieprawidłowych założeń kalkulacji i jest niepoprawialny.",
        "Klasycznym przykładem jest zastosowanie niewłaściwej stawki VAT. Zgodnie z uchwałami Sądu Najwyższego z 2011 r., podtrzymywanymi w orzecznictwie KIO, przyjęcie błędnej stawki podatku stanowi błąd w obliczeniu ceny, jeżeli zamawiający nie narzucił stawki w dokumentach zamówienia. Inne przykłady to pominięcie elementu przedmiotu zamówienia w wycenie albo kalkulacja sprzeczna ze sposobem obliczenia ceny opisanym w SWZ."
      ],
      articles: [
        {"226", "art. 226 ust. 1 pkt 10 — błąd w obliczeniu ceny lub kosztu"},
        {"223", "art. 223 ust. 2 pkt 2 — oczywiste omyłki rachunkowe"},
        {"225", "art. 225 — obowiązek podatkowy zamawiającego"}
      ],
      faqs: [
        %{
          question: "Czy błędna stawka VAT zawsze oznacza odrzucenie oferty?",
          answer:
            "Co do zasady tak, jeżeli zamawiający nie wskazał stawki w SWZ, a wykonawca zastosował stawkę niezgodną z przepisami. Jeżeli zamawiający sam podał stawkę, a wykonawca wpisał inną, w grę może wchodzić poprawienie omyłki."
        },
        %{
          question: "Czym błąd w obliczeniu ceny różni się od omyłki rachunkowej?",
          answer:
            "Omyłka rachunkowa to błędny wynik działania arytmetycznego — zamawiający ją poprawia. Błąd w obliczeniu ceny polega na przyjęciu nieprawidłowych założeń kalkulacji, np. złej stawki VAT lub niewłaściwej podstawy wyceny, i nie podlega poprawieniu."
        },
        %{
          question: "Czy zamawiający może poprawić błąd w obliczeniu ceny?",
          answer:
            "Nie. Oferta z takim błędem podlega odrzuceniu na podstawie art. 226 ust. 1 pkt 10 Pzp. Poprawić można wyłącznie omyłki wymienione w art. 223 ust. 2 Pzp."
        },
        %{
          question: "Czy pominięcie pozycji w kosztorysie to błąd w obliczeniu ceny?",
          answer:
            "To zależy od rodzaju wynagrodzenia. Przy wynagrodzeniu ryczałtowym kosztorys ma zwykle charakter pomocniczy i pominięcie pozycji nie przesądza o odrzuceniu. Przy wynagrodzeniu kosztorysowym brak wyceny wymaganej pozycji może oznaczać niezgodność oferty z warunkami zamówienia."
        }
      ],
      blog: nil
    },
    %{
      slug: "wyjasnienia-tresci-oferty-i-poprawianie-omylek",
      name: "Wyjaśnienia treści oferty i poprawianie omyłek",
      issues: [
        "wyjaśnienia treści oferty",
        "wezwanie do wyjaśnienia treści oferty",
        "zmiana treści oferty",
        "oczywiste omyłki pisarskie",
        "omyłka pisarska",
        "omyłka rachunkowa",
        "poprawienie omyłki",
        "omyłka polegająca na niezgodności oferty z dokumentami zamówienia",
        "oczywiste pomyłki, korekta",
        "inna omyłka"
      ],
      lead:
        "Orzeczenia KIO o granicach wyjaśniania treści oferty i poprawiania omyłek pisarskich, rachunkowych oraz innych omyłek (art. 223 Pzp) bez niedozwolonych negocjacji.",
      body: [
        "W toku badania ofert zamawiający może żądać od wykonawców wyjaśnień dotyczących treści złożonych ofert. Niedopuszczalne jest prowadzenie negocjacji i dokonywanie zmian w treści oferty — z wyjątkiem poprawienia omyłek wskazanych w art. 223 ust. 2 ustawy Pzp.",
        "Zamawiający poprawia oczywiste omyłki pisarskie, oczywiste omyłki rachunkowe z uwzględnieniem konsekwencji rachunkowych oraz inne omyłki polegające na niezgodności oferty z dokumentami zamówienia, niepowodujące istotnych zmian w treści oferty. To właśnie pojęcie istotnej zmiany jest osią większości sporów: Izba ocenia je przez pryzmat znaczenia poprawki dla całości świadczenia i tego, czy zamawiający mógł ją przeprowadzić samodzielnie, na podstawie pozostałej treści oferty.",
        "O poprawieniu innej omyłki zamawiający zawiadamia wykonawcę i wyznacza mu termin na wyrażenie zgody lub zakwestionowanie poprawki. Brak odpowiedzi uznaje się za zgodę, a zakwestionowanie poprawienia omyłki prowadzi do odrzucenia oferty."
      ],
      articles: [
        {"223", "art. 223 — wyjaśnienia treści oferty i poprawianie omyłek"},
        {"226", "art. 226 ust. 1 pkt 11 — zakwestionowanie poprawienia omyłki"}
      ],
      faqs: [
        %{
          question: "Czy wyjaśnienia mogą zmienić treść oferty?",
          answer:
            "Nie. Wyjaśnienia mogą jedynie doprecyzować to, co już wynika z oferty. Jeżeli w ich wyniku wykonawca oferuje coś innego niż pierwotnie, dochodzi do niedozwolonej zmiany treści oferty."
        },
        %{
          question: "Czy zamawiający ma obowiązek wezwać do wyjaśnień treści oferty?",
          answer:
            "Przepis posługuje się sformułowaniem „może”, ale w orzecznictwie KIO przyjmuje się, że gdy wątpliwości da się usunąć w drodze wyjaśnień, odrzucenie oferty bez ich żądania jest przedwczesne."
        },
        %{
          question: "Jaką omyłkę uznaje się za oczywistą?",
          answer:
            "Taką, która jest widoczna na pierwszy rzut oka i której poprawienie nie wymaga ustalania zamiaru wykonawcy — np. literówka, błędna data albo rozbieżność, którą da się skorygować na podstawie pozostałej treści oferty."
        },
        %{
          question: "Czy wykonawca musi zgodzić się na poprawienie innej omyłki?",
          answer:
            "Zamawiający wyznacza wykonawcy termin na wyrażenie zgody na poprawienie omyłki lub jej zakwestionowanie. Brak odpowiedzi uznaje się za zgodę. Jeżeli wykonawca zakwestionuje poprawienie, jego oferta podlega odrzuceniu (art. 226 ust. 1 pkt 11 Pzp)."
        },
        %{
          question: "Czy poprawienie omyłki może zmienić cenę oferty?",
          answer:
            "Tak. Poprawienie omyłki rachunkowej uwzględnia jej konsekwencje rachunkowe, a więc może zmienić cenę. Także przy innej omyłce sama zmiana ceny nie przesądza o istotności — ocenia się jej skalę i znaczenie dla całości oferty."
        }
      ],
      blog: nil
    },
    %{
      slug: "wadium",
      name: "Wadium",
      issues: ["wadium"],
      lead:
        "Orzecznictwo KIO w sprawach wadium: prawidłowość gwarancji wadialnej, wadium konsorcjum, utrzymanie wadium oraz jego zatrzymanie.",
      body: [
        "Wadium zabezpiecza zamawiającego przed nierzetelnym zachowaniem wykonawcy. Wnosi się je przed upływem terminu składania ofert i utrzymuje nieprzerwanie do dnia upływu terminu związania ofertą. Oferta wykonawcy, który nie wniósł wadium, wniósł je w sposób nieprawidłowy lub nie utrzymywał go nieprzerwanie, podlega odrzuceniu.",
        "Spory przed KIO koncentrują się na treści gwarancji wadialnych: czy gwarancja obejmuje wszystkie ustawowe przesłanki zatrzymania wadium, czy jest bezwarunkowa i płatna na pierwsze żądanie, czy termin jej ważności pokrywa cały okres związania ofertą oraz czy gwarancja wystawiona na jednego członka konsorcjum zabezpiecza ofertę wspólną. Wadium w formie gwarancji lub poręczenia przekazuje się w oryginale w postaci elektronicznej."
      ],
      articles: [
        {"97", "art. 97 — wadium"},
        {"98", "art. 98 — zwrot i zatrzymanie wadium"},
        {"226", "art. 226 ust. 1 pkt 14 — odrzucenie oferty"}
      ],
      faqs: [
        %{
          question: "Czy gwarancja wadialna wystawiona na lidera konsorcjum jest wystarczająca?",
          answer:
            "Zależy od treści gwarancji. Po wyroku Sądu Najwyższego z 15 lutego 2018 r. (IV CSK 86/17) przyjmuje się, że sama okoliczność wskazania w gwarancji tylko jednego konsorcjanta nie przesądza o wadliwości wadium — decyduje to, czy gwarancja pozwala zamawiającemu zaspokoić się w razie zdarzeń dotyczących pozostałych członków konsorcjum."
        },
        %{
          question: "Ile wynosi wadium w przetargu?",
          answer:
            "Nie więcej niż 3% wartości zamówienia w postępowaniach o wartości równej progom unijnym lub wyższej i nie więcej niż 1,5% w postępowaniach poniżej progów. Żądanie wadium jest uprawnieniem zamawiającego, a nie obowiązkiem."
        },
        %{
          question: "Kiedy zamawiający zatrzymuje wadium?",
          answer:
            "Gdy wykonawca z przyczyn leżących po jego stronie nie uzupełnił dokumentów na wezwanie, co uniemożliwiło wybór jego oferty, a także gdy wybrany wykonawca odmówił podpisania umowy, nie wniósł zabezpieczenia należytego wykonania umowy albo zawarcie umowy stało się niemożliwe z jego winy (art. 98 ust. 6 Pzp)."
        },
        %{
          question: "Czy wadium można uzupełnić po terminie składania ofert?",
          answer:
            "Nie. Wadium musi zostać wniesione przed upływem terminu składania ofert, a wadium w pieniądzu musi w tym czasie znaleźć się na rachunku zamawiającego. Brak lub wadliwość wadium skutkuje odrzuceniem oferty."
        }
      ],
      blog:
        {"wadium-w-przetargu-formy-gwarancja-zwrot-i-zatrzymanie",
         "Wadium w przetargu — formy, gwarancja, zwrot i zatrzymanie"}
    },
    %{
      slug: "termin-zwiazania-oferta",
      name: "Termin związania ofertą",
      issues: [
        "termin związania ofertą",
        "brak zgody na przedłużenie terminu związania ofertą"
      ],
      lead:
        "Orzeczenia KIO dotyczące terminu związania ofertą, jego przedłużania oraz skutków braku zgody wykonawcy na przedłużenie.",
      body: [
        "Wykonawca jest związany ofertą przez okres wskazany w dokumentach zamówienia — nie dłużej niż 90 dni w postępowaniach powyżej progów unijnych (120 dni przy zamówieniach o najwyższej wartości) i 30 dni w trybie podstawowym. Przed upływem tego terminu zamawiający może jednokrotnie zwrócić się do wykonawców o jego przedłużenie o wskazany okres.",
        "Przedłużenie wymaga pisemnego oświadczenia wykonawcy o wyrażeniu zgody i jest dopuszczalne tylko z jednoczesnym przedłużeniem okresu ważności wadium. Oferta wykonawcy, który nie wyraził pisemnej zgody na przedłużenie terminu związania ofertą, podlega odrzuceniu.",
        "W orzecznictwie rozważa się też wybór oferty po upływie terminu związania: zamawiający wzywa wówczas wykonawcę do wyrażenia zgody na wybór jego oferty."
      ],
      articles: [
        {"220", "art. 220 — termin związania ofertą (powyżej progów)"},
        {"307", "art. 307 — termin związania ofertą (tryb podstawowy)"},
        {"226", "art. 226 ust. 1 pkt 12 — brak zgody na przedłużenie"},
        {"252", "art. 252 — wybór oferty po upływie terminu związania"}
      ],
      faqs: [
        %{
          question:
            "Czy milczenie wykonawcy oznacza zgodę na przedłużenie terminu związania ofertą?",
          answer:
            "Nie. Ustawa wymaga pisemnego oświadczenia o wyrażeniu zgody. Brak odpowiedzi na wezwanie zamawiającego skutkuje odrzuceniem oferty na podstawie art. 226 ust. 1 pkt 12 Pzp."
        },
        %{
          question: "Ile trwa termin związania ofertą?",
          answer:
            "Nie dłużej niż 90 dni od terminu składania ofert w postępowaniach powyżej progów unijnych (120 dni przy zamówieniach o najwyższej wartości) i nie dłużej niż 30 dni w trybie podstawowym. Konkretny termin zamawiający wskazuje w dokumentach zamówienia, podając datę."
        },
        %{
          question: "Czy można wybrać ofertę po upływie terminu związania ofertą?",
          answer:
            "Tak. Zamawiający wzywa wówczas wykonawcę, którego oferta otrzymała najwyższą ocenę, do wyrażenia pisemnej zgody na wybór jego oferty. W razie braku zgody zwraca się do kolejnego wykonawcy (art. 252 Pzp)."
        },
        %{
          question: "Czy przedłużenie terminu związania ofertą wymaga przedłużenia wadium?",
          answer:
            "Tak. Jeżeli w postępowaniu żądano wadium, zgoda na przedłużenie terminu związania ofertą jest skuteczna tylko z jednoczesnym przedłużeniem okresu ważności wadium albo wniesieniem nowego wadium na przedłużony okres."
        }
      ],
      blog: nil
    },
    %{
      slug: "opis-przedmiotu-zamowienia",
      name: "Opis przedmiotu zamówienia",
      issues: [
        "opis przedmiotu zamówienia",
        "OPZ",
        "oferta równoważna",
        "przedmiot zamówienia",
        "odwołanie na SWZ"
      ],
      lead:
        "Orzecznictwo KIO dotyczące opisu przedmiotu zamówienia: wymagania ograniczające konkurencję, wskazywanie znaków towarowych i rozwiązania równoważne.",
      body: [
        "Przedmiot zamówienia opisuje się w sposób jednoznaczny i wyczerpujący, za pomocą dostatecznie dokładnych i zrozumiałych określeń, uwzględniając wymagania i okoliczności mogące mieć wpływ na sporządzenie oferty. Opisu nie można formułować w sposób, który mógłby utrudniać uczciwą konkurencję.",
        "W odwołaniach na treść SWZ wykonawcy zarzucają najczęściej, że parametry techniczne wskazują na produkt jednego producenta. Izba przyjmuje, że zamawiający ma prawo opisać przedmiot zamówienia zgodnie ze swoimi obiektywnymi i uzasadnionymi potrzebami, nawet jeżeli nie każdy wykonawca może je zaspokoić — musi jednak te potrzeby wykazać. Dla stwierdzenia naruszenia wystarcza uprawdopodobnienie, że opis mógłby utrudniać konkurencję.",
        "Wskazanie znaku towarowego, patentu lub pochodzenia jest dopuszczalne wyjątkowo i wymaga dopuszczenia rozwiązań równoważnych wraz z określeniem kryteriów równoważności."
      ],
      articles: [
        {"99", "art. 99 — opis przedmiotu zamówienia"},
        {"100", "art. 100 — dostępność dla osób niepełnosprawnych"},
        {"101", "art. 101 — normy i rozwiązania równoważne"}
      ],
      faqs: [
        %{
          question:
            "Czy zamawiający może opisać przedmiot zamówienia przez wskazanie konkretnej marki?",
          answer:
            "Tylko jeżeli jest to uzasadnione specyfiką przedmiotu zamówienia i nie można go opisać wystarczająco precyzyjnie w inny sposób. Wskazaniu muszą towarzyszyć wyrazy „lub równoważny” oraz kryteria oceny równoważności."
        },
        %{
          question: "Do kiedy można wnieść odwołanie na opis przedmiotu zamówienia?",
          answer:
            "W terminie 10 dni (powyżej progów unijnych) albo 5 dni (poniżej progów) od publikacji ogłoszenia lub zamieszczenia dokumentów zamówienia na stronie internetowej. Po tym terminie postanowień OPZ nie można już skutecznie kwestionować."
        },
        %{
          question: "Kto musi udowodnić, że opis przedmiotu zamówienia ogranicza konkurencję?",
          answer:
            "Odwołującemu wystarczy uprawdopodobnić, że opis mógłby utrudniać uczciwą konkurencję. Wtedy to zamawiający powinien wykazać, że sporne wymagania wynikają z jego obiektywnych i uzasadnionych potrzeb."
        },
        %{
          question: "Czy zamawiający musi dopuścić produkty wszystkich producentów?",
          answer:
            "Nie. Zamawiający nie ma obowiązku opisywać przedmiotu zamówienia tak, by ofertę mógł złożyć każdy wykonawca. Ograniczenie kręgu produktów jest dopuszczalne, jeżeli wynika z rzeczywistych potrzeb, a nie z zamiaru preferowania konkretnego rozwiązania."
        },
        %{
          question: "Kto wykazuje równoważność oferowanego rozwiązania?",
          answer:
            "Wykonawca. Jeżeli powołuje się na rozwiązanie równoważne opisanemu w dokumentach zamówienia, musi udowodnić w ofercie, że spełnia ono wymagania zamawiającego."
        }
      ],
      blog: nil
    },
    %{
      slug: "kryteria-oceny-ofert",
      name: "Kryteria oceny ofert",
      issues: [
        "kryteria oceny ofert",
        "kryterium oceny ofert",
        "Kryteria oceny Ofert",
        "ocena ofert"
      ],
      lead:
        "Orzeczenia KIO w sprawach kryteriów oceny ofert: dopuszczalność kryteriów pozacenowych, sposób ich opisania i prawidłowość przyznanej punktacji.",
      body: [
        "Najkorzystniejszą ofertę wybiera się na podstawie kryteriów oceny ofert określonych w dokumentach zamówienia. Kryteria muszą być związane z przedmiotem zamówienia, opisane jednoznacznie i zrozumiale oraz umożliwiać weryfikację i porównanie poziomu oferowanego wykonania. Nie mogą dotyczyć właściwości wykonawcy, w szczególności jego wiarygodności ekonomicznej, technicznej lub finansowej.",
        "Spory dotyczą dwóch etapów. Na etapie SWZ kwestionuje się kryteria nieostre, pozostawiające zamawiającemu nieograniczoną swobodę wyboru albo preferujące konkretnego wykonawcę. Po wyborze oferty odwołujący zarzucają błędną punktację — Izba kontroluje wówczas, czy ocena była zgodna z opisem kryterium i czy zamawiający ją uzasadnił, nie zastępując jednak zamawiającego w ocenie o charakterze uznaniowym."
      ],
      articles: [
        {"239", "art. 239 — wybór najkorzystniejszej oferty"},
        {"240", "art. 240 — opis kryteriów oceny ofert"},
        {"241", "art. 241 — związek kryteriów z przedmiotem zamówienia"},
        {"242", "art. 242 — kryteria jakościowe oraz cena lub koszt"},
        {"246", "art. 246 — waga kryterium ceny"}
      ],
      faqs: [
        %{
          question: "Czy doświadczenie może być kryterium oceny ofert?",
          answer:
            "Doświadczenie wykonawcy jako takie — nie. Kryterium może być natomiast organizacja, kwalifikacje zawodowe i doświadczenie osób wyznaczonych do realizacji zamówienia, jeżeli mogą one mieć znaczący wpływ na jakość wykonania (art. 242 ust. 2 pkt 5 Pzp)."
        },
        %{
          question: "Jaką maksymalną wagę może mieć kryterium ceny?",
          answer:
            "Zamawiający publiczni nie stosują kryterium ceny jako jedynego ani o wadze przekraczającej 60%, chyba że określą w opisie przedmiotu zamówienia wymagania jakościowe odnoszące się do co najmniej głównych elementów przedmiotu zamówienia (art. 246 Pzp)."
        },
        %{
          question: "Czy KIO może sama zmienić punktację oferty?",
          answer:
            "Co do zasady nie. Uwzględniając odwołanie, Izba nakazuje unieważnienie wyboru i powtórzenie oceny ofert ze wskazaniem, co zamawiający ocenił wadliwie. Nie zastępuje zamawiającego w ocenie o charakterze uznaniowym."
        },
        %{
          question: "Czy kryteria oceny ofert można zmienić po otwarciu ofert?",
          answer:
            "Nie. Kryteria, ich wagi i sposób oceny muszą wynikać z dokumentów zamówienia i pozostawać niezmienne po upływie terminu składania ofert. Zmiana lub doprecyzowanie podkryteriów na etapie oceny narusza zasadę przejrzystości."
        }
      ],
      blog: nil
    },
    %{
      slug: "wybor-najkorzystniejszej-oferty",
      name: "Wybór najkorzystniejszej oferty",
      issues: [
        "wybór oferty",
        "wybór najkorzystniejszej oferty",
        "oferta najkorzystniejsza",
        "najkorzystniejsza oferta",
        "unieważnienie czynności wyboru oferty najkorzystniejszej",
        "unieważnienie czynności wyboru najkorzystniejszej oferty",
        "unieważnienie czynności wyboru oferty",
        "informacja o wynikach postępowania"
      ],
      lead:
        "Wyroki KIO, w których przedmiotem zaskarżenia była czynność wyboru najkorzystniejszej oferty, oraz orzeczenia nakazujące unieważnienie wyboru i powtórzenie badania ofert.",
      body: [
        "Wybór najkorzystniejszej oferty jest czynnością, od której wnosi się najwięcej odwołań. Odwołujący zwykle nie kwestionuje samego wyboru, lecz zaniechania, które do niego doprowadziły: nieodrzucenie oferty konkurenta, niewezwanie go do wyjaśnień albo błędną ocenę w kryteriach.",
        "Uwzględniając odwołanie, Izba nakazuje zamawiającemu unieważnienie czynności wyboru oferty i powtórzenie badania i oceny ofert, często ze wskazaniem konkretnych czynności do wykonania. Warunkiem uwzględnienia odwołania jest stwierdzenie naruszenia przepisów, które miało lub mogło mieć istotny wpływ na wynik postępowania.",
        "Zamawiający ma obowiązek przekazać wykonawcom informację o wyborze wraz z uzasadnieniem faktycznym i prawnym — to od jej przekazania biegnie termin na wniesienie odwołania."
      ],
      articles: [
        {"239", "art. 239 — wybór najkorzystniejszej oferty"},
        {"253", "art. 253 — informacja o wyborze oferty"},
        {"554", "art. 554 — uwzględnienie odwołania przez Izbę"}
      ],
      faqs: [
        %{
          question: "Czy zamawiający może sam unieważnić wybór oferty?",
          answer:
            "Tak. Do momentu zawarcia umowy zamawiający może z własnej inicjatywy unieważnić czynność wyboru i powtórzyć badanie i ocenę ofert, jeżeli stwierdzi, że czynność była obarczona wadą. Musi poinformować o tym wykonawców."
        },
        %{
          question: "Co musi zawierać informacja o wyborze najkorzystniejszej oferty?",
          answer:
            "Nazwę i siedzibę wybranego wykonawcy, uzasadnienie wyboru, nazwy pozostałych wykonawców oraz punktację przyznaną ofertom w każdym kryterium i łącznie, a także informację o ofertach odrzuconych wraz z uzasadnieniem faktycznym i prawnym (art. 253 Pzp)."
        },
        %{
          question: "Kiedy po wyborze oferty można zawrzeć umowę?",
          answer:
            "Nie wcześniej niż po upływie 10 dni od przesłania informacji o wyborze w postępowaniach powyżej progów unijnych i 5 dni poniżej progów. Wniesienie odwołania wstrzymuje zawarcie umowy do czasu wydania orzeczenia przez KIO."
        },
        %{
          question: "Co nakazuje KIO, gdy uwzględnia odwołanie od wyboru oferty?",
          answer:
            "Najczęściej unieważnienie czynności wyboru oraz powtórzenie badania i oceny ofert, często z konkretnym wskazaniem — np. odrzucenia oferty konkurenta lub wezwania go do wyjaśnień."
        }
      ],
      blog: nil
    },
    %{
      slug: "uniewaznienie-postepowania",
      name: "Unieważnienie postępowania",
      issues: [
        "unieważnienie postępowania",
        "niemożliwa do usunięcia wada postępowania",
        "wada postępowania",
        "nieprzyznanie środków na sfinansowanie zamówienia",
        "kwota na sfinansowanie zamówienia",
        "interes publiczny"
      ],
      lead:
        "Orzecznictwo KIO dotyczące unieważnienia postępowania o udzielenie zamówienia: brak środków, wada postępowania, zmiana okoliczności i interes publiczny.",
      body: [
        "Zamawiający może unieważnić postępowanie wyłącznie w sytuacjach wymienionych w ustawie — przede wszystkim w art. 255 Pzp. Katalog przesłanek jest zamknięty, a każdą z nich interpretuje się ściśle, ponieważ celem postępowania jest zawarcie umowy.",
        "Najczęściej badane przez Izbę przesłanki to: cena najkorzystniejszej oferty przewyższająca kwotę, którą zamawiający zamierza przeznaczyć na sfinansowanie zamówienia (pkt 3), istotna zmiana okoliczności powodująca, że udzielenie zamówienia nie leży w interesie publicznym (pkt 5), oraz niemożliwa do usunięcia wada postępowania uniemożliwiająca zawarcie niepodlegającej unieważnieniu umowy (pkt 6).",
        "W przypadku wady postępowania zamawiający musi wykazać cały łańcuch: istnienie wady, jej nieusuwalność oraz związek z podstawami unieważnienia umowy z art. 457 Pzp. Błędy w SWZ dostrzeżone po otwarciu ofert nie zawsze spełniają te wymagania."
      ],
      articles: [
        {"255", "art. 255 — przesłanki unieważnienia postępowania"},
        {"256", "art. 256 — unieważnienie przed terminem składania ofert"},
        {"260", "art. 260 — zawiadomienie o unieważnieniu"},
        {"457", "art. 457 — unieważnienie umowy"}
      ],
      faqs: [
        %{
          question:
            "Czy zamawiający musi zwiększyć budżet, jeżeli oferta przekracza kwotę na sfinansowanie zamówienia?",
          answer:
            "Nie musi. Zwiększenie kwoty do ceny najkorzystniejszej oferty jest uprawnieniem zamawiającego. Izba bada jednak, czy zamawiający rzeczywiście rozważył taką możliwość i czy unieważnienie nie było pozorne."
        },
        %{
          question: "Czy unieważnienie postępowania można zaskarżyć do KIO?",
          answer:
            "Tak. Unieważnienie postępowania jest czynnością zamawiającego, od której przysługuje odwołanie. Uwzględniając je, Izba nakazuje unieważnienie tej czynności i kontynuowanie postępowania."
        },
        %{
          question: "Czy brak ofert oznacza unieważnienie postępowania?",
          answer:
            "Tak. Zamawiający unieważnia postępowanie, jeżeli nie złożono żadnej oferty albo wszystkie złożone oferty podlegały odrzuceniu (art. 255 pkt 1 i 2 Pzp)."
        },
        %{
          question:
            "Czy po unieważnieniu postępowania można żądać zwrotu kosztów przygotowania oferty?",
          answer:
            "Tak, jeżeli unieważnienie nastąpiło z przyczyn leżących po stronie zamawiającego. Wykonawcom, którzy złożyli oferty niepodlegające odrzuceniu, przysługuje roszczenie o zwrot uzasadnionych kosztów uczestnictwa w postępowaniu (art. 261 Pzp)."
        },
        %{
          question:
            "Czy zamawiający musi poinformować o nowym postępowaniu na ten sam przedmiot?",
          answer:
            "Tak. Zamawiający niezwłocznie zawiadamia wykonawców, którzy ubiegali się o udzielenie zamówienia w unieważnionym postępowaniu, o wszczęciu kolejnego postępowania dotyczącego tego samego przedmiotu zamówienia (art. 262 Pzp)."
        }
      ],
      blog:
        {"uniewaznienie-przetargu-jak-sie-bronic",
         "Kiedy zamawiający może unieważnić przetarg — i jak się bronić"}
    },
    %{
      slug: "zasady-udzielania-zamowien",
      name: "Zasada uczciwej konkurencji i równego traktowania",
      issues: [
        "zasady udzielania zamówień",
        "zasada uczciwej konkurencji",
        "zasady uczciwej konkurencji",
        "uczciwa konkurencja",
        "naruszenie zasad uczciwej konkurencji",
        "zachowanie uczciwej konkurencji",
        "zasada równego traktowania wykonawców",
        "zasada równego traktowania",
        "zasady równego traktowania wykonawców",
        "równe traktowanie wykonawców",
        "zasada równego traktowania wykonawców i uczciwej konkurencji",
        "zasada proporcjonalności",
        "zasada przejrzystości"
      ],
      lead:
        "Orzeczenia KIO odwołujące się do naczelnych zasad udzielania zamówień: uczciwej konkurencji, równego traktowania wykonawców, przejrzystości i proporcjonalności (art. 16 Pzp).",
      body: [
        "Zamawiający przygotowuje i przeprowadza postępowanie w sposób zapewniający zachowanie uczciwej konkurencji oraz równe traktowanie wykonawców, przejrzysty i proporcjonalny. Art. 16 ustawy Pzp jest najczęściej powoływanym przepisem w odwołaniach — zwykle obok przepisu szczegółowego, którego naruszenie zarzuca odwołujący.",
        "Izba konsekwentnie przyjmuje, że zarzut naruszenia zasad ma charakter wynikowy: samodzielnie rzadko prowadzi do uwzględnienia odwołania i wymaga wskazania konkretnej czynności lub zaniechania zamawiającego. Równe traktowanie oznacza jednakowe traktowanie wykonawców znajdujących się w takiej samej sytuacji — odmienne potraktowanie wymaga obiektywnego uzasadnienia.",
        "Zasada proporcjonalności ma znaczenie przede wszystkim przy ocenie warunków udziału, wymagań OPZ i decyzji o wykluczeniu wykonawcy."
      ],
      articles: [
        {"16", "art. 16 — zasady uczciwej konkurencji, przejrzystości i proporcjonalności"},
        {"17", "art. 17 — zasada efektywności i bezstronności"},
        {"18", "art. 18 — zasada jawności"}
      ],
      faqs: [
        %{
          question: "Czy można oprzeć odwołanie wyłącznie na naruszeniu art. 16 Pzp?",
          answer:
            "Formalnie tak, ale w praktyce takie zarzuty rzadko są skuteczne. KIO oczekuje wskazania konkretnej czynności zamawiającego i przepisu szczegółowego, a naruszenie zasad traktuje jako konsekwencję tego naruszenia."
        },
        %{
          question: "Co oznacza zasada równego traktowania wykonawców?",
          answer:
            "Wykonawcy znajdujący się w takiej samej sytuacji muszą być traktowani jednakowo, a w różnej — odmiennie, o ile jest to obiektywnie uzasadnione. Zamawiający nie może np. wezwać do wyjaśnień tylko jednego z wykonawców, których oferty budzą takie same wątpliwości."
        },
        %{
          question: "Co oznacza zasada proporcjonalności w zamówieniach publicznych?",
          answer:
            "Wymagania i decyzje zamawiającego nie mogą wykraczać poza to, co konieczne do osiągnięcia celu zamówienia. Zasada ta ma znaczenie zwłaszcza przy warunkach udziału w postępowaniu, opisie przedmiotu zamówienia i wykluczeniu wykonawcy."
        },
        %{
          question: "Na czym polega zasada przejrzystości?",
          answer:
            "Warunki postępowania muszą być sformułowane jasno i z góry znane wszystkim wykonawcom, a czynności zamawiającego — udokumentowane i uzasadnione w sposób pozwalający na ich kontrolę."
        }
      ],
      blog: nil
    },
    %{
      slug: "konsorcjum-i-zasoby-podmiotu-trzeciego",
      name: "Konsorcjum i zasoby podmiotu trzeciego",
      issues: [
        "wykonawcy wspólnie ubiegający się o udzielenie zamówienia",
        "konsorcjum",
        "zasoby podmiotu trzeciego",
        "podwykonawca"
      ],
      lead:
        "Orzecznictwo KIO o wykonawcach wspólnie ubiegających się o zamówienie, poleganiu na zasobach podmiotów udostępniających i podwykonawstwie.",
      body: [
        "Wykonawcy mogą wspólnie ubiegać się o udzielenie zamówienia — warunki udziału spełniają wtedy łącznie, a podstawy wykluczenia bada się wobec każdego z nich. Wykonawcy wspólnie ubiegający się o zamówienie dołączają do oferty oświadczenie, z którego wynika, które roboty, dostawy lub usługi wykonają poszczególni wykonawcy.",
        "Wykonawca może również polegać na zdolnościach podmiotów udostępniających zasoby. Izba wymaga, aby udostępnienie było realne: zobowiązanie podmiotu trzeciego musi określać zakres i sposób udostępnienia, a w odniesieniu do wykształcenia, kwalifikacji zawodowych i doświadczenia podmiot udostępniający musi faktycznie wykonać roboty lub usługi, do których te zdolności są wymagane.",
        "Ważnym ograniczeniem jest zakaz powołania się na zasoby podmiotu trzeciego dopiero po terminie składania ofert, jeżeli wykonawca pierwotnie deklarował samodzielne spełnianie warunku."
      ],
      articles: [
        {"58", "art. 58 — wspólne ubieganie się o zamówienie"},
        {"117", "art. 117 — warunki udziału a konsorcjum"},
        {"118", "art. 118 — poleganie na zasobach podmiotów udostępniających"},
        {"122", "art. 122 — zastąpienie podmiotu udostępniającego zasoby"},
        {"462", "art. 462 — podwykonawstwo"}
      ],
      faqs: [
        %{
          question: "Czy po złożeniu oferty można dodać podmiot udostępniający zasoby?",
          answer:
            "Nie w zakresie, w jakim wykonawca na etapie składania oferty nie polegał na zasobach podmiotów trzecich (art. 123 Pzp). Można natomiast zastąpić podmiot udostępniający innym podmiotem lub wykazać samodzielne spełnianie warunku, jeżeli zasoby pierwotnego podmiotu okazały się niewystarczające."
        },
        %{
          question: "Czy konsorcjum musi ustanowić pełnomocnika?",
          answer:
            "Tak. Wykonawcy wspólnie ubiegający się o udzielenie zamówienia ustanawiają pełnomocnika do reprezentowania ich w postępowaniu albo do reprezentowania i zawarcia umowy (art. 58 ust. 2 Pzp)."
        },
        %{
          question: "Jak konsorcjum wykazuje spełnienie warunku doświadczenia?",
          answer:
            "Wykonawcy wspólnie ubiegający się o zamówienie mogą polegać na zdolnościach tych z nich, którzy wykonają roboty lub usługi, do których te zdolności są wymagane. Do oferty dołączają oświadczenie wskazujące, który wykonawca wykona które roboty, dostawy lub usługi (art. 117 ust. 3 i 4 Pzp)."
        },
        %{
          question: "Czy zamawiający może ograniczyć podwykonawstwo?",
          answer:
            "Tak. Może zastrzec obowiązek osobistego wykonania przez wykonawcę kluczowych zadań dotyczących zamówień na roboty budowlane lub usługi oraz prac związanych z rozmieszczeniem i instalacją w ramach zamówienia na dostawy (art. 121 Pzp)."
        }
      ],
      blog: nil
    },
    %{
      slug: "postanowienia-umowy",
      name: "Postanowienia umowy i kary umowne",
      issues: [
        "projektowane postanowienia umowy",
        "kara umowna",
        "kary umowne",
        "waloryzacja",
        "zmiana umowy",
        "umowa",
        "wynagrodzenie",
        "zasady współżycia społecznego"
      ],
      lead:
        "Orzeczenia KIO dotyczące projektowanych postanowień umowy: wysokości kar umownych, klauzul waloryzacyjnych, podziału ryzyk i klauzul abuzywnych.",
      body: [
        "Wykonawcy mogą zaskarżyć do KIO projektowane postanowienia umowy w sprawie zamówienia publicznego. Zamawiający korzysta ze swobody kształtowania umowy, ale nie jest ona nieograniczona: art. 433 ustawy Pzp zakazuje m.in. odpowiedzialności wykonawcy za opóźnienie niezwiązane z jego zachowaniem, kar umownych za zachowania niezwiązane z przedmiotem umowy oraz odpowiedzialności za okoliczności, za które wyłączną odpowiedzialność ponosi zamawiający.",
        "Izba ocenia postanowienia umowy także przez pryzmat art. 353¹ i art. 5 Kodeksu cywilnego oraz zasady proporcjonalności. Zarzuty dotyczą zwykle rażąco wygórowanych kar umownych, braku limitu kar, nieprecyzyjnych przesłanek odstąpienia i przerzucania na wykonawcę ryzyk, których nie da się wycenić.",
        "Odrębną grupę stanowią spory o klauzule waloryzacyjne, obowiązkowe w umowach zawieranych na okres dłuższy niż 6 miesięcy."
      ],
      articles: [
        {"433", "art. 433 — klauzule abuzywne"},
        {"436", "art. 436 — obligatoryjne postanowienia umowy"},
        {"439", "art. 439 — waloryzacja wynagrodzenia"},
        {"455", "art. 455 — zmiana umowy"}
      ],
      faqs: [
        %{
          question: "Czy KIO może nakazać obniżenie kar umownych?",
          answer:
            "Tak. Jeżeli Izba uzna, że projektowane postanowienie narusza przepisy — np. kara jest rażąco wygórowana lub nie ma limitu — nakazuje zamawiającemu zmianę postanowień umowy. Odwołanie trzeba jednak wnieść w terminie liczonym od publikacji dokumentów zamówienia."
        },
        %{
          question: "Jakich postanowień nie wolno zamieszczać w umowie o zamówienie publiczne?",
          answer:
            "Art. 433 Pzp zakazuje m.in. odpowiedzialności wykonawcy za opóźnienie, chyba że jest to uzasadnione okolicznościami lub zakresem zamówienia, kar umownych za zachowania niezwiązane z przedmiotem umowy, odpowiedzialności za okoliczności, za które wyłącznie odpowiada zamawiający, oraz możliwości ograniczenia zakresu zamówienia bez wskazania minimalnej wartości lub wielkości świadczenia."
        },
        %{
          question: "Czy kary umowne muszą mieć górny limit?",
          answer:
            "Tak. Umowa musi określać łączną maksymalną wysokość kar umownych, których mogą dochodzić strony (art. 436 pkt 3 Pzp)."
        },
        %{
          question: "Kiedy klauzula waloryzacyjna jest obowiązkowa?",
          answer:
            "W umowach na roboty budowlane, dostawy lub usługi zawieranych na okres dłuższy niż 6 miesięcy. Umowa musi wtedy określać zasady zmiany wynagrodzenia w razie zmiany cen materiałów lub kosztów związanych z realizacją zamówienia (art. 439 Pzp)."
        }
      ],
      blog: nil
    },
    %{
      slug: "interes-we-wniesieniu-odwolania",
      name: "Interes we wniesieniu odwołania",
      issues: [
        "interes w uzyskaniu rozstrzygnięcia na korzyść strony",
        "interes we wniesieniu odwołania",
        "interes",
        "przystąpienie",
        "termin na zgłoszenie przystąpienia",
        "brak przekazania kopii zgłoszenia przystąpienia",
        "środki ochrony prawnej"
      ],
      lead:
        "Orzecznictwo KIO o legitymacji do wniesienia odwołania — interesie w uzyskaniu zamówienia i możliwości poniesienia szkody — oraz o przystąpieniu do postępowania odwoławczego.",
      body: [
        "Środki ochrony prawnej przysługują wykonawcy, uczestnikowi konkursu oraz innemu podmiotowi, jeżeli ma lub miał interes w uzyskaniu zamówienia oraz poniósł lub może ponieść szkodę w wyniku naruszenia przez zamawiającego przepisów ustawy (art. 505 ust. 1 Pzp). Brak legitymacji skutkuje oddaleniem odwołania bez merytorycznego rozpoznania zarzutów.",
        "Pod wpływem orzecznictwa TSUE Izba szeroko rozumie interes: ma go również wykonawca, którego oferta została odrzucona, jeżeli uwzględnienie odwołania mogłoby doprowadzić do unieważnienia postępowania i wszczęcia nowego. Na etapie odwołania od treści SWZ interes ma każdy wykonawca potencjalnie zainteresowany zamówieniem.",
        "Wykonawca może przystąpić do postępowania odwoławczego w terminie 3 dni od otrzymania kopii odwołania, wskazując stronę, do której przystępuje, i interes w uzyskaniu rozstrzygnięcia na jej korzyść."
      ],
      articles: [
        {"505", "art. 505 — legitymacja do wniesienia środków ochrony prawnej"},
        {"525", "art. 525 — przystąpienie do postępowania odwoławczego"},
        {"526", "art. 526 — opozycja przeciw przystąpieniu"}
      ],
      faqs: [
        %{
          question:
            "Czy wykonawca z dalszej pozycji w rankingu ma interes we wniesieniu odwołania?",
          answer:
            "Ma, jeżeli zarzuty odwołania — w razie ich uwzględnienia — mogłyby doprowadzić do wyboru jego oferty albo do unieważnienia postępowania. Musi zatem zakwestionować wszystkie oferty, które go wyprzedzają, lub wykazać inną realną drogę do uzyskania zamówienia."
        },
        %{
          question: "Czy trzeba wykazać poniesienie szkody?",
          answer:
            "Wystarczy możliwość jej poniesienia. Odwołujący musi wykazać, że w wyniku naruszenia przepisów przez zamawiającego może utracić szansę na uzyskanie zamówienia i związane z nim korzyści."
        },
        %{
          question: "Czy organizacja branżowa może wnieść odwołanie?",
          answer:
            "Tak, ale w ograniczonym zakresie. Organizacje wpisane na listę prowadzoną przez Prezesa UZP oraz Rzecznik Małych i Średnich Przedsiębiorców mogą wnieść odwołanie wobec ogłoszenia wszczynającego postępowanie oraz dokumentów zamówienia (art. 505 ust. 2 Pzp)."
        },
        %{
          question: "Jak przystąpić do postępowania odwoławczego?",
          answer:
            "Zgłoszenie przystąpienia doręcza się Prezesowi Izby w terminie 3 dni od otrzymania kopii odwołania, wskazując stronę, do której się przystępuje, i interes w uzyskaniu rozstrzygnięcia na jej korzyść. Kopię zgłoszenia przekazuje się zamawiającemu i odwołującemu (art. 525 Pzp)."
        }
      ],
      blog: {"jak-odwolac-sie-do-kio", "Jak odwołać się do KIO — krok po kroku"}
    },
    %{
      slug: "odrzucenie-odwolania",
      name: "Odrzucenie odwołania i termin na jego wniesienie",
      issues: [
        "odrzucenie odwołania",
        "termin na wniesienie odwołania",
        "odwołanie wniesione po terminie",
        "podmiot nieuprawniony",
        "wykonanie wyroku KIO"
      ],
      lead:
        "Postanowienia KIO o odrzuceniu odwołania: uchybienie terminowi, odwołanie od czynności wykonanej zgodnie z wyrokiem Izby, brak przekazania kopii zamawiającemu.",
      body: [
        "Izba odrzuca odwołanie na posiedzeniu niejawnym, bez rozpoznania zarzutów, jeżeli stwierdzi jedną z przesłanek z art. 528 ustawy Pzp. Najczęściej są to: wniesienie odwołania po upływie terminu, wniesienie go przez podmiot nieuprawniony, odwołanie dotyczące czynności, którą zamawiający wykonał zgodnie z treścią wcześniejszego wyroku Izby lub sądu, oraz nieprzekazanie zamawiającemu kopii odwołania.",
        "Terminy na wniesienie odwołania są zawite i nie podlegają przywróceniu. Wynoszą 10 dni (zamówienia o wartości równej progom unijnym lub wyższej) albo 5 dni (poniżej progów) od przekazania informacji o czynności zamawiającego przy użyciu środków komunikacji elektronicznej. Odwołanie wobec treści ogłoszenia lub dokumentów zamówienia wnosi się w takich samych terminach liczonych od publikacji.",
        "Spory dotyczą głównie ustalenia, od kiedy biegnie termin — w szczególności kiedy wykonawca powziął lub przy zachowaniu należytej staranności mógł powziąć wiadomość o okolicznościach stanowiących podstawę odwołania."
      ],
      articles: [
        {"513", "art. 513 — czynności podlegające zaskarżeniu"},
        {"514", "art. 514 — wniesienie odwołania i przekazanie kopii"},
        {"515", "art. 515 — terminy na wniesienie odwołania"},
        {"528", "art. 528 — przesłanki odrzucenia odwołania"}
      ],
      faqs: [
        %{
          question: "Czy termin na wniesienie odwołania do KIO można przywrócić?",
          answer:
            "Nie. Termin ma charakter zawity — jego upływ powoduje wygaśnięcie prawa do wniesienia odwołania, a odwołanie wniesione po terminie Izba odrzuca."
        },
        %{
          question: "Co się stanie, jeżeli nie przekażę kopii odwołania zamawiającemu?",
          answer:
            "Odwołujący przekazuje zamawiającemu odwołanie albo jego kopię przed upływem terminu na wniesienie odwołania. Niedopełnienie tego obowiązku jest samodzielną przesłanką odrzucenia odwołania (art. 528 pkt 6 Pzp)."
        },
        %{
          question: "Ile wynosi termin na wniesienie odwołania do KIO?",
          answer:
            "10 dni w postępowaniach o wartości równej progom unijnym lub wyższej i 5 dni poniżej progów — od przekazania informacji o czynności zamawiającego przy użyciu środków komunikacji elektronicznej. Przy innym sposobie przekazania terminy wynoszą odpowiednio 15 i 10 dni."
        },
        %{
          question: "Czy można zaskarżyć czynność wykonaną zgodnie z wyrokiem KIO?",
          answer:
            "Nie. Odwołanie dotyczące czynności, którą zamawiający wykonał zgodnie z treścią wyroku Izby lub sądu albo zgodnie z żądaniem uwzględnionego odwołania, podlega odrzuceniu (art. 528 pkt 5 Pzp)."
        },
        %{
          question: "Czy od postanowienia o odrzuceniu odwołania przysługuje skarga?",
          answer:
            "Tak. Na orzeczenie Izby przysługuje skarga do Sądu Okręgowego w Warszawie — sądu zamówień publicznych, wnoszona za pośrednictwem Prezesa Izby w terminie 14 dni od doręczenia orzeczenia."
        }
      ],
      blog: {"jak-odwolac-sie-do-kio", "Jak odwołać się do KIO — krok po kroku"}
    },
    %{
      slug: "zwrot-odwolania-i-wpis",
      name: "Zwrot odwołania, braki formalne i wpis",
      issues: [
        "zwrot odwołania",
        "braki formalne odwołania",
        "braki formalne",
        "brak przekazania odwołania",
        "wpis od odwołania",
        "wpis",
        "dowód uiszczenia wpisu",
        "zwrot wpisu",
        "zwrot wpisu od odwołania",
        "pełnomocnictwo",
        "umocowanie"
      ],
      lead:
        "Postanowienia KIO o zwrocie odwołania z powodu nieuiszczenia wpisu lub nieuzupełnienia braków formalnych oraz orzeczenia dotyczące zwrotu wpisu.",
      body: [
        "Odwołanie podlega rozpoznaniu, jeżeli nie zawiera braków formalnych i uiszczono od niego wpis. Wpis uiszcza się najpóźniej do dnia upływu terminu na wniesienie odwołania — nieuiszczenie go w terminie powoduje zwrot odwołania bez wzywania do uzupełnienia.",
        "W przypadku innych braków formalnych, takich jak brak pełnomocnictwa, dowodu uiszczenia wpisu czy dowodu przekazania kopii odwołania zamawiającemu, Prezes Izby wzywa odwołującego do ich uzupełnienia w terminie 3 dni pod rygorem zwrotu odwołania. Odwołanie zwrócone nie wywołuje żadnych skutków, jakie ustawa wiąże z jego wniesieniem.",
        "Wysokość wpisu zależy od rodzaju i wartości zamówienia — od 7 500 zł do 20 000 zł. W razie cofnięcia odwołania przed otwarciem rozprawy lub uwzględnienia zarzutów przez zamawiającego odwołujący odzyskuje wpis w całości lub w 90%."
      ],
      articles: [
        {"516", "art. 516 — wymagania formalne odwołania"},
        {"517", "art. 517 — wpis od odwołania"},
        {"518", "art. 518 — uzupełnianie braków formalnych"},
        {"519", "art. 519 — zwrot odwołania"}
      ],
      faqs: [
        %{
          question: "Czy można uzupełnić wpis od odwołania po terminie?",
          answer:
            "Nie. Wpis musi wpłynąć najpóźniej w ostatnim dniu terminu na wniesienie odwołania. Uzupełnić można jedynie dowód jego uiszczenia, jeżeli sam wpis został wniesiony w terminie."
        },
        %{
          question: "Ile wynosi wpis od odwołania do KIO?",
          answer:
            "W postępowaniach na dostawy i usługi: 7 500 zł poniżej progów unijnych i 15 000 zł powyżej progów. W postępowaniach na roboty budowlane: 10 000 zł poniżej progów i 20 000 zł powyżej progów."
        },
        %{
          question: "Jakie braki formalne powodują zwrot odwołania?",
          answer:
            "Poza nieuiszczeniem wpisu w terminie — nieuzupełnienie na wezwanie w ciągu 3 dni braków takich jak pełnomocnictwo, dowód uiszczenia wpisu, dowód przekazania odwołania zamawiającemu czy brak podpisu."
        },
        %{
          question: "Czy po zwrocie odwołania można wnieść je ponownie?",
          answer:
            "Tylko jeżeli nie upłynął jeszcze termin na wniesienie odwołania. Zwrócone odwołanie nie wywołuje żadnych skutków, więc nie przerywa ani nie przedłuża tego terminu."
        }
      ],
      blog: {"ile-kosztuje-odwolanie-do-kio-2026", "Ile kosztuje odwołanie do KIO w 2026 roku"}
    },
    %{
      slug: "umorzenie-postepowania-odwolawczego",
      name: "Umorzenie postępowania odwoławczego",
      issues: [
        "umorzenie postępowania odwoławczego",
        "umorzenie postępowania",
        "cofnięcie odwołania",
        "uwzględnienie zarzutów odwołania",
        "uwzględnienie odwołania"
      ],
      lead:
        "Postanowienia KIO o umorzeniu postępowania odwoławczego: cofnięcie odwołania, uwzględnienie zarzutów przez zamawiającego i zbędność dalszego postępowania.",
      body: [
        "Izba umarza postępowanie odwoławcze postanowieniem w trzech podstawowych sytuacjach opisanych w art. 568 ustawy Pzp: gdy odwołujący cofnął odwołanie, gdy dalsze postępowanie stało się z innej przyczyny zbędne lub niedopuszczalne oraz gdy zamawiający uwzględnił w całości zarzuty odwołania, a żaden wykonawca nie wniósł sprzeciwu.",
        "Odwołujący może cofnąć odwołanie do czasu zamknięcia rozprawy. Cofnięte odwołanie nie wywołuje skutków prawnych, a moment cofnięcia decyduje o tym, jaką część wpisu odzyska odwołujący. Uwzględnienie zarzutów przez zamawiającego zobowiązuje go do wykonania, powtórzenia lub unieważnienia czynności zgodnie z żądaniem odwołania.",
        "Duża liczba postanowień o umorzeniu wynika z praktyki: zamawiający często po lekturze odwołania sam unieważnia zaskarżoną czynność, co czyni spór bezprzedmiotowym."
      ],
      articles: [
        {"520", "art. 520 — cofnięcie odwołania"},
        {"522", "art. 522 — uwzględnienie zarzutów przez zamawiającego"},
        {"523", "art. 523 — sprzeciw wobec uwzględnienia zarzutów"},
        {"568", "art. 568 — umorzenie postępowania odwoławczego"}
      ],
      faqs: [
        %{
          question: "Co się dzieje, gdy zamawiający uwzględni odwołanie w całości?",
          answer:
            "Jeżeli do postępowania odwoławczego po stronie zamawiającego nie przystąpił żaden wykonawca albo przystępujący nie wniósł sprzeciwu, Izba umarza postępowanie, a zamawiający wykonuje czynności zgodnie z żądaniem odwołania. W razie sprzeciwu Izba rozpoznaje odwołanie."
        },
        %{
          question: "Do kiedy można cofnąć odwołanie?",
          answer:
            "Do czasu zamknięcia rozprawy. Cofnięte odwołanie nie wywołuje skutków prawnych, jakie ustawa wiąże z jego wniesieniem, a Izba umarza postępowanie odwoławcze."
        },
        %{
          question: "Czy po cofnięciu odwołania odzyskam wpis?",
          answer:
            "W części. Przepisy o kosztach postępowania odwoławczego przewidują zwrot 90% wpisu, gdy odwołanie zostanie cofnięte odpowiednio wcześnie przed rozprawą. Im później następuje cofnięcie, tym mniejsza część wpisu podlega zwrotowi."
        },
        %{
          question: "Co, jeżeli zamawiający uwzględni tylko część zarzutów?",
          answer:
            "Jeżeli odwołujący wycofa pozostałe zarzuty, Izba umarza postępowanie, a zamawiający wykonuje czynności w zakresie uwzględnionych zarzutów. Jeżeli ich nie wycofa, Izba rozpoznaje odwołanie w pozostałym zakresie (art. 522 ust. 4 Pzp)."
        }
      ],
      blog:
        {"ile-czasu-ma-kio-na-rozpatrzenie-odwolania",
         "Ile czasu ma KIO na rozpatrzenie odwołania?"}
    }
  ]

  @by_slug Map.new(@topics, &{&1.slug, &1})

  @issue_index (for topic <- @topics, issue <- topic.issues, reduce: %{} do
                  acc -> Map.put_new(acc, issue, topic.slug)
                end)

  @doc "All curated topics, in display order."
  def all, do: @topics

  @doc "Returns the topic for a slug, or nil."
  def get(slug) when is_binary(slug), do: Map.get(@by_slug, slug)
  def get(_), do: nil

  @doc "URL path of a topic hub."
  def path(%{slug: slug}), do: "/orzecznictwo-kio/#{slug}"

  @doc "URL paths of all hubs, for the sitemap."
  def all_paths, do: Enum.map(@topics, &path/1)

  @doc """
  Returns the topic a raw `thematic_issues` label belongs to, or nil when the
  label is not covered by any curated hub.
  """
  def for_issue(issue) when is_binary(issue) do
    case Map.get(@issue_index, issue) do
      nil -> nil
      slug -> Map.fetch!(@by_slug, slug)
    end
  end

  def for_issue(_), do: nil

  @doc """
  Returns the distinct topics matching a ruling's `thematic_issues`, in the
  order the issues appear on the ruling.
  """
  def for_issues(issues) when is_list(issues) do
    issues
    |> Enum.map(&for_issue/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq_by(& &1.slug)
  end

  def for_issues(_), do: []
end
