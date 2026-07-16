defmodule Przetargowi.Repo.Migrations.InsertBlogArticleWhoWinsTenders do
  use Ecto.Migration

  @content """
  <h2>Jak sprawdzić kto wygrał przetarg publiczny?</h2>

  <p>Zanim złożysz ofertę w przetargu, powinieneś wiedzieć <strong>z kim konkurujesz</strong> i <strong>za ile wygrywają</strong> inni. Sprawdzenie wyników wcześniejszych postępowań to nie ciekawość — to podstawa racjonalnej strategii ofertowej. W tym artykule pokażemy, gdzie i jak sprawdzić kto wygrał przetarg, ile zapłacił zamawiający i jak wykorzystać te dane do wygrywania kolejnych zamówień.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <p style="margin: 0; color: #d4af37;"><strong>💡 Szybki start:</strong> Na <a href="/przetargi" style="color: #d4af37;">Przetargowi.pl</a> przy każdym przetargu znajdziesz sekcję &quot;Kto wygrywa podobne przetargi?&quot; — z listą najczęstszych zwycięzców, statystykami cen i ostatnimi rozstrzygnięciami w Twoim regionie i kategorii CPV.</p>
  </div>

  <h2>Dlaczego warto sprawdzać wyniki przetargów?</h2>

  <p>Wielu wykonawców składa oferty &quot;na ślepo&quot; — nie wiedząc, kto i za ile wygrywał podobne zamówienia. To błąd, który kosztuje czas i pieniądze. Analiza wyników daje Ci:</p>

  <ul>
    <li><strong>Realistyczną wycenę</strong> — wiesz, w jakim przedziale cenowym poruszają się zwycięskie oferty</li>
    <li><strong>Obraz konkurencji</strong> — wiesz, z kim rywalizujesz i jak często wygrywają</li>
    <li><strong>Ocenę opłacalności</strong> — możesz oszacować, czy warto startować w danym postępowaniu</li>
    <li><strong>Argumenty do odwołania</strong> — jeśli wygrał ktoś, kto oferuje znacząco niższą cenę, możesz podejrzewać <a href="/blog/najczestsze-bledy-oferty-przetargowe">rażąco niską cenę</a></li>
  </ul>

  <h2>Gdzie sprawdzić kto wygrał przetarg — źródła danych</h2>

  <h3>1. Biuletyn Zamówień Publicznych (BZP)</h3>

  <p>Oficjalne źródło danych o zamówieniach poniżej progów unijnych. Zamawiający mają obowiązek publikowania ogłoszeń o udzieleniu zamówienia. Znajdziesz tam:</p>

  <ul>
    <li>Nazwę i adres zwycięskiego wykonawcy</li>
    <li>Cenę wybranej oferty</li>
    <li>Liczbę złożonych ofert</li>
    <li>Datę udzielenia zamówienia</li>
  </ul>

  <p><strong>Wada:</strong> Wyszukiwarka BZP jest mało intuicyjna, a dane trudne do porównania między postępowaniami. Nie da się łatwo sprawdzić &quot;kto najczęściej wygrywa przetargi na catering w Mazowieckiem&quot;.</p>

  <h3>2. TED (Tenders Electronic Daily)</h3>

  <p>Europejska baza zamówień powyżej progów unijnych. Zawiera dane o wynikach postępowań z całej UE, w tym polskich zamówień powyżej progów. Dane są bardziej ustrukturyzowane niż w BZP, ale interfejs jest skomplikowany.</p>

  <h3>3. Przetargowi.pl — analiza konkurencji</h3>

  <p>Na <a href="/przetargi">Przetargowi.pl</a> przy każdym przetargu automatycznie wyświetlamy sekcję <strong>&quot;Kto wygrywa podobne przetargi?&quot;</strong>, która agreguje dane z rozstrzygniętych postępowań o tym samym kodzie CPV w Twoim regionie.</p>

  <p>Zobaczysz:</p>

  <ul>
    <li><strong>Statystyki cenowe</strong> — najniższa, średnia i najwyższa cena zwycięskich ofert</li>
    <li><strong>Najczęstszych zwycięzców</strong> — firmy, które najczęściej wygrywają, z liczbą wygranych, średnią ceną i łączną wartością kontraktów</li>
    <li><strong>Ostatnie rozstrzygnięcia</strong> — konkretne przetargi z nazwą zwycięzcy i ceną</li>
    <li><strong>Dane regionalne vs krajowe</strong> — porównanie, czy w Twoim województwie ceny są wyższe czy niższe od średniej krajowej</li>
  </ul>

  <div style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;">
    <p style="margin: 0;"><strong>💰 Przykład:</strong> Szukasz przetargu na usługi sprzątania w Małopolsce (CPV 90910000). Nasza analiza pokazuje, że w tym regionie zwycięskie oferty wynoszą średnio 145 000 zł, najczęściej wygrywa firma X (7 razy w ostatnim roku), a ostatnio cena spadła o 12%. Teraz wiesz, jak wycenić swoją ofertę.</p>
  </div>

  <h2>Jak interpretować dane o zwycięzcach — praktyczny poradnik</h2>

  <h3>Analiza cenowa</h3>

  <p>Najważniejsze pytanie: <strong>w jakim przedziale cenowym składać ofertę?</strong></p>

  <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
    <tr style="background: #f5f5f5;">
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Wskaźnik</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Co Ci mówi</th>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;"><strong>Najniższa cena</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd;">Dolna granica rynku. Jeśli Twoja oferta jest znacząco niższa — ryzykujesz wezwanie do wyjaśnień w sprawie rażąco niskiej ceny.</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;"><strong>Średnia cena</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd;">Punkt odniesienia. Oferta blisko średniej to bezpieczny wybór, jeśli kryterium cenowe ma dużą wagę.</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;"><strong>Najwyższa cena</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd;">Górna granica. Pokazuje, ile zamawiający są skłonni zapłacić. Przydatne gdy kryterium jakości ma dużą wagę.</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;"><strong>Rozstrzał cen</strong></td>
      <td style="padding: 12px; border: 1px solid #ddd;">Duża różnica min-max oznacza fragmentaryczny rynek. Mała różnica — konkurencja jest wyrównana i liczy się każdy procent.</td>
    </tr>
  </table>

  <h3>Analiza konkurencji</h3>

  <p>Wiedza o tym, kto i jak często wygrywa, pozwala podjąć strategiczne decyzje:</p>

  <ul>
    <li><strong>Jeden dominujący gracz</strong> (np. 60%+ wygranych) — trudny rynek, rozważ czy warto startować. Może mieć przewagę kosztową lub relacyjną.</li>
    <li><strong>Kilku regularnych graczy</strong> — zdrowa konkurencja. Warto startować, bo zamawiający nie jest &quot;przywiązany&quot; do jednego wykonawcy.</li>
    <li><strong>Dużo jednorazowych zwycięzców</strong> — otwarty rynek, nowi gracze mają szansę. Cena prawdopodobnie jest kluczowym kryterium.</li>
  </ul>

  <h3>Analiza regionalna</h3>

  <p>Ceny w zamówieniach publicznych różnią się znacząco między regionami. To samo zamówienie w Warszawie może kosztować o 30-40% więcej niż w mniejszym mieście. Dlatego warto porównywać:</p>

  <ul>
    <li>Ceny w swoim województwie vs średnia krajowa</li>
    <li>Liczbę konkurentów w regionie vs w kraju</li>
    <li>Czy warto startować w przetargach w sąsiednich województwach</li>
  </ul>

  <h2>Kody CPV — klucz do porównań</h2>

  <p>Porównywanie przetargów ma sens tylko w ramach tego samego <strong>kodu CPV</strong> (Common Procurement Vocabulary). Kod CPV opisuje przedmiot zamówienia i pozwala porównywać jabłka z jabłkami.</p>

  <p>Przykłady popularnych kodów CPV:</p>

  <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
    <tr style="background: #f5f5f5;">
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Kod CPV</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Opis</th>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">45000000</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Roboty budowlane</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">33600000</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Produkty farmaceutyczne</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">55520000</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Usługi cateringowe</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">90910000</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Usługi sprzątania</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">72000000</td>
      <td style="padding: 12px; border: 1px solid #ddd;">Usługi informatyczne</td>
    </tr>
  </table>

  <p>Na <a href="/analiza-rynku">Przetargowi.pl — Analiza rynku</a> możesz przeanalizować dowolny kod CPV w wybranym regionie: ile jest przetargów, kto wygrywa, jakie są ceny.</p>

  <h2>Jak wykorzystać dane o zwycięzcach — 5 strategii</h2>

  <h3>1. Optymalna wycena oferty</h3>

  <p>Znając średnią cenę zwycięskich ofert, możesz precyzyjnie wycenić swoją. Nie strzelasz w ciemno — wiesz, że w Twojej kategorii CPV zwycięskie oferty wynoszą zazwyczaj X-Y zł. Celujesz w dolną część tego przedziału, zachowując marżę.</p>

  <h3>2. Decyzja &quot;start / nie start&quot;</h3>

  <p>Jeśli jeden wykonawca wygrywa 80% przetargów w Twojej kategorii i regionie, a jego średnia cena jest o 25% niższa od Twojej — może lepiej skupić się na innym regionie lub segmencie. Dane pozwalają podejmować decyzje, zamiast tracić czas na przegrane postępowania.</p>

  <h3>3. Identyfikacja nisz</h3>

  <p>Szukaj kategorii CPV i regionów, gdzie jest mało konkurencji lub gdzie ceny są wyższe od Twojej oferty. To Twoje nisze — miejsca, gdzie masz realną szansę na wygraną.</p>

  <h3>4. Przygotowanie do odwołania</h3>

  <p>Jeśli konkurent wygrał z ceną znacząco poniżej średniej rynkowej — masz argument do podważenia tej oferty jako rażąco niskiej ceny. Dane historyczne to dowód, że taka cena jest nierealna.</p>

  <p>Sprawdź w <a href="/szukaj">wyszukiwarce orzeczeń KIO</a>, jak Izba orzekała w podobnych sprawach dotyczących rażąco niskiej ceny.</p>

  <h3>5. Budowanie relacji z zamawiającymi</h3>

  <p>Wiedząc, którzy zamawiający regularnie ogłaszają przetargi w Twojej kategorii, możesz proaktywnie śledzić ich zamówienia i przygotowywać się z wyprzedzeniem.</p>

  <h2>Gdzie szukać wyników przetargów — krok po kroku</h2>

  <h3>Na Przetargowi.pl</h3>

  <ol>
    <li>Wejdź na <a href="/przetargi">stronę przetargów</a></li>
    <li>Znajdź interesujący Cię przetarg lub filtruj po regionie i kategorii</li>
    <li>Na stronie przetargu przewiń do sekcji <strong>&quot;Kto wygrywa podobne przetargi?&quot;</strong></li>
    <li>Zobaczysz statystyki cenowe, najczęstszych zwycięzców i ostatnie rozstrzygnięcia</li>
    <li>Porównaj dane regionalne z krajowymi</li>
  </ol>

  <p>Alternatywnie, użyj <a href="/analiza-rynku">Analizy rynku</a> aby przejrzeć cały segment CPV w wybranym województwie.</p>

  <h3>W BZP (Biuletyn Zamówień Publicznych)</h3>

  <ol>
    <li>Wejdź na <a href="https://ezamowienia.gov.pl" target="_blank" rel="noopener">ezamowienia.gov.pl</a></li>
    <li>W wyszukiwarce wybierz typ ogłoszenia: &quot;Ogłoszenie o wyniku postępowania&quot;</li>
    <li>Wpisz kod CPV lub nazwę zamawiającego</li>
    <li>Przejrzyj wyniki — każde ogłoszenie zawiera dane o zwycięzcy i cenie</li>
  </ol>

  <h2>Na co uważać przy analizie wyników</h2>

  <ul>
    <li><strong>Różnice w zakresie zamówienia</strong> — dwa przetargi z tym samym kodem CPV mogą mieć zupełnie inny zakres. Porównuj ostrożnie.</li>
    <li><strong>Dane historyczne mogą być nieaktualne</strong> — ceny sprzed 2 lat mogą nie odzwierciedlać obecnych realiów rynkowych (inflacja, zmiany regulacyjne).</li>
    <li><strong>Zamówienia z wolnej ręki</strong> — nie wszystkie zamówienia są konkurencyjne. Tryb z wolnej ręki oznacza, że zamawiający wybrał wykonawcę bez konkurencji.</li>
    <li><strong>Konsorcja</strong> — zwycięzcą może być konsorcjum kilku firm. Sprawdź, czy Twoja firma mogłaby dołączyć do takiego konsorcjum.</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <h4 style="color: #d4af37; margin-top: 0;">🔍 Przetargowi.pl — podejmuj decyzje na podstawie danych</h4>
    <ul style="color: #e0e0e0; margin-bottom: 0;">
      <li><a href="/przetargi" style="color: #d4af37;"><strong>Aktualne przetargi</strong></a> — z analizą zwycięzców przy każdym ogłoszeniu</li>
      <li><a href="/analiza-rynku" style="color: #d4af37;"><strong>Analiza rynku</strong></a> — przeglądaj segmenty CPV i regiony</li>
      <li><a href="/szukaj" style="color: #d4af37;"><strong>Wyszukiwarka orzeczeń KIO</strong></a> — sprawdź orzecznictwo dotyczące rażąco niskiej ceny</li>
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
      'Jak sprawdzić kto wygrał przetarg publiczny — analiza konkurencji [2026]',
      'jak-sprawdzic-kto-wygral-przetarg',
      'Gdzie i jak sprawdzić wyniki przetargów publicznych: BZP, TED, analiza konkurencji. Statystyki cenowe, najczęstsi zwycięzcy, strategie wyceny oferty na podstawie danych historycznych.',
      'Jak sprawdzić kto wygrał przetarg? BZP, TED i analiza konkurencji na Przetargowi.pl. Statystyki cen, najczęstsi zwycięzcy wg CPV i regionu. Praktyczny poradnik wyceny oferty.',
      'kto wygrał przetarg, wyniki przetargów, sprawdzić zwycięzcę przetargu, analiza konkurencji przetargi, ceny ofert przetargowych, BZP wyniki, CPV analiza, zamówienia publiczne zwycięzcy',
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
    execute("DELETE FROM articles WHERE slug = 'jak-sprawdzic-kto-wygral-przetarg'")
  end
end
