defmodule Przetargowi.Repo.Migrations.InsertBlogArticleTenderAnnulment do
  use Ecto.Migration

  @content """
  <h2>Unieważnienie przetargu — co to oznacza dla wykonawcy?</h2>

  <p>Składasz ofertę, inwestujesz czas i pieniądze w przygotowanie dokumentacji, a zamawiający nagle unieważnia postępowanie. Czy ma do tego prawo? Kiedy unieważnienie jest uzasadnione, a kiedy stanowi nadużycie? I co najważniejsze — <strong>jak się bronić?</strong></p>

  <p>W tym artykule analizujemy wszystkie podstawy prawne unieważnienia przetargu na gruncie ustawy <a href="/ustawa-pzp">Prawo zamówień publicznych</a>, omawiamy aktualne orzecznictwo KIO i podpowiadamy, kiedy warto składać odwołanie.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <p style="margin: 0; color: #d4af37;"><strong>💡 Zanim przeczytasz dalej:</strong> Sprawdź podobne sprawy w naszej <a href="/szukaj" style="color: #d4af37;">wyszukiwarce orzeczeń KIO</a>. Wyszukaj np. &quot;unieważnienie postępowania art. 255&quot; i zobacz, jak KIO rozstrzygała analogiczne przypadki.</p>
  </div>

  <h2>Kiedy zamawiający MUSI unieważnić przetarg (art. 255 PZP)</h2>

  <p>Artykuł 255 ustawy Pzp zawiera <strong>zamknięty katalog przesłanek obligatoryjnych</strong> — jeśli którakolwiek z nich zachodzi, zamawiający nie ma wyboru i musi unieważnić postępowanie. Nie może tego obejść.</p>

  <h3>1. Brak ofert lub wniosków (art. 255 pkt 1)</h3>

  <p>Jeśli w wyznaczonym terminie nie wpłynął żaden wniosek o dopuszczenie do udziału lub żadna oferta — postępowanie unieważnia się automatycznie. To najczęstsza i jednocześnie najmniej kontrowersyjna przesłanka.</p>

  <h3>2. Wszystkie oferty odrzucone (art. 255 pkt 2)</h3>

  <p>Gdy po weryfikacji okaże się, że żadna z ofert nie spełnia wymagań — zamawiający unieważnia postępowanie. <strong>Uwaga:</strong> przed odrzuceniem wszystkich ofert zamawiający powinien skorzystać z możliwości wezwania do uzupełnienia dokumentów (<a href="/ustawa-pzp#art-128">art. 128 PZP</a>). Jeśli tego nie zrobił, unieważnienie może być zaskarżalne.</p>

  <h3>3. Cena najkorzystniejszej oferty przekracza budżet (art. 255 pkt 3)</h3>

  <p>To <strong>najczęściej nadużywana przesłanka</strong>. Zamawiający twierdzi, że nie stać go na najkorzystniejszą ofertę. Ale uwaga — przepis mówi wyraźnie: unieważnienie jest uzasadnione tylko wtedy, gdy zamawiający <strong>nie może zwiększyć</strong> kwoty na sfinansowanie zamówienia.</p>

  <div style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;">
    <p style="margin: 0;"><strong>⚖️ Orzeczenie KIO 3382/25:</strong> Izba uchyliła unieważnienie, stwierdzając że zamawiający faktycznie dysponował wystarczającymi środkami. <em>&quot;Unieważnienie postępowania nie może służyć jako narzędzie do wpływania na wynik postępowania — nie jest uznaniowym wyjściem z niechcianego rezultatu.&quot;</em></p>
  </div>

  <h3>4. Istotna zmiana okoliczności (art. 255 pkt 4)</h3>

  <p>Zamawiający może unieważnić postępowanie, gdy wystąpiła <strong>istotna zmiana okoliczności</strong> powodująca, że prowadzenie postępowania lub wykonanie zamówienia nie leży w interesie publicznym. Warunki:</p>

  <ul>
    <li>Zmiana musi być <strong>istotna</strong> — nie wystarczy drobna korekta planów</li>
    <li>Zmiana <strong>nie mogła być wcześniej przewidziana</strong></li>
    <li>Dalsze prowadzenie postępowania <strong>nie leży w interesie publicznym</strong> — nie w interesie zamawiającego, lecz publicznym</li>
  </ul>

  <p>To przesłanka, na którą zamawiający powołują się chętnie, ale KIO interpretuje ją <strong>bardzo restrykcyjnie</strong>.</p>

  <h3>5. Wada ogłoszenia lub dokumentów (art. 255 pkt 5-6)</h3>

  <p>Jeśli ogłoszenie o zamówieniu lub specyfikacja zawiera wadę niemożliwą do usunięcia, uniemożliwiającą zawarcie ważnej umowy — zamawiający musi unieważnić postępowanie.</p>

  <div style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;">
    <p style="margin: 0;"><strong>⚖️ Orzeczenie KIO 4269/24:</strong> Zamawiający unieważnił przetarg na odbiór odpadów powołując się na &quot;wadę niemożliwą do usunięcia&quot;. KIO uchyliła decyzję, wskazując że wady w opisie przedmiotu zamówienia to <strong>błąd zamawiającego</strong>, a konsekwencje takich błędów nie mogą być przerzucane na wykonawców. Zamawiający jest &quot;gospodarzem postępowania&quot; i musi dochować należytej staranności przy przygotowaniu dokumentacji.</p>
  </div>

  <h3>6. Zwycięzca nie podpisał umowy (art. 255 pkt 7)</h3>

  <p>Gdy wykonawca, którego oferta została wybrana, uchyla się od zawarcia umowy lub nie wnosi wymaganego zabezpieczenia — zamawiający może wybrać kolejną ofertę lub unieważnić postępowanie.</p>

  <h2>Kiedy zamawiający MOŻE unieważnić przetarg (art. 256 PZP)</h2>

  <p>Artykuł 256 daje zamawiającemu <strong>fakultatywną</strong> możliwość unieważnienia, ale z istotnymi ograniczeniami:</p>

  <ul>
    <li>Można to zrobić tylko <strong>przed upływem terminu składania ofert</strong></li>
    <li>Muszą wystąpić okoliczności powodujące, że dalsze prowadzenie jest <strong>nieuzasadnione</strong></li>
    <li>Po otwarciu ofert — ta przesłanka już nie może być stosowana</li>
  </ul>

  <p>Dodatkowo art. 257 pozwala na unieważnienie, gdy środki z budżetu UE nie zostały przyznane — ale <strong>tylko jeśli zamawiający zastrzegł to w ogłoszeniu</strong>.</p>

  <h2>Jak się bronić — krok po kroku</h2>

  <h3>Krok 1: Przeanalizuj podstawę prawną</h3>

  <p>Zamawiający musi wskazać konkretny punkt art. 255 lub 256. Sprawdź, czy podana przesłanka faktycznie zachodzi. Najczęstsze błędy zamawiających:</p>

  <ul>
    <li><strong>Art. 255 pkt 3</strong> — zamawiający ma budżet, ale twierdzi że nie ma (sprawdź BIP, uchwały budżetowe)</li>
    <li><strong>Art. 255 pkt 4</strong> — &quot;zmiana okoliczności&quot; to w rzeczywistości zmiana preferencji zamawiającego</li>
    <li><strong>Art. 255 pkt 6</strong> — &quot;wada&quot; to błąd zamawiającego w dokumentacji, który mógł naprawić</li>
  </ul>

  <h3>Krok 2: Sprawdź orzecznictwo KIO</h3>

  <p>Przed złożeniem odwołania koniecznie sprawdź, jak KIO orzekała w podobnych sprawach. Wyszukaj w <a href="/szukaj">wyszukiwarce orzeczeń KIO</a> frazy takie jak:</p>

  <ul>
    <li>&quot;unieważnienie postępowania art. 255 pkt 3&quot;</li>
    <li>&quot;brak środków finansowych unieważnienie&quot;</li>
    <li>&quot;wada postępowania art. 255 pkt 6&quot;</li>
    <li>&quot;interes publiczny unieważnienie&quot;</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <p style="margin: 0; color: #d4af37;"><strong>🔍 Baza orzeczeń KIO na Przetargowi.pl</strong> pozwala przeszukiwać tysiące wyroków wyszukiwarką semantyczną — wystarczy opisać swoją sytuację, a system znajdzie najlepiej pasujące orzeczenia. <a href="/szukaj" style="color: #d4af37;">Sprawdź teraz →</a></p>
  </div>

  <h3>Krok 3: Złóż odwołanie do KIO</h3>

  <p>Jeśli analiza potwierdza, że unieważnienie jest bezpodstawne — składaj odwołanie. Terminy są krótkie i nieprzekraczalne:</p>

  <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
    <tr style="background: #f5f5f5;">
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Typ postępowania</th>
      <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Termin na odwołanie</th>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Powyżej progów unijnych</td>
      <td style="padding: 12px; border: 1px solid #ddd;"><strong>10 dni</strong> od dnia przekazania informacji o unieważnieniu</td>
    </tr>
    <tr>
      <td style="padding: 12px; border: 1px solid #ddd;">Poniżej progów unijnych</td>
      <td style="padding: 12px; border: 1px solid #ddd;"><strong>5 dni</strong> od dnia przekazania informacji o unieważnieniu</td>
    </tr>
  </table>

  <p>Więcej o procedurze odwoławczej przeczytasz w naszym artykule <a href="/blog/jak-odwolac-sie-do-kio">Jak odwołać się do KIO — krok po kroku</a>.</p>

  <h3>Krok 4: Żądaj zwrotu kosztów (art. 261 PZP)</h3>

  <p>Nawet jeśli nie składasz odwołania, masz prawo do <strong>zwrotu uzasadnionych kosztów przygotowania oferty</strong>, gdy unieważnienie nastąpiło z przyczyn leżących po stronie zamawiającego. Dotyczy to m.in.:</p>

  <ul>
    <li>Kosztów przygotowania dokumentacji ofertowej</li>
    <li>Kosztów wadium (jeśli było wpłacone)</li>
    <li>Kosztów ekspertyz, kosztorysów, opinii technicznych</li>
    <li>Kosztów gwarancji bankowej lub ubezpieczeniowej</li>
  </ul>

  <p><strong>Ważne:</strong> Prawo do zwrotu kosztów mają tylko wykonawcy, których oferty nie zostały odrzucone przed unieważnieniem. Jeśli zamawiający odmawia zapłaty — dochodzisz roszczenia przed sądem cywilnym.</p>

  <h2>Na co zwracać uwagę — praktyczne wskazówki</h2>

  <h3>Sygnały ostrzegawcze &quot;pozornego&quot; unieważnienia</h3>

  <ul>
    <li>Zamawiający unieważnia postępowanie tuż po otwarciu ofert, gdy okazuje się że wygrał &quot;niewłaściwy&quot; wykonawca</li>
    <li>Powołanie się na &quot;brak środków&quot; przy niewielkiej różnicy między budżetem a ceną oferty</li>
    <li>Unieważnienie z powodu &quot;wady&quot;, o której zamawiający wiedział od początku</li>
    <li>Szybkie ogłoszenie nowego postępowania na ten sam przedmiot z innymi warunkami</li>
  </ul>

  <h3>Kiedy NIE warto się odwoływać</h3>

  <ul>
    <li>Rzeczywiście nie wpłynęła żadna ważna oferta</li>
    <li>Cena najkorzystniejszej oferty wielokrotnie przekracza budżet</li>
    <li>Zmiana okoliczności jest obiektywna i udokumentowana (np. utrata dofinansowania)</li>
    <li>Koszty odwołania (wpis 7 500 – 20 000 zł) przewyższają potencjalne korzyści</li>
  </ul>

  <h2>Statystyki — jak często KIO przyznaje rację wykonawcom?</h2>

  <p>Analiza orzecznictwa KIO z lat 2024-2025 pokazuje, że <strong>znaczna część unieważnień jest bezpodstawna</strong>. W większości spraw, w których wykonawcy złożyli odwołanie od unieważnienia, stan faktyczny nie spełniał przesłanek prawnych wskazanych przez zamawiającego.</p>

  <p>Średnio w polskich przetargach składanych jest <strong>2,89 ofert na postępowanie</strong> (dane UZP za 2024 r., wzrost z 2,63 w 2023 r.), co oznacza rosnącą konkurencję — a tym samym więcej potencjalnie poszkodowanych wykonawców w przypadku niezasadnego unieważnienia.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <h4 style="color: #d4af37; margin-top: 0;">🔍 Przetargowi.pl — Twoje narzędzia do obrony w przetargach</h4>
    <ul style="color: #e0e0e0; margin-bottom: 0;">
      <li><a href="/szukaj" style="color: #d4af37;"><strong>Baza orzeczeń KIO</strong></a> — tysiące wyroków z wyszukiwarką semantyczną</li>
      <li><a href="/przetargi" style="color: #d4af37;"><strong>Aktualne przetargi</strong></a> — monitoruj nowe postępowania w swojej branży</li>
      <li><a href="/analiza-rynku" style="color: #d4af37;"><strong>Analiza rynku</strong></a> — sprawdź konkurencję i zamawiających w Twojej kategorii CPV</li>
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
      'Kiedy zamawiający może unieważnić przetarg — i jak się bronić',
      'uniewaznienie-przetargu-jak-sie-bronic',
      'Analiza podstaw prawnych unieważnienia przetargu (art. 255-256 PZP). Przesłanki obligatoryjne i fakultatywne, orzecznictwo KIO, prawo do zwrotu kosztów i praktyczny poradnik odwołania.',
      'Kiedy zamawiający może unieważnić przetarg? Art. 255-256 PZP, przesłanki unieważnienia, orzeczenia KIO, zwrot kosztów oferty (art. 261), terminy odwołań. Praktyczny poradnik dla wykonawców.',
      'unieważnienie przetargu, art 255 PZP, art 256 PZP, odwołanie od unieważnienia, KIO unieważnienie, zwrot kosztów oferty, przesłanki unieważnienia, zamówienia publiczne',
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
    execute("DELETE FROM articles WHERE slug = 'uniewaznienie-przetargu-jak-sie-bronic'")
  end
end
