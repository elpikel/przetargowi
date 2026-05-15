defmodule Przetargowi.Repo.Migrations.InsertBlogArticleJudgementNavigation do
  use Ecto.Migration

  @content """
<h2>Wprowadzenie</h2>

<p>Platforma <strong>Przetargowi.pl</strong> została zaprojektowana tak, aby maksymalnie ułatwić pracę z orzecznictwem KIO. Każdy element na stronie orzeczenia jest interaktywny — kliknięcie przenosi Cię do powiązanych orzeczeń lub bezpośrednio do odpowiedniego przepisu ustawy Pzp. W tym artykule pokażemy, jak efektywnie nawigować po bazie orzeczeń i korzystać z funkcji wyszukiwania.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <p style="margin: 0; color: #d4af37;"><strong>Nowość:</strong> Wszystkie metadane orzeczeń są teraz klikalne! Każdy element prowadzi do wyszukiwarki lub bezpośrednio do tekstu ustawy Pzp.</p>
</div>

<h2>Strona orzeczenia — wszystko jest klikalne</h2>

<p>Gdy otworzysz dowolne orzeczenie w <a href="/orzecznictwo-kio">bazie orzeczeń KIO</a>, zobaczysz panel boczny z metadanymi. Każdy z tych elementów jest linkiem, który przeniesie Cię do powiązanych treści.</p>

<h3>Informacje podstawowe</h3>

<p>W sekcji <strong>Informacje podstawowe</strong> znajdziesz:</p>

<ul>
  <li><strong>Organ wydający</strong> — kliknij, aby zobaczyć wszystkie orzeczenia tego organu (np. Krajowa Izba Odwoławcza, Sąd Okręgowy w Warszawie)</li>
  <li><strong>Rodzaj dokumentu</strong> — kliknij, aby wyfiltrować wyroki, postanowienia lub uchwały</li>
  <li><strong>Data wydania</strong> — kliknij, aby zobaczyć inne orzeczenia z tego samego dnia</li>
  <li><strong>Przewodniczący</strong> — kliknij, aby wyszukać orzeczenia wydane przez tego sędziego</li>
  <li><strong>Sposób rozstrzygnięcia</strong> — kliknij, aby zobaczyć tylko orzeczenia uwzględnione, oddalone, umorzone lub odrzucone</li>
</ul>

<h3>Zamawiający</h3>

<p>Sekcja <strong>Zamawiający</strong> pokazuje dane instytucji, której dotyczy sprawa:</p>

<ul>
  <li><strong>Nazwa zamawiającego</strong> — kliknij, aby znaleźć wszystkie orzeczenia dotyczące tej instytucji</li>
  <li><strong>Miejscowość</strong> — kliknij, aby wyszukać orzeczenia z danego miasta</li>
</ul>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">Praktyczny przykład</h4>
  <p style="color: #e0e0e0; margin-bottom: 0;">Przeglądasz orzeczenie dotyczące szpitala wojewódzkiego? Kliknij nazwę zamawiającego, aby sprawdzić historię jego spraw przed KIO — to pomoże Ci ocenić, jak zamawiający reaguje na odwołania i jakie ma statystyki wygranych/przegranych.</p>
</div>

<h3>Tryb postępowania</h3>

<p>Kliknięcie na <strong>tryb postępowania</strong> (np. przetarg nieograniczony, tryb podstawowy, zamówienie z wolnej ręki) przeniesie Cię do wyszukiwarki z odpowiednim filtrem. Dzięki temu szybko znajdziesz orzeczenia dotyczące konkretnego trybu zamówienia.</p>

<h3>Kluczowe przepisy ustawy Pzp — bezpośredni link do tekstu</h3>

<p>To jedna z najważniejszych funkcji! W sekcji <strong>Kluczowe przepisy ustawy Pzp</strong> wyświetlane są artykuły, na które powołano się w orzeczeniu. Każdy przepis jest linkiem prowadzącym bezpośrednio do odpowiedniego miejsca w tekście <a href="/ustawa-pzp">ustawy Prawo zamówień publicznych</a>.</p>

<p>Na przykład kliknięcie na <code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">art. 226 ust. 1 pkt 5</code> otworzy stronę ustawy Pzp i automatycznie przewinie do artykułu 226.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">Pełny tekst ustawy Pzp</h4>
  <p style="color: #e0e0e0; margin-bottom: 12px;">Na <strong>Przetargowi.pl</strong> udostępniamy kompletny tekst <a href="/ustawa-pzp" style="color: #d4af37;">ustawy Prawo zamówień publicznych</a> z bezpośrednimi linkami do każdego artykułu. Możesz udostępniać linki do konkretnych przepisów, np.:</p>
  <ul style="color: #e0e0e0; margin-bottom: 0;">
    <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">przetargowi.pl/ustawa-pzp#art-226</code> — przesłanki odrzucenia oferty</li>
    <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">przetargowi.pl/ustawa-pzp#art-505</code> — prawo do odwołania</li>
  </ul>
</div>

<h3>Zagadnienia merytoryczne — tagi tematyczne</h3>

<p>Każde orzeczenie ma przypisane <strong>zagadnienia merytoryczne</strong> — tagi opisujące główne tematy sprawy. Mogą to być np.:</p>

<ul>
  <li>rażąco niska cena</li>
  <li>tajemnica przedsiębiorstwa</li>
  <li>podmiot trzeci</li>
  <li>warunki udziału</li>
  <li>kryteria oceny ofert</li>
</ul>

<p>Kliknięcie na dowolny tag uruchamia wyszukiwanie orzeczeń dotyczących tego samego zagadnienia. To najszybszy sposób na znalezienie podobnych spraw!</p>

<h2>Wyszukiwarka orzeczeń — dwa tryby</h2>

<p>Platforma <a href="/szukaj">Przetargowi.pl</a> oferuje dwa tryby wyszukiwania, które uzupełniają się nawzajem.</p>

<h3>Tryb 1: Słowa kluczowe</h3>

<p>Klasyczne wyszukiwanie tekstowe — system znajduje orzeczenia zawierające dokładnie te słowa, które wpiszesz.</p>

<p><strong>Kiedy używać:</strong></p>
<ul>
  <li>Znasz sygnaturę orzeczenia (np. <code style="background: #f3e4c3; padding: 2px 6px; border-radius: 4px;">KIO 1234/24</code>)</li>
  <li>Szukasz orzeczeń dotyczących konkretnego przepisu (np. <code style="background: #f3e4c3; padding: 2px 6px; border-radius: 4px;">art. 226 pkt 5</code>)</li>
  <li>Znasz dokładny termin prawny (np. <code style="background: #f3e4c3; padding: 2px 6px; border-radius: 4px;">rażąco niska cena</code>)</li>
  <li>Szukasz orzeczeń konkretnego zamawiającego</li>
</ul>

<h3>Tryb 2: Semantyczne (AI)</h3>

<p>Wyszukiwanie oparte na sztucznej inteligencji — system rozumie <em>znaczenie</em> Twojego zapytania i znajduje orzeczenia dotyczące podobnych sytuacji, nawet jeśli używają innej terminologii.</p>

<p><strong>Kiedy używać:</strong></p>
<ul>
  <li>Opisujesz stan faktyczny sprawy własnymi słowami</li>
  <li>Szukasz precedensów do konkretnej sytuacji klienta</li>
  <li>Nie znasz dokładnego przepisu ani terminologii</li>
  <li>Chcesz znaleźć orzeczenia z podobnym stanem faktycznym</li>
</ul>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">Przykład wyszukiwania semantycznego</h4>
  <p style="color: #e0e0e0; margin-bottom: 12px;">Zamiast szukać konkretnego przepisu, możesz wpisać:</p>
  <p style="color: #e0e0e0; margin-bottom: 0;"><code style="background: rgba(212, 175, 55, 0.2); padding: 4px 8px; border-radius: 4px;">wykonawca nie dołączył dokumentów potwierdzających doświadczenie w robotach budowlanych</code></p>
  <p style="color: #e0e0e0; margin-top: 12px; margin-bottom: 0;">System znajdzie orzeczenia dotyczące takich sytuacji, nawet jeśli używają innych sformułowań.</p>
</div>

<h2>Filtry wyszukiwania</h2>

<p>Niezależnie od wybranego trybu wyszukiwania, możesz zawęzić wyniki używając filtrów:</p>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Filtr</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Zastosowanie</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Rodzaj dokumentu</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd;">Wyrok, postanowienie, uchwała</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Organ wydający</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd;">KIO, Sąd Okręgowy, Sąd Apelacyjny</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Sposób rozstrzygnięcia</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd;">Uwzględnione, oddalone, umorzone, odrzucone</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Tryb postępowania</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd;">Przetarg nieograniczony, tryb podstawowy, zamówienie z wolnej ręki</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Zakres dat</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd;">Od/do kiedy wydano orzeczenie</td>
  </tr>
</table>

<h2>Praktyczny workflow — od orzeczenia do precedensów</h2>

<p>Pokażemy, jak efektywnie wykorzystać interaktywne elementy strony orzeczenia.</p>

<h3>Scenariusz: Szukasz precedensów do sprawy o rażąco niską cenę</h3>

<ol>
  <li><strong>Otwórz dowolne orzeczenie</strong> dotyczące rażąco niskiej ceny</li>
  <li><strong>Kliknij na tag „rażąco niska cena"</strong> w sekcji Zagadnienia merytoryczne</li>
  <li><strong>Dodaj filtr „Sposób rozstrzygnięcia: uwzględnione"</strong> jeśli reprezentujesz odwołującego</li>
  <li><strong>Przeglądaj znalezione orzeczenia</strong> — masz gotową listę precedensów</li>
</ol>

<h3>Scenariusz: Sprawdzasz wykładnię konkretnego przepisu</h3>

<ol>
  <li><strong>Otwórz orzeczenie</strong> powołujące interesujący Cię przepis</li>
  <li><strong>Kliknij na przepis</strong> (np. art. 226 pkt 5) w sekcji Kluczowe przepisy</li>
  <li><strong>Przeczytaj treść przepisu</strong> w ustawie Pzp</li>
  <li><strong>Wróć do wyszukiwarki</strong> i wpisz numer artykułu, aby znaleźć inne orzeczenia</li>
</ol>

<h3>Scenariusz: Analizujesz historię spraw zamawiającego</h3>

<ol>
  <li><strong>Otwórz orzeczenie</strong> dotyczące interesującego Cię zamawiającego</li>
  <li><strong>Kliknij na nazwę zamawiającego</strong> w sekcji Zamawiający</li>
  <li><strong>Przeglądaj wszystkie sprawy</strong> tego zamawiającego przed KIO</li>
  <li><strong>Oceń statystyki</strong> — ile spraw wygrał, ile przegrał</li>
</ol>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">Wskazówka dla prawników</h4>
  <p style="color: #e0e0e0; margin-bottom: 0;">Klikając na przewodniczącego składu orzekającego, możesz przeanalizować jego dotychczasowe orzeczenia. Pomoże Ci to przewidzieć podejście sędziego do określonych zagadnień prawnych.</p>
</div>

<h2>Baza orzeczeń Przetargowi.pl</h2>

<p>Nasza baza zawiera <strong>ponad 33 000 orzeczeń KIO</strong> z pełnymi uzasadnieniami. Każde orzeczenie jest wzbogacone o:</p>

<ul>
  <li><strong>Meritum</strong> — automatycznie wygenerowane streszczenie najważniejszych tez</li>
  <li><strong>Kluczowe przepisy</strong> — z bezpośrednimi linkami do ustawy Pzp</li>
  <li><strong>Zagadnienia merytoryczne</strong> — tagi ułatwiające wyszukiwanie podobnych spraw</li>
  <li><strong>Pełne metadane</strong> — wszystkie klikalne i prowadzące do wyszukiwarki</li>
</ul>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">Wypróbuj już teraz</h4>
  <p style="color: #e0e0e0; margin-bottom: 12px;">Korzystaj z naszych narzędzi:</p>
  <ul style="color: #e0e0e0; margin-bottom: 12px;">
    <li><a href="/szukaj" style="color: #d4af37;"><strong>Wyszukiwarka orzeczeń KIO</strong></a> — słowa kluczowe lub wyszukiwanie semantyczne AI</li>
    <li><a href="/ustawa-pzp" style="color: #d4af37;"><strong>Ustawa Prawo zamówień publicznych</strong></a> — pełny tekst z bezpośrednimi linkami</li>
    <li><a href="/blog/jak-odwolac-sie-do-kio" style="color: #d4af37;"><strong>Poradnik: Jak odwołać się do KIO</strong></a> — terminy, koszty, procedura</li>
  </ul>
  <p style="color: #e0e0e0; margin-bottom: 0;"><a href="/orzecznictwo-kio" style="color: #d4af37; font-weight: bold;">→ Przejdź do bazy orzeczeń KIO</a></p>
</div>

<h2>Podsumowanie</h2>

<p>Platforma <strong>Przetargowi.pl</strong> została zaprojektowana z myślą o efektywnej pracy prawnika zamówień publicznych:</p>

<ul>
  <li><strong>Wszystkie metadane są klikalne</strong> — każdy element prowadzi do wyszukiwarki lub ustawy Pzp</li>
  <li><strong>Przepisy linkują do ustawy</strong> — nie musisz szukać tekstu prawnego osobno</li>
  <li><strong>Dwa tryby wyszukiwania</strong> — słowa kluczowe dla precyzyjnych zapytań, AI dla opisu stanu faktycznego</li>
  <li><strong>Filtry zawężają wyniki</strong> — szybko znajdziesz precedensy z korzystnym rozstrzygnięciem</li>
</ul>

<p>Zacznij korzystać z <a href="/szukaj">wyszukiwarki orzeczeń KIO</a> już dziś i przekonaj się, jak łatwo można znaleźć potrzebne precedensy!</p>
"""

  def up do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    escaped_content = String.replace(@content, "'", "''")

    execute("""
    INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
    VALUES (
      'Nawigacja po orzeczeniach KIO — klikalne metadane i połączenie z ustawą Pzp',
      'nawigacja-orzeczenia-kio-klikalne-metadane',
      'Jak efektywnie nawigować po bazie orzeczeń KIO. Klikalne metadane, bezpośrednie linki do ustawy Pzp, wyszukiwanie słów kluczowych i semantyczne AI.',
      'Nawigacja po orzeczeniach KIO na Przetargowi.pl. Klikalne metadane orzeczeń, bezpośrednie linki do przepisów ustawy Pzp, wyszukiwanie słów kluczowych i AI.',
      'orzeczenia KIO, wyszukiwarka KIO, ustawa Pzp, przepisy Pzp, baza orzeczeń, metadane orzeczeń, wyszukiwanie semantyczne, AI zamówienia publiczne',
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
      "DELETE FROM articles WHERE slug = 'nawigacja-orzeczenia-kio-klikalne-metadane'"
    )
  end
end
