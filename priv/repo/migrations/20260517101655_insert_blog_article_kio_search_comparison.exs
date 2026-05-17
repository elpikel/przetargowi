defmodule Przetargowi.Repo.Migrations.InsertBlogArticleKioSearchComparison do
  use Ecto.Migration

  @content """
<h2>Wprowadzenie</h2>

<p>Poszukiwanie orzeczeń Krajowej Izby Odwoławczej to codzienność każdego specjalisty ds. zamówień publicznych. Niezależnie od tego, czy przygotowujesz odwołanie, analizujesz ryzyko prawne, czy szukasz precedensów dla klienta — potrzebujesz narzędzia, które szybko dostarczy Ci właściwe orzeczenia. Na polskim rynku istnieje kilka rozwiązań, ale różnią się one znacząco pod względem funkcjonalności, ceny i użyteczności.</p>

<p>W tym artykule porównamy dostępne wyszukiwarki orzeczeń KIO i pokażemy, dlaczego <strong>Przetargowi.pl</strong> oferuje najlepszy stosunek jakości do ceny — szczególnie dzięki unikalnemu <strong>wyszukiwaniu semantycznemu opartemu na sztucznej inteligencji</strong>.</p>

<h2>Przegląd dostępnych rozwiązań</h2>

<p>Na polskim rynku funkcjonuje kilka platform oferujących dostęp do orzecznictwa KIO:</p>

<table style="width: 100%; border-collapse: collapse; margin: 24px 0;">
  <tr style="background: #1a1a2e; color: #d4af37;">
    <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: left;">Platforma</th>
    <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: left;">Cena miesięczna</th>
    <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: left;">Wyszukiwanie AI</th>
    <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: left;">Specjalizacja KIO</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Przetargowi.pl</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; color: #2e7d32; font-weight: bold;">29 zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; color: #2e7d32;">✓ Tak</td>
    <td style="padding: 12px; border: 1px solid #ddd; color: #2e7d32;">✓ Pełna</td>
  </tr>
  <tr style="background: #f9f9f9;">
    <td style="padding: 12px; border: 1px solid #ddd;">LEX Zamówienia Publiczne</td>
    <td style="padding: 12px; border: 1px solid #ddd;">od 142 zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; color: #c62828;">✗ Nie</td>
    <td style="padding: 12px; border: 1px solid #ddd;">Częściowa</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Legalis (C.H. Beck)</td>
    <td style="padding: 12px; border: 1px solid #ddd;">od 200+ zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; color: #c62828;">✗ Nie</td>
    <td style="padding: 12px; border: 1px solid #ddd;">Moduł ogólny</td>
  </tr>
  <tr style="background: #f9f9f9;">
    <td style="padding: 12px; border: 1px solid #ddd;">SzuKIO.pl</td>
    <td style="padding: 12px; border: 1px solid #ddd;">132 zł (1 584 zł/rok)</td>
    <td style="padding: 12px; border: 1px solid #ddd; color: #c62828;">✗ Nie</td>
    <td style="padding: 12px; border: 1px solid #ddd;">✓ Pełna</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">UZP (gov.pl)</td>
    <td style="padding: 12px; border: 1px solid #ddd;">Darmowe</td>
    <td style="padding: 12px; border: 1px solid #ddd; color: #c62828;">✗ Nie</td>
    <td style="padding: 12px; border: 1px solid #ddd;">Oficjalna baza</td>
  </tr>
</table>


<h2>Dlaczego wyszukiwanie semantyczne zmienia zasady gry?</h2>

<p>Tradycyjne wyszukiwarki działają na zasadzie <strong>dopasowania słów kluczowych</strong>. Wpisujesz frazę, system szuka dokładnie tych słów w treści orzeczeń. Problem pojawia się, gdy:</p>

<ul>
  <li>Nie znasz dokładnej terminologii prawnej</li>
  <li>Orzeczenie używa synonimów lub innych sformułowań</li>
  <li>Opisujesz sytuację faktyczną, a nie przepis</li>
  <li>Szukasz orzeczeń o podobnym stanie faktycznym</li>
</ul>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">Przykład z praktyki</h4>
  <p style="color: #e0e0e0; margin-bottom: 12px;"><strong>Tradycyjne wyszukiwanie:</strong> Wpisujesz „wykonawca nie złożył dokumentów" — system znajdzie tylko orzeczenia z dokładnie tą frazą.</p>
  <p style="color: #e0e0e0; margin-bottom: 0;"><strong>Wyszukiwanie semantyczne AI:</strong> Wpisujesz to samo — system rozumie, że chodzi o brak dokumentów i znajdzie również orzeczenia mówiące o „niezłożeniu wymaganych dokumentów", „braku załączników do oferty", „nieuzupełnieniu dokumentów w terminie" i podobne przypadki.</p>
</div>

<p><strong>Wyszukiwanie semantyczne</strong> na Przetargowi.pl wykorzystuje model sztucznej inteligencji OpenAI, który rozumie <em>znaczenie</em> Twojego zapytania — nie tylko słowa. Dzięki temu znajdziesz orzeczenia, których nigdy nie znalazłbyś tradycyjnym wyszukiwaniem.</p>

<h2>Szczegółowe porównanie platform</h2>

<h3>1. Oficjalna wyszukiwarka UZP (orzeczenia.uzp.gov.pl)</h3>

<p><strong>Zalety:</strong></p>
<ul>
  <li>Bezpłatny dostęp</li>
  <li>Oficjalne źródło danych</li>
  <li>Podstawowe filtry wyszukiwania</li>
</ul>

<p><strong>Wady:</strong></p>
<ul>
  <li>Przestarzały interfejs użytkownika</li>
  <li>Wolne działanie</li>
  <li>Brak zaawansowanych funkcji wyszukiwania</li>
  <li>Ograniczone możliwości filtrowania</li>
  <li>Brak wyszukiwania AI</li>
</ul>

<p><strong>Dla kogo:</strong> Osoby potrzebujące sporadycznego dostępu do pojedynczych orzeczeń po sygnaturze.</p>

<h3>2. SzuKIO.pl</h3>

<p><strong>Zalety:</strong></p>
<ul>
  <li>Rozbudowana baza (50 000+ dokumentów)</li>
  <li>Odmiana fraz (szuka różnych form gramatycznych)</li>
  <li>Zawiera również orzeczenia SO, SN, TSUE</li>
</ul>

<p><strong>Wady:</strong></p>
<ul>
  <li><strong>Wysoka cena: 1 584 zł netto/rok</strong> (132 zł/miesiąc) — ponad 4x więcej niż Przetargowi.pl</li>
  <li><strong>Limit odsłon dokumentów</strong> (500 w planie standardowym)</li>
  <li>Brak wyszukiwania semantycznego AI</li>
  <li>Interfejs wymaga przyzwyczajenia</li>
  <li>Ograniczone możliwości nawigacji między powiązanymi orzeczeniami</li>
  <li>Brak bezpośrednich linków do przepisów ustawy Pzp</li>
</ul>

<p><strong>Dla kogo:</strong> Użytkownicy potrzebujący dostępu do orzeczeń wielu organów (SO, SN, TSUE) w jednym miejscu.</p>

<h3>3. LEX Zamówienia Publiczne (Wolters Kluwer)</h3>

<p><strong>Zalety:</strong></p>
<ul>
  <li>Renomowany dostawca</li>
  <li>Komentarze prawne i monografie</li>
  <li>Codzienne aktualizacje</li>
  <li>Wsparcie ekspertów</li>
</ul>

<p><strong>Wady:</strong></p>
<ul>
  <li><strong>Wysoka cena: od 142 zł/miesiąc</strong> (prawie 5x więcej niż Przetargowi.pl)</li>
  <li>Brak wyszukiwania AI</li>
  <li>Skierowany do dużych kancelarii i instytucji</li>
  <li>Umowa na 12 miesięcy</li>
</ul>

<p><strong>Dla kogo:</strong> Duże kancelarie prawne z budżetem na drogie narzędzia.</p>

<h3>4. Legalis (C.H. Beck)</h3>

<p><strong>Zalety:</strong></p>
<ul>
  <li>Kompleksowy system prawny</li>
  <li>Moduły tematyczne</li>
  <li>Poradnia ekspercka</li>
</ul>

<p><strong>Wady:</strong></p>
<ul>
  <li><strong>Bardzo wysoka cena: 200+ zł/miesiąc</strong></li>
  <li>Zamówienia publiczne to tylko jeden z wielu modułów</li>
  <li>Brak specjalizacji w orzecznictwie KIO</li>
  <li>Brak wyszukiwania AI</li>
</ul>

<p><strong>Dla kogo:</strong> Kancelarie potrzebujące dostępu do całego systemu prawa, nie tylko zamówień publicznych.</p>

<h3>5. Przetargowi.pl</h3>

<p><strong>Zalety:</strong></p>
<ul>
  <li><strong>Unikalne wyszukiwanie semantyczne AI</strong> — jedyna platforma na rynku</li>
  <li><strong>Niska cena: 29 zł/miesiąc</strong> — 4-5x taniej niż konkurencja</li>
  <li><strong>Brak limitów odsłon dokumentów</strong> — przeglądaj bez ograniczeń</li>
  <li>Dwa tryby wyszukiwania (słowa kluczowe + AI)</li>
  <li>Wszystkie metadane są klikalne i prowadzą do powiązanych orzeczeń</li>
  <li>Bezpośrednie linki do przepisów <a href="/ustawa-pzp">ustawy Pzp</a></li>
  <li>Ponad 33 000 orzeczeń KIO z pełnymi uzasadnieniami</li>
  <li>Nowoczesny, responsywny interfejs</li>
  <li>Darmowy okres próbny (3 wyszukiwania)</li>
  <li>Brak długoterminowych zobowiązań</li>
</ul>

<p><strong>Wady:</strong></p>
<ul>
  <li>Młodsza platforma na rynku</li>
  <li>Baza skupiona na orzecznictwie KIO (bez SO, SN)</li>
</ul>

<p><strong>Dla kogo:</strong> Specjaliści ds. zamówień publicznych, prawnicy, wykonawcy — wszyscy, którzy cenią czas i efektywność.</p>

<h2>Funkcje unikalne dla Przetargowi.pl</h2>

<h3>Wyszukiwanie semantyczne AI</h3>

<p>Jako <strong>jedyna platforma na polskim rynku</strong> oferujemy wyszukiwanie oparte na sztucznej inteligencji. System rozumie kontekst i znaczenie zapytania, nie tylko dopasowuje słowa kluczowe.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">Jak działa wyszukiwanie AI?</h4>
  <p style="color: #e0e0e0; margin-bottom: 12px;">Twoje zapytanie jest przekształcane w wektor matematyczny (embedding) przez model OpenAI. Następnie system porównuje ten wektor z wektorami wszystkich orzeczeń w bazie i zwraca te najbardziej podobne semantycznie.</p>
  <p style="color: #e0e0e0; margin-bottom: 0;">Efekt? Możesz opisać sytuację własnymi słowami i otrzymać trafne wyniki — nawet jeśli orzeczenia używają zupełnie innej terminologii.</p>
</div>

<h3>Klikalne metadane i powiązania</h3>

<p>Każdy element na stronie orzeczenia jest interaktywny:</p>

<ul>
  <li><strong>Kliknij na zamawiającego</strong> — zobacz wszystkie jego sprawy przed KIO</li>
  <li><strong>Kliknij na przewodniczącego</strong> — znajdź inne orzeczenia tego sędziego</li>
  <li><strong>Kliknij na przepis</strong> — przejdź bezpośrednio do tekstu ustawy Pzp</li>
  <li><strong>Kliknij na zagadnienie merytoryczne</strong> — znajdź podobne sprawy</li>
</ul>

<p>Żadna inna platforma nie oferuje takiego poziomu interaktywności i nawigacji między powiązanymi treściami.</p>

<h3>Integracja z ustawą Pzp</h3>

<p>Na Przetargowi.pl udostępniamy pełny tekst <a href="/ustawa-pzp">ustawy Prawo zamówień publicznych</a> z bezpośrednimi linkami do każdego artykułu. Gdy przeglądasz orzeczenie powołujące się na art. 226 — jedno kliknięcie przeniesie Cię do treści tego przepisu.</p>

<h2>Porównanie cen — ile naprawdę oszczędzasz?</h2>

<table style="width: 100%; border-collapse: collapse; margin: 24px 0;">
  <tr style="background: #1a1a2e; color: #d4af37;">
    <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: left;">Platforma</th>
    <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: right;">Koszt miesięczny</th>
    <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: right;">Koszt roczny</th>
    <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: right;">Oszczędność</th>
  </tr>
  <tr style="background: rgba(46, 125, 50, 0.1);">
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>Przetargowi.pl</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right; font-weight: bold; color: #2e7d32;">29 zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right; font-weight: bold; color: #2e7d32;">348 zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right; font-weight: bold; color: #2e7d32;">—</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">LEX Zamówienia Publiczne</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">142 zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">1 704 zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right; color: #c62828;">+1 356 zł</td>
  </tr>
  <tr style="background: #f9f9f9;">
    <td style="padding: 12px; border: 1px solid #ddd;">SzuKIO.pl</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">132 zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">1 584 zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right; color: #c62828;">+1 236 zł</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Legalis</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">200+ zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">2 400+ zł</td>
    <td style="padding: 12px; border: 1px solid #ddd; text-align: right; color: #c62828;">+2 000+ zł</td>
  </tr>
</table>

<p>Wybierając <strong>Przetargowi.pl</strong>, oszczędzasz <strong>ponad 1 200 zł rocznie</strong> w porównaniu do konkurencji — i zyskujesz dostęp do wyszukiwania AI, którego żadna inna platforma nie oferuje.</p>

<h2>Kiedy wybrać którą platformę?</h2>

<h3>Wybierz Przetargowi.pl, jeśli:</h3>

<ul>
  <li>Potrzebujesz <strong>szybko znaleźć precedensy</strong> do konkretnej sytuacji</li>
  <li>Chcesz <strong>opisać problem własnymi słowami</strong> i otrzymać trafne wyniki</li>
  <li>Cenisz <strong>nowoczesny interfejs</strong> i efektywną nawigację</li>
  <li>Szukasz <strong>najlepszego stosunku jakości do ceny</strong></li>
  <li>Nie chcesz wiązać się długoterminową umową</li>
</ul>

<h3>Wybierz LEX lub Legalis, jeśli:</h3>

<ul>
  <li>Potrzebujesz dostępu do <strong>komentarzy prawnych i monografii</strong></li>
  <li>Twoja firma ma <strong>duży budżet</strong> na narzędzia prawne</li>
  <li>Potrzebujesz <strong>wsparcia ekspertów</strong> (poradnia prawna)</li>
  <li>Pracujesz w obszarach <strong>poza zamówieniami publicznymi</strong></li>
</ul>

<h3>Wybierz SzuKIO.pl, jeśli:</h3>

<ul>
  <li>Potrzebujesz dostępu do <strong>orzeczeń wielu organów</strong> (SO, SN, TSUE, NSA)</li>
  <li>Masz <strong>duży budżet</strong> (1 584 zł/rok)</li>
  <li>Akceptujesz <strong>limit odsłon dokumentów</strong></li>
</ul>

<h3>Wybierz darmową wyszukiwarkę UZP, jeśli:</h3>

<ul>
  <li>Potrzebujesz <strong>sporadycznego dostępu</strong> do pojedynczych orzeczeń</li>
  <li>Znasz <strong>dokładną sygnaturę</strong> szukanego orzeczenia</li>
  <li>Nie zależy Ci na <strong>zaawansowanych funkcjach</strong> wyszukiwania</li>
</ul>

<h2>Wypróbuj za darmo</h2>

<p>Nie musisz nam wierzyć na słowo. <strong>Przetargowi.pl</strong> oferuje darmowy dostęp do wyszukiwarki — możesz wykonać 3 wyszukiwania (zarówno słowami kluczowymi, jak i semantycznie) bez zakładania konta i bez podawania karty.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 24px; margin: 24px 0; text-align: center;">
  <h3 style="color: #d4af37; margin-top: 0;">Przekonaj się sam</h3>
  <p style="color: #e0e0e0; margin-bottom: 16px;">Wypróbuj wyszukiwanie semantyczne AI i zobacz różnicę.</p>
  <p style="margin-bottom: 16px;">
    <a href="/szukaj" style="display: inline-block; background: linear-gradient(135deg, #d4af37 0%, #c9a227 100%); color: #1a1a2e; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: bold; font-size: 16px;">Wypróbuj wyszukiwarkę AI →</a>
  </p>
  <p style="color: #888; margin-bottom: 0; font-size: 14px;">Bez rejestracji • 3 darmowe wyszukiwania • Pełna funkcjonalność</p>
</div>

<h2>Subskrypcja Premium — co zyskujesz?</h2>

<p>Za <strong>29 zł miesięcznie</strong> (plan „Wyszukiwarka") otrzymujesz:</p>

<ul>
  <li><strong>Nielimitowane wyszukiwania</strong> — zarówno słowami kluczowymi, jak i semantycznie</li>
  <li><strong>Brak limitów odsłon</strong> — przeglądaj dokumenty bez ograniczeń (w przeciwieństwie do SzuKIO z limitem 500 odsłon)</li>
  <li><strong>Pełny dostęp do bazy 33 000+ orzeczeń</strong> z uzasadnieniami</li>
  <li><strong>Wszystkie filtry i funkcje</strong> nawigacji</li>
  <li><strong>Bezpośrednie linki do ustawy Pzp</strong></li>
  <li><strong>Brak długoterminowych zobowiązań</strong> — możesz anulować w każdej chwili</li>
</ul>

<p>Możesz również wybrać plan <strong>„Razem" za 49 zł/miesiąc</strong>, który dodatkowo zawiera <strong>powiadomienia o nowych orzeczeniach</strong> — nigdy nie przegapisz istotnego wyroku w interesującym Cię obszarze.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">Pakiet „Razem" — najlepsza wartość</h4>
  <p style="color: #e0e0e0; margin-bottom: 12px;">Za <strong>49 zł/miesiąc</strong> otrzymujesz:</p>
  <ul style="color: #e0e0e0; margin-bottom: 12px;">
    <li>Nielimitowane wyszukiwania AI i słowami kluczowymi</li>
    <li>Powiadomienia o nowych orzeczeniach w wybranych kategoriach</li>
    <li>Alerty o orzeczeniach dotyczących konkretnych zamawiających</li>
  </ul>
  <p style="color: #e0e0e0; margin-bottom: 0;"><a href="/subskrypcja" style="color: #d4af37; font-weight: bold;">→ Zobacz plany subskrypcji</a></p>
</div>

<h2>Podsumowanie</h2>

<p>Na polskim rynku wyszukiwarek orzeczeń KIO <strong>Przetargowi.pl</strong> wyróżnia się jako jedyna platforma oferująca:</p>

<ul>
  <li><strong>Wyszukiwanie semantyczne AI</strong> — znajdź orzeczenia opisując sytuację własnymi słowami</li>
  <li><strong>Najlepszą cenę</strong> — 29 zł/miesiąc (4-5x taniej niż konkurencja)</li>
  <li><strong>Brak limitów odsłon</strong> — przeglądaj ile chcesz, bez dodatkowych opłat</li>
  <li><strong>Interaktywne metadane</strong> — każdy element prowadzi do powiązanych treści</li>
  <li><strong>Integrację z ustawą Pzp</strong> — bezpośrednie linki do przepisów</li>
</ul>

<p>Jeśli Twoja praca wymaga regularnego korzystania z orzecznictwa KIO — nie ma lepszego narzędzia. Wypróbuj za darmo i przekonaj się, ile czasu możesz zaoszczędzić.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 24px; margin: 24px 0; text-align: center;">
  <p style="color: #e0e0e0; margin-bottom: 16px; font-size: 18px;"><strong>Gotowy, żeby pracować mądrzej?</strong></p>
  <p style="margin-bottom: 0;">
    <a href="/szukaj" style="display: inline-block; background: linear-gradient(135deg, #d4af37 0%, #c9a227 100%); color: #1a1a2e; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: bold; font-size: 16px;">Rozpocznij wyszukiwanie →</a>
  </p>
</div>
"""

  def up do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    escaped_content = String.replace(@content, "'", "''")

    execute("""
    INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
    VALUES (
      'Porównanie wyszukiwarek orzeczeń KIO — dlaczego AI wygrywa z tradycyjnym wyszukiwaniem',
      'porownanie-wyszukiwarek-orzeczen-kio-ai',
      'Porównujemy popularne wyszukiwarki orzeczeń KIO: UZP, SzuKIO, LEX, Legalis i Przetargowi.pl. Sprawdź, która platforma oferuje najlepszy stosunek jakości do ceny i dlaczego wyszukiwanie semantyczne AI zmienia zasady gry.',
      'Porównanie wyszukiwarek orzeczeń KIO w Polsce. UZP, SzuKIO, LEX, Legalis vs Przetargowi.pl. Wyszukiwanie semantyczne AI, ceny, funkcje. Która platforma jest najlepsza?',
      'wyszukiwarka orzeczeń KIO, porównanie LEX Legalis, wyszukiwanie semantyczne AI, orzecznictwo KIO, baza orzeczeń, Przetargowi.pl, SzuKIO, UZP, zamówienia publiczne',
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
      "DELETE FROM articles WHERE slug = 'porownanie-wyszukiwarek-orzeczen-kio-ai'"
    )
  end
end
