defmodule Przetargowi.Repo.Migrations.InsertBlogArticleKioCosts2026 do
  use Ecto.Migration

  @content """
<h2>Ile naprawdę kosztuje odwołanie do KIO?</h2>

<p>Zastanawiasz się, czy warto odwołać się do Krajowej Izby Odwoławczej, ale nie wiesz, ile to będzie kosztować? W tym artykule rozkładamy na czynniki pierwsze <strong>wszystkie koszty</strong> związane z odwołaniem do KIO w 2026 roku — od wpisu, przez wynagrodzenie pełnomocnika, po ukryte koszty, o których mało kto mówi.</p>

<p>Znajomość kosztów to podstawa podejmowania racjonalnych decyzji biznesowych. Odwołanie do KIO może być świetną inwestycją — ale tylko wtedy, gdy wiesz, na co się piszesz.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <p style="margin: 0; color: #d4af37;"><strong>💡 Zanim przeczytasz dalej:</strong> Jeśli nie znasz jeszcze procedury odwoławczej, zacznij od naszego przewodnika <a href="/blog/jak-odwolac-sie-do-kio" style="color: #d4af37;">Jak odwołać się do KIO — krok po kroku</a>. Ten artykuł skupia się wyłącznie na kosztach.</p>
</div>

<h2>Wpis od odwołania — stawki 2026</h2>

<p>Wpis to obowiązkowa opłata, bez której odwołanie zostanie zwrócone. Wysokość wpisu reguluje <strong>rozporządzenie Prezesa Rady Ministrów z dnia 30 grudnia 2020 r.</strong> w sprawie szczegółowych rodzajów kosztów postępowania odwoławczego. Stawki nie zmieniły się od wejścia w życie nowej ustawy Pzp:</p>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Rodzaj zamówienia</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Poniżej progów UE</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Powyżej progów UE</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Dostawy i usługi</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>7 500 zł</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>15 000 zł</strong></td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Roboty budowlane</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>10 000 zł</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>20 000 zł</strong></td>
  </tr>
</table>

<p><strong>Ważne:</strong> Wpis należy uiścić <strong>najpóźniej w dniu wniesienia odwołania</strong> na rachunek bankowy Urzędu Zamówień Publicznych. Brak wpisu = zwrot odwołania bez rozpatrzenia. Numer rachunku bankowego znajdziesz na stronie <a href="https://www.uzp.gov.pl" target="_blank" rel="noopener">UZP</a>.</p>

<div style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;">
  <p style="margin: 0;"><strong>⚠️ Uwaga na progi unijne 2026:</strong> Od 1 stycznia 2024 r. obowiązują nowe progi unijne. Dla dostaw i usług to <strong>143 000 EUR</strong> (zamawiający rządowi) lub <strong>221 000 EUR</strong> (pozostali), a dla robót budowlanych — <strong>5 538 000 EUR</strong>. Sprawdź, w którym progu mieści się Twoje postępowanie, bo to bezpośrednio wpływa na wysokość wpisu.</p>
</div>

<h2>Koszty pełnomocnika — ile zapłacisz prawnikowi?</h2>

<p>Teoretycznie możesz reprezentować się przed KIO sam. W praktyce — <strong>zdecydowanie nie polecamy</strong>. Orzecznictwo KIO jest specjalistyczne, a błędy proceduralne mogą kosztować Cię nie tylko przegraną, ale i obowiązek pokrycia kosztów strony przeciwnej.</p>

<h3>Stawki minimalne (rozporządzenie)</h3>

<p>Rozporządzenie Ministra Sprawiedliwości w sprawie szczegółowych rodzajów kosztów postępowania odwoławczego określa <strong>maksymalną kwotę kosztów zastępstwa prawnego</strong>, jaką KIO może zasądzić:</p>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Rodzaj</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Kwota</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Wynagrodzenie pełnomocnika (zasądzane przez KIO)</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>3 600 zł</strong></td>
  </tr>
</table>

<p>To kwota, którą KIO może zasądzić od przegranego na rzecz wygranego tytułem kosztów zastępstwa. Ale <strong>to nie jest realne wynagrodzenie prawnika</strong>.</p>

<h3>Realne koszty pełnomocnika na rynku</h3>

<p>Rynkowe wynagrodzenie radcy prawnego lub adwokata specjalizującego się w zamówieniach publicznych w 2026 roku kształtuje się następująco:</p>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Zakres usługi</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Orientacyjny koszt</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Analiza sprawy i opinia o zasadności odwołania</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">1 500 – 4 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Sporządzenie odwołania</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">5 000 – 15 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Reprezentacja na rozprawie</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">3 000 – 8 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Łącznie (pełna obsługa)</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>8 000 – 25 000 zł</strong></td>
  </tr>
</table>

<p>Ceny zależą od złożoności sprawy, wartości zamówienia i renomy kancelarii. W przypadku dużych zamówień infrastrukturalnych (np. budowa dróg, szpitali) koszty mogą być wyższe.</p>

<div style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;">
  <p style="margin: 0;"><strong>💰 Wskazówka:</strong> Niektóre kancelarie oferują model <em>success fee</em> — niższe wynagrodzenie podstawowe + premia w przypadku wygranej. To może być korzystne przy dużych zamówieniach, gdy nie chcesz ryzykować pełnych kosztów z góry.</p>
</div>

<h2>Koszty dodatkowe — o czym łatwo zapomnieć</h2>

<p>Wpis i pełnomocnik to nie wszystko. Przygotuj się na dodatkowe wydatki:</p>

<h3>Dojazd do Warszawy</h3>

<p>Rozprawy KIO odbywają się <strong>wyłącznie w Warszawie</strong> (ul. Postępu 17A). Jeśli Twoja firma działa np. w Rzeszowie czy Gdańsku, dolicz:</p>

<ul>
  <li>Koszty podróży (pociąg/samochód/samolot) — 100–600 zł</li>
  <li>Ewentualny nocleg — 200–500 zł</li>
  <li>Czas pracy — Twój i pełnomocnika</li>
</ul>

<p><strong>Dobra wiadomość:</strong> Od czasu pandemii KIO coraz częściej prowadzi rozprawy <strong>w formie zdalnej</strong> (wideokonferencja). Nie jest to jednak gwarantowane — zależy od składu orzekającego i wniosku stron.</p>

<h3>Koszty biegłego</h3>

<p>Jeśli KIO powoła biegłego (np. w sprawach dotyczących rażąco niskiej ceny czy specyfikacji technicznych), jego wynagrodzenie ponosi strona, która przegra. Koszty biegłego to zazwyczaj <strong>2 000 – 8 000 zł</strong>, choć w skomplikowanych sprawach technicznych mogą być wyższe.</p>

<h3>Koszty własnej dokumentacji</h3>

<p>Przygotowanie odwołania wymaga zebrania dokumentacji — kosztorysy, opinie techniczne, tłumaczenia przysięgłe, notarialne poświadczenia. Te koszty bywają niedoszacowane:</p>

<ul>
  <li>Opinia techniczna — 1 000–5 000 zł</li>
  <li>Tłumaczenie przysięgłe — 50–80 zł za stronę</li>
  <li>Kosztorys weryfikacyjny — 500–3 000 zł</li>
</ul>

<h2>Ile czasu zajmuje cała procedura?</h2>

<p>Czas to pieniądz — dosłownie. Procedura odwoławcza angażuje Twój zespół i odciąga od bieżącej działalności.</p>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Etap</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Orientacyjny czas</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Przygotowanie i wniesienie odwołania</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">2–5 dni roboczych</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Oczekiwanie na wyznaczenie rozprawy</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">7–15 dni</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Rozprawa</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">1 dzień (czasem 2)</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Ogłoszenie wyroku</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">tego samego dnia lub do 5 dni</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Łącznie od złożenia do wyroku</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>ok. 2–3 tygodnie</strong></td>
  </tr>
</table>

<p>Zgodnie z ustawą Pzp, KIO rozpoznaje odwołanie w terminie <strong>15 dni</strong> od dnia doręczenia (postępowania powyżej progów UE). W praktyce termin ten jest zazwyczaj dotrzymywany — KIO działa sprawnie na tle innych organów.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <p style="margin: 0; color: #d4af37;"><strong>⏱️ Pamiętaj o terminach na złożenie odwołania:</strong> masz tylko <strong>10 dni</strong> (powyżej progów UE) lub <strong>5 dni</strong> (poniżej progów) od dnia, w którym dowiedziałeś się o czynności zamawiającego. To nieprzekraczalne terminy — liczy się każdy dzień.</p>
</div>

<h2>Co się dzieje z kosztami po wyroku?</h2>

<p>Kluczowe pytanie: <strong>kto ostatecznie za to zapłaci?</strong> Odpowiedź zależy od wyniku sprawy.</p>

<h3>Jeśli wygrasz (odwołanie uwzględnione)</h3>

<p>Zamawiający zwraca Ci:</p>

<ul>
  <li>Wpis od odwołania (7 500 – 20 000 zł)</li>
  <li>Koszty zastępstwa prawnego (do 3 600 zł — tyle zasądzi KIO)</li>
  <li>Uzasadnione koszty dojazdu</li>
</ul>

<p><strong>Uwaga:</strong> KIO zasądza maksymalnie 3 600 zł tytułem zastępstwa prawnego, nawet jeśli zapłaciłeś prawnikowi znacznie więcej. Różnicę pokrywasz z własnej kieszeni — ale wygrałeś zamówienie, więc to inwestycja, która się zwraca.</p>

<h3>Jeśli przegrasz (odwołanie oddalone)</h3>

<p>Ponosisz:</p>

<ul>
  <li>Wpis od odwołania (przepada)</li>
  <li>Własne koszty pełnomocnika</li>
  <li>Koszty zastępstwa prawnego zamawiającego (do 3 600 zł)</li>
  <li>Ewentualne koszty biegłego</li>
</ul>

<h3>Jeśli zamawiający uwzględni odwołanie przed rozprawą</h3>

<p>To najlepszy scenariusz finansowy — zamawiający uznaje Twoje argumenty i <strong>zwraca wpis w całości</strong>. Nie ponosisz kosztów zastępstwa drugiej strony. Płacisz tylko swojego prawnika.</p>

<h2>Ile to razem? Kalkulacja całkowitych kosztów</h2>

<p>Zestawmy wszystko w jednym miejscu. Oto trzy typowe scenariusze kosztowe:</p>

<h3>Scenariusz 1: Dostawy poniżej progów UE, prosta sprawa</h3>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Pozycja</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Koszt</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Wpis</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">7 500 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Pełnomocnik</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">8 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Dojazd / rozprawa zdalna</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">0–500 zł</td>
  </tr>
  <tr style="background: #f0f0f0;">
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Razem</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>15 500 – 16 000 zł</strong></td>
  </tr>
</table>

<h3>Scenariusz 2: Usługi powyżej progów UE, średnia złożoność</h3>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Pozycja</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Koszt</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Wpis</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">15 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Pełnomocnik</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">15 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Opinia techniczna</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">3 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Dojazd i nocleg</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">500 zł</td>
  </tr>
  <tr style="background: #f0f0f0;">
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Razem</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>ok. 33 500 zł</strong></td>
  </tr>
</table>

<h3>Scenariusz 3: Roboty budowlane powyżej progów UE, skomplikowana sprawa</h3>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Pozycja</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Koszt</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Wpis</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">20 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Pełnomocnik</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">25 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Kosztorys weryfikacyjny</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">3 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Opinia techniczna</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">5 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Dojazd, nocleg, czas pracy</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">1 000 zł</td>
  </tr>
  <tr style="background: #f0f0f0;">
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Razem</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>ok. 54 000 zł</strong></td>
  </tr>
</table>

<h2>Kiedy odwołanie się opłaca? Prosta kalkulacja</h2>

<p>Zanim zdecydujesz, zrób prostą analizę opłacalności:</p>

<div style="background: #f5f5f5; border: 1px solid #ddd; border-radius: 8px; padding: 20px; margin: 20px 0;">
  <p style="margin: 0 0 12px 0;"><strong>Wzór:</strong></p>
  <p style="margin: 0 0 12px 0; font-size: 1.1em;"><strong>Oczekiwana wartość = (szansa wygranej × zysk z zamówienia) − koszt odwołania</strong></p>
  <p style="margin: 0;">Jeśli wynik jest dodatni — warto się odwołać. Jeśli ujemny — lepiej odpuścić i skupić się na kolejnych przetargach.</p>
</div>

<p><strong>Przykład:</strong> Zamówienie warte 500 000 zł z marżą 15% (zysk 75 000 zł). Koszt odwołania ok. 25 000 zł. Szanse na wygraną oceniasz na 50%.</p>

<p>Oczekiwana wartość = (0,5 × 75 000) − 25 000 = <strong>12 500 zł</strong> → warto się odwołać.</p>

<p>Przy tym samym zamówieniu, ale szansach na wygraną 20%:</p>

<p>Oczekiwana wartość = (0,2 × 75 000) − 25 000 = <strong>−10 000 zł</strong> → lepiej odpuścić.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <p style="margin: 0; color: #d4af37;"><strong>🔍 Jak ocenić swoje szanse?</strong> Sprawdź w <a href="/szukaj" style="color: #d4af37;">wyszukiwarce orzeczeń KIO</a>, jak Izba orzekała w podobnych sprawach. Wpisz opis swojej sytuacji, a wyszukiwarka semantyczna znajdzie najlepiej pasujące wyroki.</p>
</div>

<h2>Skarga do sądu — ile to kosztuje?</h2>

<p>Jeśli wyrok KIO Cię nie satysfakcjonuje, możesz złożyć skargę do Sądu Okręgowego w Warszawie (sądu zamówień publicznych). Ale uwaga na koszty:</p>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Pozycja</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Koszt</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Wpis od skargi (3× wpis od odwołania)</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">22 500 – 60 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Pełnomocnik (postępowanie sądowe)</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">10 000 – 30 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Czas trwania</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">3–6 miesięcy</td>
  </tr>
</table>

<p>Skarga do sądu ma sens praktycznie wyłącznie przy zamówieniach o dużej wartości, gdzie stawka uzasadnia wielokrotnie wyższe koszty.</p>

<h2>Jak obniżyć koszty odwołania?</h2>

<p>Kilka sprawdzonych sposobów na zmniejszenie wydatków:</p>

<h3>1. Dobrze oceń zasadność przed złożeniem</h3>

<p>Zapłać prawnikowi za samą opinię (1 500–4 000 zł) zanim zainwestujesz w pełne odwołanie. Dobry specjalista od zamówień publicznych powie Ci wprost, czy masz szanse. To może zaoszczędzić Ci kilkudziesięciu tysięcy złotych.</p>

<h3>2. Przygotuj się sam, ile możesz</h3>

<p>Im lepiej przygotujesz dokumentację i opiszesz stan faktyczny, tym mniej czasu (= pieniędzy) poświęci prawnik. Zbierz:</p>

<ul>
  <li>Kompletną dokumentację postępowania</li>
  <li>Chronologię zdarzeń</li>
  <li>Konkretne wskazanie, które przepisy naruszył zamawiający</li>
  <li>Podobne orzeczenia KIO (sprawdź w <a href="/szukaj">wyszukiwarce orzeczeń KIO</a>)</li>
</ul>

<h3>3. Rozważ przystąpienie zamiast odwołania</h3>

<p>Jeśli inny wykonawca już złożył odwołanie w tej samej sprawie, możesz <strong>przystąpić do postępowania</strong> po jego stronie — bez ponoszenia kosztów wpisu. Monitoruj ogłoszenia o odwołaniach na platformie e-Zamówienia.</p>

<h3>4. Wnioskuj o rozprawę zdalną</h3>

<p>Złóż wniosek o przeprowadzenie rozprawy w formie wideokonferencji — zaoszczędzisz na dojazdach i noclegach.</p>

<h2>Podsumowanie — ile realnie kosztuje odwołanie do KIO w 2026?</h2>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Składnik kosztu</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: right;">Zakres kwot</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Wpis od odwołania</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">7 500 – 20 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Pełnomocnik (pełna obsługa)</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">8 000 – 25 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Koszty dodatkowe</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">0 – 10 000 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Czas procedury</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">2–3 tygodnie</td>
  </tr>
  <tr style="background: #f0f0f0;">
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Łączny koszt finansowy</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;"><strong>15 500 – 55 000 zł</strong></td>
  </tr>
</table>

<p>Odwołanie do KIO to poważna inwestycja, ale w wielu przypadkach — <strong>opłacalna</strong>. Kluczem jest rzetelna ocena szans przed podjęciem decyzji. Nie odwołuj się &quot;na złość&quot; zamawiającemu — odwołuj się wtedy, gdy masz argumenty i gdy matematyka działa na Twoją korzyść.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">🔍 Przetargowi.pl — podejmuj decyzje na podstawie danych</h4>
  <ul style="color: #e0e0e0; margin-bottom: 0;">
    <li><a href="/szukaj" style="color: #d4af37;"><strong>Baza orzeczeń KIO</strong></a> — sprawdź wyroki w podobnych sprawach przed odwołaniem</li>
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
      'Ile kosztuje odwołanie do KIO w 2026 roku — wpis, pełnomocnik, czas',
      'ile-kosztuje-odwolanie-do-kio-2026',
      'Pełna kalkulacja kosztów odwołania do KIO w 2026 roku: wpis (7 500–20 000 zł), wynagrodzenie pełnomocnika (8 000–25 000 zł), koszty dodatkowe, czas trwania procedury i analiza opłacalności.',
      'Ile kosztuje odwołanie do KIO w 2026? Wpis 7 500–20 000 zł, pełnomocnik 8 000–25 000 zł, koszty dodatkowe, czas 2–3 tygodnie. Pełna kalkulacja i analiza opłacalności dla wykonawców.',
      'koszty odwołania KIO, wpis KIO 2026, ile kosztuje KIO, pełnomocnik KIO cena, koszty zastępstwa prawnego KIO, opłacalność odwołania KIO, czas procedury KIO, zamówienia publiczne odwołanie',
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
    execute(
      "DELETE FROM articles WHERE slug = 'ile-kosztuje-odwolanie-do-kio-2026'"
    )
  end
end
