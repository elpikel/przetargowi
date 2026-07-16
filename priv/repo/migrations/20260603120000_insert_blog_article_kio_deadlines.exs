defmodule Przetargowi.Repo.Migrations.InsertBlogArticleKioDeadlines do
  use Ecto.Migration

  @content """
  <h2>Ile czasu ma KIO na rozpatrzenie odwołania?</h2>

  <p>Złożyłeś odwołanie do Krajowej Izby Odwoławczej i zastanawiasz się, kiedy poznasz wynik? Terminy postępowania odwoławczego są ściśle określone w ustawie <a href="/ustawa-pzp">Prawo zamówień publicznych</a> — KIO nie może rozpatrywać sprawy w nieskończoność. W tym artykule omawiamy <strong>każdy termin</strong> od momentu złożenia odwołania do uprawomocnienia się wyroku.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <p style="margin: 0; color: #d4af37;"><strong>💡 Zanim przeczytasz dalej:</strong> Jeśli nie znasz jeszcze procedury odwoławczej, zacznij od naszego przewodnika <a href="/blog/jak-odwolac-sie-do-kio" style="color: #d4af37;">Jak odwołać się do KIO — krok po kroku</a>. A jeśli interesują Cię koszty, przeczytaj <a href="/blog/ile-kosztuje-odwolanie-do-kio-2026" style="color: #d4af37;">Ile kosztuje odwołanie do KIO w 2026 roku</a>.</p>
  </div>

  <h2>Terminy na złożenie odwołania — punkt wyjścia</h2>

  <p>Zanim KIO zacznie liczyć swoje terminy, Ty musisz zmieścić się w swoich. Terminy na wniesienie odwołania są <strong>nieprzekraczalne</strong> — ich przekroczenie skutkuje odrzuceniem odwołania bez rozpatrzenia merytorycznego.</p>

  <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
    <tr style="background: #f5f5f5;">
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Przedmiot odwołania</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: center;">Powyżej progów UE</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: center;">Poniżej progów UE</th>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Czynność zamawiającego (informacja elektronicznie)</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>10 dni</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>5 dni</strong></td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Czynność zamawiającego (informacja w inny sposób)</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>15 dni</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>10 dni</strong></td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Treść ogłoszenia lub dokumentów zamówienia</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>10 dni</strong> od publikacji</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>5 dni</strong> od publikacji</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Czynność, o której nie poinformowano</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>30 dni</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>30 dni</strong></td>
    </tr>
  </table>

  <p><strong>Uwaga:</strong> Termin liczy się od dnia, w którym <strong>powzięto lub można było powziąć</strong> wiadomość o okolicznościach stanowiących podstawę odwołania. Nie od dnia, w którym faktycznie przeczytałeś e-mail — od dnia, w którym został wysłany.</p>

  <h2>Co się dzieje po złożeniu odwołania? Oś czasu</h2>

  <p>Po wniesieniu odwołania uruchamia się ściśle określona sekwencja zdarzeń. Oto jak wygląda typowy przebieg sprawy:</p>

  <h3>Dzień 0: Wniesienie odwołania</h3>

  <p>Odwołanie wnosisz do Prezesa KIO w formie elektronicznej przez <a href="https://ezamowienia.gov.pl" target="_blank" rel="noopener">platformę e-Zamówienia</a>. Jednocześnie musisz przesłać kopię odwołania zamawiającemu — to obowiązek ustawowy, którego niedopełnienie skutkuje odrzuceniem odwołania.</p>

  <h3>Dzień 1–3: Badanie formalne</h3>

  <p>Prezes KIO sprawdza, czy odwołanie spełnia wymogi formalne:</p>

  <ul>
    <li>Czy wpis został uiszczony</li>
    <li>Czy odwołanie zawiera wszystkie wymagane elementy (<a href="/ustawa-pzp#art-516">art. 516 Pzp</a>)</li>
    <li>Czy zachowano termin na wniesienie</li>
    <li>Czy kopia została przekazana zamawiającemu</li>
  </ul>

  <p>Jeśli są braki formalne — Prezes KIO wzywa do ich uzupełnienia w terminie <strong>3 dni</strong> pod rygorem zwrotu odwołania.</p>

  <h3>Dzień 1–3: Przystąpienie innych wykonawców</h3>

  <p>Inni wykonawcy mają <strong>3 dni</strong> od momentu otrzymania kopii odwołania na zgłoszenie przystąpienia do postępowania odwoławczego — po stronie odwołującego lub zamawiającego (<a href="/ustawa-pzp#art-525">art. 525 Pzp</a>).</p>

  <h3>Dzień 1–3: Możliwość uwzględnienia przez zamawiającego</h3>

  <p>Zamawiający może uwzględnić odwołanie w całości <strong>przed otwarciem rozprawy</strong>. Jeśli to zrobi i żaden przystępujący po jego stronie nie wniesie sprzeciwu — KIO umarza postępowanie, a zamawiający zwraca wpis. To najszybszy i najtańszy scenariusz dla odwołującego.</p>

  <div style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;">
    <p style="margin: 0;"><strong>💰 Wskazówka:</strong> Jeśli zamawiający uwzględni odwołanie przed rozprawą, wpis jest zwracany w całości. Płacisz tylko za swojego prawnika. To dlatego warto pisać odwołania precyzyjnie i merytorycznie — zamawiający częściej uwzględniają dobrze uargumentowane odwołania, zamiast ryzykować przegraną na rozprawie.</p>
  </div>

  <h2>Termin na rozpoznanie odwołania przez KIO</h2>

  <p>To kluczowy termin, który odpowiada na tytułowe pytanie. Reguluje go <a href="/ustawa-pzp#art-544">art. 544 ustawy Pzp</a>:</p>

  <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
    <tr style="background: #f5f5f5;">
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Typ postępowania</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: center;">Termin na rozpoznanie</th>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Powyżej progów unijnych</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>15 dni</strong> od dnia doręczenia odwołania Prezesowi KIO</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Poniżej progów unijnych</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>15 dni</strong> od dnia doręczenia odwołania Prezesowi KIO</td>
    </tr>
  </table>

  <p><strong>Ważne zastrzeżenie:</strong> Termin 15 dni to termin <strong>instrukcyjny</strong>, nie zawity. Oznacza to, że KIO <em>powinna</em> rozpoznać sprawę w tym terminie, ale jego przekroczenie nie powoduje automatycznych konsekwencji prawnych. W praktyce KIO w zdecydowanej większości spraw dotrzymuje tego terminu — Izba działa sprawnie na tle innych organów orzekających w Polsce.</p>

  <h3>Kiedy termin może się wydłużyć?</h3>

  <p>W praktyce rozpoznanie może trwać dłużej w kilku sytuacjach:</p>

  <ul>
    <li><strong>Odroczenie rozprawy</strong> — KIO może odroczyć rozprawę na wniosek strony lub z urzędu (np. konieczność uzupełnienia materiału dowodowego)</li>
    <li><strong>Powołanie biegłego</strong> — jeśli sprawa wymaga opinii biegłego, termin wydłuża się o czas potrzebny na sporządzenie opinii</li>
    <li><strong>Połączenie spraw</strong> — gdy kilku wykonawców złożyło odwołanie w tym samym postępowaniu, KIO może je połączyć do wspólnego rozpoznania</li>
    <li><strong>Duża liczba spraw</strong> — w okresach wzmożonego wpływu odwołań (np. koniec roku budżetowego) terminy mogą się nieznacznie wydłużać</li>
  </ul>

  <h2>Rozprawa — jak przebiega i ile trwa?</h2>

  <p>Rozprawa przed KIO odbywa się w siedzibie Izby w Warszawie (ul. Postępu 17A) lub w formie wideokonferencji.</p>

  <h3>Typowy przebieg rozprawy</h3>

  <ol>
    <li><strong>Sprawdzenie obecności</strong> i prawidłowości umocowania pełnomocników</li>
    <li><strong>Przedstawienie stanowisk</strong> — odwołujący prezentuje zarzuty, zamawiający odpowiada</li>
    <li><strong>Stanowiska przystępujących</strong> — jeśli inni wykonawcy przystąpili do sprawy</li>
    <li><strong>Postępowanie dowodowe</strong> — prezentacja dokumentów, ewentualne przesłuchanie świadków</li>
    <li><strong>Głosy końcowe</strong> — podsumowanie argumentacji przez strony</li>
    <li><strong>Zamknięcie rozprawy</strong></li>
  </ol>

  <p>Większość rozpraw trwa <strong>od 2 do 6 godzin</strong>. Proste sprawy (np. spór o jeden zarzut) mogą trwać krócej. Skomplikowane sprawy z wieloma zarzutami i dowodami — nawet cały dzień lub dwa.</p>

  <h3>Ogłoszenie wyroku</h3>

  <p>KIO ogłasza wyrok:</p>

  <ul>
    <li><strong>Tego samego dnia</strong> — w większości spraw, po przerwie na naradę składu orzekającego</li>
    <li><strong>W ciągu 5 dni</strong> — w sprawach szczególnie skomplikowanych Izba może odroczyć ogłoszenie orzeczenia</li>
  </ul>

  <h2>Co się dzieje po wyroku?</h2>

  <p>Wyrok KIO to nie koniec — po nim biegną kolejne terminy:</p>

  <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
    <tr style="background: #f5f5f5;">
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Zdarzenie</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: center;">Termin</th>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Doręczenie uzasadnienia wyroku</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>3 dni</strong> od dnia ogłoszenia orzeczenia</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Termin na wniesienie skargi do sądu</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>14 dni</strong> od dnia doręczenia orzeczenia z uzasadnieniem</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Uprawomocnienie się wyroku (jeśli brak skargi)</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">po upływie <strong>14 dni</strong> od doręczenia</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Wykonanie wyroku przez zamawiającego</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>niezwłocznie</strong> po uprawomocnieniu</td>
    </tr>
  </table>

  <div style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;">
    <p style="margin: 0;"><strong>⚠️ Ważne:</strong> Zamawiający <strong>nie może zawrzeć umowy</strong> w sprawie zamówienia publicznego do czasu uprawomocnienia się wyroku KIO (zakaz zawarcia umowy — <a href="/ustawa-pzp#art-577">art. 577 Pzp</a>). Jeśli zamawiający zawrze umowę z naruszeniem tego zakazu, umowa podlega unieważnieniu.</p>
  </div>

  <h2>Skarga do sądu — ile to trwa?</h2>

  <p>Jeśli wyrok KIO Cię nie satysfakcjonuje, możesz złożyć skargę do Sądu Okręgowego w Warszawie — sądu zamówień publicznych (<a href="/ustawa-pzp#art-580">art. 580 Pzp</a>). Ale musisz być przygotowany na znacznie dłuższe terminy:</p>

  <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
    <tr style="background: #f5f5f5;">
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Etap</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: center;">Orientacyjny czas</th>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Termin na wniesienie skargi</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>14 dni</strong> od doręczenia orzeczenia KIO</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Rozpoznanie skargi przez sąd</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>1–3 miesiące</strong></td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Wpis od skargi</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">3× wpis od odwołania (22 500 – 60 000 zł)</td>
    </tr>
  </table>

  <p>Skarga do sądu ma sens praktycznie wyłącznie przy zamówieniach o dużej wartości. Więcej o kosztach przeczytasz w artykule <a href="/blog/ile-kosztuje-odwolanie-do-kio-2026">Ile kosztuje odwołanie do KIO w 2026 roku</a>.</p>

  <h2>Pełna oś czasu — od zdarzenia do uprawomocnienia</h2>

  <p>Zestawmy wszystkie terminy w jednym miejscu. Oto jak wygląda <strong>realistyczna oś czasu</strong> dla typowego odwołania powyżej progów UE:</p>

  <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
    <tr style="background: #f5f5f5;">
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Dzień</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Zdarzenie</th>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Dzień 0</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Otrzymujesz informację o czynności zamawiającego</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Dzień 1–10</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Termin na wniesienie odwołania (<strong>10 dni</strong>)</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Dzień 10</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Wniesienie odwołania do Prezesa KIO + kopia do zamawiającego</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Dzień 11–13</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Badanie formalne, przystąpienia, ewentualne uwzględnienie</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Dzień 11–25</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Termin na rozpoznanie przez KIO (<strong>15 dni</strong>)</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Dzień ~22–25</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Rozprawa i ogłoszenie wyroku</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Dzień ~25–28</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Doręczenie uzasadnienia (<strong>3 dni</strong>)</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Dzień ~28–42</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Termin na skargę do sądu (<strong>14 dni</strong>)</td>
    </tr>
    <tr style="background: #f0f0f0;">
      <td style="padding: 12px; border: 1px solid #ddd;"><strong>Dzień ~42</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd;"><strong>Uprawomocnienie wyroku</strong> (jeśli brak skargi)</td>
    </tr>
  </table>

  <p><strong>Podsumowanie:</strong> Od momentu otrzymania informacji o czynności zamawiającego do uprawomocnienia wyroku KIO mija zazwyczaj <strong>5–6 tygodni</strong>. Jeśli wykorzystasz cały termin na złożenie odwołania (10 dni), a KIO rozpatrzy sprawę w maksymalnym terminie (15 dni) — łącznie potrzebujesz około 42 dni.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <p style="margin: 0; color: #d4af37;"><strong>⏱️ W praktyce bywa szybciej.</strong> Jeśli złożysz odwołanie w ciągu 2–3 dni od zdarzenia, a KIO wyznaczy rozprawę w 10 dni — całość może zamknąć się w <strong>3–4 tygodniach</strong>. A jeśli zamawiający uwzględni odwołanie przed rozprawą — nawet w kilka dni.</p>
  </div>

  <h2>Wpływ odwołania na postępowanie przetargowe</h2>

  <p>Złożenie odwołania ma istotne konsekwencje dla całego postępowania:</p>

  <h3>Zakaz zawarcia umowy</h3>

  <p>Po wniesieniu odwołania zamawiający <strong>nie może zawrzeć umowy</strong> do czasu ogłoszenia wyroku lub postanowienia kończącego postępowanie odwoławcze (<a href="/ustawa-pzp#art-577">art. 577 Pzp</a>). To oznacza, że cały przetarg &quot;stoi&quot; na czas rozpatrywania odwołania.</p>

  <h3>Wyjątki od zakazu</h3>

  <p>KIO może uchylić zakaz zawarcia umowy na wniosek zamawiającego, jeśli:</p>

  <ul>
    <li>Niezawarcie umowy mogłoby spowodować <strong>negatywne skutki dla interesu publicznego</strong></li>
    <li>Negatywne skutki przewyższają korzyści związane z koniecznością ochrony interesów, w odniesieniu do których zachodzi prawdopodobieństwo doznania uszczerbku</li>
  </ul>

  <p>W praktyce KIO uchyla zakaz zawarcia umowy rzadko — tylko w przypadkach, gdy rzeczywiście zachodzi pilna potrzeba (np. zamówienia na leki, usługi ratunkowe).</p>

  <h2>Jak sprawdzić, ile trwały podobne sprawy?</h2>

  <p>Przed złożeniem odwołania warto sprawdzić, ile czasu KIO potrzebowała na rozpatrzenie podobnych spraw. W <a href="/szukaj">wyszukiwarce orzeczeń KIO</a> możesz:</p>

  <ul>
    <li>Wyszukać orzeczenia po typie sprawy i sprawdzić daty (data odwołania vs. data wyroku)</li>
    <li>Filtrować po organie wydającym i sposobie rozstrzygnięcia</li>
    <li>Porównać, jak szybko KIO rozpatruje sprawy w Twoim obszarze zamówień</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <p style="margin: 0; color: #d4af37;"><strong>🔍 Sprawdź w praktyce:</strong> Wpisz w <a href="/szukaj" style="color: #d4af37;">wyszukiwarce orzeczeń KIO</a> opis swojej sytuacji — wyszukiwarka AI znajdzie wyroki w podobnych sprawach, dzięki czemu ocenisz zarówno szanse, jak i przewidywany czas rozpatrzenia.</p>
  </div>

  <h2>Najczęstsze pytania o terminy KIO</h2>

  <h3>Czy KIO może przedłużyć termin 15 dni?</h3>

  <p>Formalnie termin 15 dni jest instrukcyjny, więc jego przekroczenie nie jest naruszeniem prawa. W praktyce KIO bardzo rzadko go przekracza — zazwyczaj tylko przy odroczeniu rozprawy lub oczekiwaniu na opinię biegłego.</p>

  <h3>Czy mogę przyspieszyć rozpatrzenie?</h3>

  <p>Nie ma formalnej procedury &quot;przyspieszenia&quot;. Jedyne co możesz zrobić, to złożyć odwołanie jak najszybciej (nie czekając na ostatni dzień terminu) i dobrze je przygotować, aby KIO nie musiała wzywać do uzupełnienia braków.</p>

  <h3>Co jeśli zamawiający próbuje zawrzeć umowę w trakcie postępowania?</h3>

  <p>Zawarcie umowy z naruszeniem zakazu stanowi przesłankę do stwierdzenia nieważności umowy. Możesz złożyć wniosek o unieważnienie umowy do KIO (<a href="/ustawa-pzp#art-554">art. 554 Pzp</a>).</p>

  <h3>Czy odwołanie wstrzymuje bieg terminu związania ofertą?</h3>

  <p>Tak. Wniesienie odwołania po upływie terminu składania ofert <strong>zawiesza bieg terminu związania ofertą</strong> do czasu ogłoszenia orzeczenia przez KIO (<a href="/ustawa-pzp#art-578">art. 578 Pzp</a>).</p>

  <h2>Podsumowanie terminów</h2>

  <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
    <tr style="background: #f5f5f5;">
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Termin</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: center;">Czas</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Podstawa prawna</th>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Złożenie odwołania (powyżej progów)</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">10 dni</td>
      <td style="padding: 12px; border: 1px solid #ddd;">art. 515 Pzp</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Złożenie odwołania (poniżej progów)</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">5 dni</td>
      <td style="padding: 12px; border: 1px solid #ddd;">art. 515 Pzp</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Przystąpienie do odwołania</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">3 dni</td>
      <td style="padding: 12px; border: 1px solid #ddd;">art. 525 Pzp</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Rozpoznanie przez KIO</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">15 dni</td>
      <td style="padding: 12px; border: 1px solid #ddd;">art. 544 Pzp</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Doręczenie uzasadnienia</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">3 dni</td>
      <td style="padding: 12px; border: 1px solid #ddd;">art. 559 Pzp</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Skarga do sądu</td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">14 dni</td>
      <td style="padding: 12px; border: 1px solid #ddd;">art. 580 Pzp</td>
    </tr>
    <tr style="background: #f0f0f0;">
      <td style="padding: 12px; border: 1px solid #ddd;"><strong>Łącznie do uprawomocnienia</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><strong>~5–6 tygodni</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd;">—</td>
    </tr>
  </table>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <h4 style="color: #d4af37; margin-top: 0;">🔍 Przetargowi.pl — podejmuj decyzje na podstawie danych</h4>
    <ul style="color: #e0e0e0; margin-bottom: 0;">
      <li><a href="/szukaj" style="color: #d4af37;"><strong>Wyszukiwarka orzeczeń KIO</strong></a> — sprawdź wyroki w podobnych sprawach</li>
      <li><a href="/przetargi" style="color: #d4af37;"><strong>Aktualne przetargi</strong></a> — monitoruj nowe postępowania w swojej branży</li>
      <li><a href="/analiza-rynku" style="color: #d4af37;"><strong>Analiza rynku</strong></a> — poznaj konkurencję i zamawiających</li>
      <li><a href="/ustawa-pzp" style="color: #d4af37;"><strong>Ustawa Pzp</strong></a> — pełny tekst z bezpośrednimi linkami do artykułów</li>
    </ul>
  </div>
  """

  def up do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    escaped_content = String.replace(@content, "'", "''")

    execute("""
    INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
    VALUES (
      'Ile czasu ma KIO na rozpatrzenie odwołania? Pełna oś czasu [2026]',
      'ile-czasu-ma-kio-na-rozpatrzenie-odwolania',
      'Pełna oś czasu postępowania odwoławczego przed KIO: 15 dni na rozpoznanie, 3 dni na uzasadnienie, 14 dni na skargę do sądu. Terminy na złożenie odwołania, przebieg rozprawy, zakaz zawarcia umowy i uprawomocnienie wyroku.',
      'Ile czasu ma KIO na rozpatrzenie odwołania? 15 dni od doręczenia (art. 544 Pzp). Pełna oś czasu: złożenie, rozprawa, wyrok, skarga do sądu. Terminy 2026 z podstawami prawnymi.',
      'termin rozpatrzenia KIO, ile czasu KIO, termin odwołania KIO, art 544 Pzp, oś czasu KIO, rozprawa KIO ile trwa, uprawomocnienie wyroku KIO, zakaz zawarcia umowy, terminy zamówienia publiczne 2026',
      'Redakcja Przetargowi.pl',
      true,
      '#{escaped_content}',
      '#{now}',
      '#{now}',
      '#{now}'
    )
    ON CONFLICT (slug) DO UPDATE SET
      title = EXCLUDED.title,
      excerpt = EXCLUDED.excerpt,
      meta_description = EXCLUDED.meta_description,
      meta_keywords = EXCLUDED.meta_keywords,
      author = EXCLUDED.author,
      published = EXCLUDED.published,
      content = EXCLUDED.content,
      updated_at = EXCLUDED.updated_at
    """)
  end

  def down do
    execute("DELETE FROM articles WHERE slug = 'ile-czasu-ma-kio-na-rozpatrzenie-odwolania'")
  end
end
