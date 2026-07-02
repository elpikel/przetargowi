defmodule Przetargowi.Repo.Migrations.InsertBlogArticleRazacoNiskaCena do
  use Ecto.Migration

  @content """
<h2>Rażąco niska cena — dlaczego to jedno z najgroźniejszych ryzyk w przetargu</h2>

<p>Złożyłeś najtańszą ofertę i cieszysz się z wygranej? Zbyt wcześnie. Jeśli Twoja cena znacząco odbiega od pozostałych, zamawiający ma obowiązek zapytać, <strong>czy w ogóle da się za nią wykonać zamówienie</strong>. To procedura wyjaśnień rażąco niskiej ceny (RNC) — a jej finałem może być <strong>odrzucenie oferty</strong>.</p>

<p>W tym artykule tłumaczymy: kiedy uruchamia się próg 30%, co dokładnie napisać w wyjaśnieniach, na kim spoczywa ciężar dowodu i jak nie stracić kontraktu przez zbyt ogólnikową odpowiedź. Wszystko na gruncie aktualnej ustawy <a href="/ustawa-pzp">Prawo zamówień publicznych</a> i orzecznictwa KIO.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <p style="margin: 0; color: #d4af37;"><strong>💡 Zanim przeczytasz dalej:</strong> Zobacz, jak KIO rozstrzygała sprawy dotyczące rażąco niskiej ceny — przejrzyj orzeczenia oznaczone tym zagadnieniem w naszej <a href="/szukaj?zagadnienie=ra%C5%BC%C4%85co%20niska%20cena" rel="nofollow" style="color: #d4af37;">bazie orzeczeń KIO</a>.</p>
</div>

<h2>Czym jest rażąco niska cena?</h2>

<p>Ustawa nie definiuje &quot;rażąco niskiej ceny&quot; kwotowo. W orzecznictwie KIO przyjmuje się, że jest to cena <strong>nierealistyczna, nieadekwatna do zakresu i kosztów przedmiotu zamówienia</strong> — taka, która wskazuje, że wykonawca nie będzie w stanie zrealizować zamówienia z należytą starannością albo skalkulował ofertę poniżej kosztów wytworzenia.</p>

<p>Kluczowe: chodzi o cenę rażąco niską <strong>w stosunku do przedmiotu zamówienia</strong>, a nie po prostu &quot;najniższą&quot;. Niska cena sama w sobie nie jest wadą — wadą jest cena, której nie da się racjonalnie uzasadnić.</p>

<h2>Próg 30% — kiedy zamawiający MUSI wezwać do wyjaśnień (art. 224 PZP)</h2>

<p>Zgodnie z <a href="/ustawa-pzp#art-224">art. 224 ust. 2 pkt 1 PZP</a>, zamawiający zwraca się o wyjaśnienia w szczególności wtedy, gdy cena całkowita oferty jest <strong>niższa o co najmniej 30%</strong> od jednej z dwóch wartości odniesienia:</p>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Podstawa odniesienia</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Kiedy się liczy</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Wartość zamówienia powiększona o VAT</td>
    <td style="padding: 12px; border: 1px solid #ddd;">ustalona przez zamawiającego przed wszczęciem postępowania</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Średnia arytmetyczna cen wszystkich złożonych ofert</td>
    <td style="padding: 12px; border: 1px solid #ddd;">z pominięciem ofert podlegających odrzuceniu</td>
  </tr>
</table>

<p>Jeśli różnica sięga 30% względem którejkolwiek z tych wartości, wezwanie jest <strong>obowiązkowe</strong> — chyba że rozbieżność wynika z okoliczności oczywistych, niewymagających wyjaśnienia.</p>

<div style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;">
  <p style="margin: 0;"><strong>⚠️ Uwaga — 30% to nie jest sztywny automat.</strong> Zgodnie z <a href="/ustawa-pzp#art-224">art. 224 ust. 1 PZP</a> zamawiający może (a wręcz powinien) wezwać do wyjaśnień <em>zawsze</em>, gdy cena wydaje się rażąco niska i budzi wątpliwości co do możliwości wykonania — także przy różnicy mniejszej niż 30%. Odwrotnie: przekroczenie progu nie oznacza automatycznego odrzucenia — najpierw są wyjaśnienia.</p>
</div>

<h2>Wezwanie do wyjaśnień — masz jeden strzał</h2>

<p>Po otrzymaniu wezwania wykonawca składa <strong>wyjaśnienia wraz z dowodami</strong> w terminie wyznaczonym przez zamawiającego. Traktuj to jak jedyną szansę na obronę oferty — druga zwykle się nie pojawia.</p>

<p>Zgodnie z <a href="/ustawa-pzp#art-224">art. 224 ust. 3 PZP</a> wyjaśnienia mogą dotyczyć w szczególności:</p>

<ul>
  <li>zarządzania procesem produkcji, usług lub metody budowy oraz przyjętych rozwiązań technicznych,</li>
  <li>wyjątkowo sprzyjających warunków wykonania dostępnych dla wykonawcy,</li>
  <li>oryginalności oferowanych robót, dostaw lub usług,</li>
  <li>zgodności z przepisami dotyczącymi kosztów pracy (w tym <strong>minimalnego wynagrodzenia za pracę</strong> i minimalnej stawki godzinowej),</li>
  <li>zgodności z prawem pracy i zabezpieczenia społecznego,</li>
  <li>zgodności z przepisami z zakresu prawa ochrony środowiska,</li>
  <li>ewentualnej pomocy publicznej udzielonej na podstawie odrębnych przepisów.</li>
</ul>

<h2>Ciężar dowodu — to Ty musisz udowodnić, że cena jest realna</h2>

<p>To najważniejsza zasada całej procedury. Zgodnie z <a href="/ustawa-pzp#art-224">art. 224 ust. 5 PZP</a> <strong>obowiązek wykazania, że oferta nie zawiera rażąco niskiej ceny lub kosztu, spoczywa na wykonawcy</strong>, który tę ofertę złożył.</p>

<p>Innymi słowy: to nie zamawiający ma udowodnić, że cena jest za niska — to wykonawca ma udowodnić, że jest wystarczająca. Wyjaśnienia bez dowodów są w praktyce bezwartościowe.</p>

<div style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;">
  <p style="margin: 0;"><strong>⚖️ Linia orzecznicza KIO:</strong> Izba konsekwentnie odrzuca wyjaśnienia ogólnikowe. <em>Samo zapewnienie, że cena została skalkulowana rzetelnie i pozwala na wykonanie zamówienia, nie spełnia obowiązku z art. 224 ust. 5</em> — konieczne są konkretne kalkulacje i dowody. Przejrzyj analogiczne sprawy przez zagadnienie <a href="/szukaj?zagadnienie=obowi%C4%85zek%20wykazania%2C%20%C5%BCe%20oferta%20nie%20zawiera%20ra%C5%BC%C4%85co%20niskiej%20ceny" rel="nofollow">obowiązek wykazania, że oferta nie zawiera rażąco niskiej ceny</a>.</p>
</div>

<h2>Co konkretnie napisać w wyjaśnieniach RNC</h2>

<p>Dobre wyjaśnienia to <strong>szczegółowa kalkulacja plus dowody na każdą istotną pozycję kosztową</strong>. Zbuduj je wokół takich elementów:</p>

<ul>
  <li><strong>Rozbicie ceny na pozycje kosztowe</strong> — materiały, robocizna, sprzęt, koszty pośrednie, zysk. Pokaż, że suma się domyka.</li>
  <li><strong>Dowody cen zakupu</strong> — oferty i cenniki dostawców, umowy ramowe, oferty podwykonawców, rabaty potwierdzone na piśmie.</li>
  <li><strong>Koszty pracy</strong> — wykaż, że stawki nie są niższe niż minimalne wynagrodzenie / minimalna stawka godzinowa; dołącz kalkulację roboczogodzin.</li>
  <li><strong>Wyjątkowo sprzyjające warunki</strong> — własny park maszynowy, magazyn w pobliżu, posiadane licencje, materiał z wcześniejszych zakupów.</li>
  <li><strong>Rozwiązania techniczne / organizacyjne</strong> — konkretna technologia lub metoda, która realnie obniża koszt (z uzasadnieniem o ile i dlaczego).</li>
  <li><strong>Doświadczenie w analogicznych realizacjach</strong> — referencje pokazujące, że za podobną cenę zrealizowałeś podobny zakres.</li>
</ul>

<h3>Najczęstsze błędy, które kończą się odrzuceniem</h3>

<ul>
  <li>Ogólniki bez liczb (&quot;mamy korzystne warunki&quot;) — bez kalkulacji i dowodów.</li>
  <li>Brak dowodów na deklarowane ceny materiałów lub podwykonawców.</li>
  <li>Pominięcie istotnej pozycji kosztowej, co czyni kalkulację niespójną.</li>
  <li>Stawki robocizny poniżej minimalnego wynagrodzenia.</li>
  <li>Spóźnione wyjaśnienia lub ich brak — to samodzielna podstawa odrzucenia.</li>
</ul>

<p>Więcej typowych potknięć omawiamy w artykule <a href="/blog/najczestsze-bledy-oferty-przetargowe">Najczęstsze błędy w ofertach przetargowych</a>.</p>

<h2>Kiedy oferta zostaje odrzucona</h2>

<p>Oferta podlega odrzuceniu jako zawierająca rażąco niską cenę w dwóch sytuacjach:</p>

<ul>
  <li><strong><a href="/ustawa-pzp#art-224">Art. 224 ust. 6 PZP</a></strong> — gdy wykonawca nie złożył wyjaśnień w wyznaczonym terminie albo gdy złożone wyjaśnienia wraz z dowodami <strong>nie uzasadniają</strong> podanej w ofercie ceny lub kosztu.</li>
  <li><strong><a href="/ustawa-pzp#art-226">Art. 226 ust. 1 pkt 8 PZP</a></strong> — zamawiający odrzuca ofertę, która zawiera rażąco niską cenę lub koszt w stosunku do przedmiotu zamówienia.</li>
</ul>

<p>Ocena wyjaśnień należy do zamawiającego, ale nie jest dowolna — musi być rzetelna i oparta na całości przedłożonych dowodów. Jeżeli odrzucono Twoją ofertę mimo solidnych wyjaśnień, masz prawo złożyć odwołanie do KIO. Zobacz orzeczenia dotyczące <a href="/szukaj?zagadnienie=odrzucenie%20oferty" rel="nofollow">odrzucenia oferty</a> oraz <a href="/szukaj?zagadnienie=wyja%C5%9Bnienia%20ra%C5%BC%C4%85co%20niskiej%20ceny" rel="nofollow">wyjaśnień rażąco niskiej ceny</a>, a procedurę krok po kroku opisujemy w artykule <a href="/blog/jak-odwolac-sie-do-kio">Jak odwołać się do KIO</a>.</p>

<h2>Powiązane zagadnienia w orzecznictwie KIO</h2>

<p>Przejrzyj orzeczenia Krajowej Izby Odwoławczej pogrupowane według zagadnień merytorycznych:</p>

<ul>
  <li><a href="/szukaj?zagadnienie=ra%C5%BC%C4%85co%20niska%20cena" rel="nofollow">rażąco niska cena</a></li>
  <li><a href="/szukaj?zagadnienie=wyja%C5%9Bnienia%20ra%C5%BC%C4%85co%20niskiej%20ceny" rel="nofollow">wyjaśnienia rażąco niskiej ceny</a></li>
  <li><a href="/szukaj?zagadnienie=oferta%20zawieraj%C4%85ca%20ra%C5%BC%C4%85co%20nisk%C4%85%20cen%C4%99" rel="nofollow">oferta zawierająca rażąco niską cenę</a></li>
  <li><a href="/szukaj?zagadnienie=odrzucenie%20oferty" rel="nofollow">odrzucenie oferty</a></li>
  <li><a href="/szukaj?zagadnienie=obowi%C4%85zek%20wykazania%2C%20%C5%BCe%20oferta%20nie%20zawiera%20ra%C5%BC%C4%85co%20niskiej%20ceny" rel="nofollow">obowiązek wykazania, że oferta nie zawiera rażąco niskiej ceny</a></li>
</ul>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">🔍 Przetargowi.pl — Twoje narzędzia w postępowaniu</h4>
  <ul style="color: #e0e0e0; margin-bottom: 0;">
    <li><a href="/szukaj" style="color: #d4af37;"><strong>Baza orzeczeń KIO</strong></a> — tysiące wyroków z wyszukiwarką semantyczną i filtrem zagadnień</li>
    <li><a href="/przetargi" style="color: #d4af37;"><strong>Aktualne przetargi</strong></a> — monitoruj nowe postępowania w swojej branży</li>
    <li><a href="/analiza-rynku" style="color: #d4af37;"><strong>Analiza rynku</strong></a> — sprawdź poziom cen i konkurencję w Twojej kategorii CPV</li>
    <li><a href="/ustawa-pzp" style="color: #d4af37;"><strong>Ustawa Pzp</strong></a> — pełny tekst z bezpośrednimi linkami do artykułów</li>
  </ul>
</div>

<p style="font-size: 0.9em; color: #666; margin-top: 24px;"><em>Artykuł ma charakter informacyjny i nie stanowi porady prawnej. W konkretnej sprawie skonsultuj się z profesjonalnym pełnomocnikiem.</em></p>
"""

  def up do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    escaped_content = String.replace(@content, "'", "''")

    execute("""
    INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
    VALUES (
      'Rażąco niska cena — jak uzasadnić swoją ofertę i nie zostać wykluczonym',
      'razaco-niska-cena-wyjasnienia-jak-uzasadnic-oferte',
      'Próg 30%, obowiązek dowodowy po stronie wykonawcy, co napisać w wyjaśnieniach rażąco niskiej ceny i kiedy oferta zostaje odrzucona. Przewodnik po art. 224 i 226 PZP z orzecznictwem KIO.',
      'Rażąco niska cena w przetargu — próg 30%, wyjaśnienia RNC (art. 224 PZP), ciężar dowodu wykonawcy, odrzucenie oferty (art. 226 ust. 1 pkt 8), orzeczenia KIO. Praktyczny poradnik.',
      'rażąco niska cena, wyjaśnienia rażąco niskiej ceny, art 224 PZP, art 226 PZP, odrzucenie oferty, próg 30%, ciężar dowodu, orzeczenia KIO, rażąco niska cena jak wyjaśnić, zamówienia publiczne',
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
    execute("DELETE FROM articles WHERE slug = 'razaco-niska-cena-wyjasnienia-jak-uzasadnic-oferte'")
  end
end
