defmodule Przetargowi.Repo.Migrations.InsertBlogArticleTenderMistakes do
  use Ecto.Migration

  @content """
  <h2>Wprowadzenie — skala problemu</h2>

  <p>Każdego roku tysiące ofert przetargowych zostaje odrzuconych z powodu uchybień, których można było uniknąć. Analiza <strong>1800 orzeczeń Krajowej Izby Odwoławczej</strong> dotyczących odrzucenia ofert pokazuje, że większość problemów nie wynika z braku wiedzy prawniczej, ale z pośpiechu, niedostatecznej organizacji pracy i powierzchownej analizy dokumentacji przetargowej.</p>

  <p>W niniejszym artykule przedstawiamy kompletny przewodnik po najczęściej spotykanych uchybieniach w ofertach przetargowych — z konkretnymi przykładami z orzecznictwa KIO, analizą liczbową oraz praktycznymi wskazówkami, jak się przed nimi zabezpieczyć.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <p style="margin: 0;"><span style="color: #d4af37;"><strong>📊 Dane z orzecznictwa:</strong></span> W bazie <a href="/orzecznictwo-kio" style="color: #d4af37;">Przetargowi.pl</a> znajduje się ponad <strong style="color: #d4af37;">1800 orzeczeń KIO</strong> dotyczących odrzucenia ofert. Każde z nich zawiera szczegółowe uzasadnienie — możesz je przeszukać, aby znaleźć precedensy do swojej sytuacji.</p>
  </div>

  <h2>1. Uchybienia formalne i dokumentacyjne</h2>

  <h3>1.1. Nieprawidłowości w podpisie elektronicznym</h3>

  <p>To jedna z najczęstszych przyczyn odrzucenia ofert w dobie elektronicznych zamówień publicznych. Typowe uchybienia obejmują:</p>

  <ul>
    <li><strong>Niewłaściwy format podpisu</strong> — użycie PAdES zamiast wymaganego XAdES lub odwrotnie. Zamawiający określa wymagany format w SWZ.</li>
    <li><strong>Wygasły certyfikat</strong> — podpis był ważny w momencie złożenia, ale certyfikat wygasł przed jego weryfikacją, co może powodować problemy interpretacyjne po stronie zamawiającego.</li>
    <li><strong>Profil zaufany zamiast podpisu kwalifikowanego</strong> — w postępowaniach o wartości powyżej progów unijnych wymagany jest wyłącznie kwalifikowany podpis elektroniczny.</li>
    <li><strong>Podpis osoby bez umocowania</strong> — osoba podpisująca nie figuruje w KRS jako uprawniona do reprezentacji ani nie posiada stosownego pełnomocnictwa.</li>
  </ul>

  <p><strong>Jak się zabezpieczyć:</strong></p>
  <ul>
    <li>Przed każdym postępowaniem zweryfikuj w SWZ wymagany format podpisu</li>
    <li>Sprawdź datę ważności certyfikatu kwalifikowanego</li>
    <li>Upewnij się, że osoba podpisująca posiada aktualne i skuteczne umocowanie</li>
    <li>Przeprowadź test podpisu na platformie e-Zamówienia z wyprzedzeniem</li>
  </ul>

  <h3>1.2. Problemy z reprezentacją i pełnomocnictwem</h3>

  <p>Częstym uchybieniem jest podpisanie oferty przez jednego członka zarządu, gdy z KRS wynika reprezentacja łączna (np. „dwóch członków zarządu działających łącznie").</p>

  <p><strong>Typowe problemy:</strong></p>
  <ul>
    <li><strong>Brak pełnomocnictwa</strong> — osoba podpisuje ofertę bez formalnego upoważnienia do reprezentowania wykonawcy w postępowaniu</li>
    <li><strong>Pełnomocnictwo w niewłaściwej formie</strong> — skan zwykłego pełnomocnictwa zamiast dokumentu opatrzonego kwalifikowanym podpisem elektronicznym</li>
    <li><strong>Nieaktualne pełnomocnictwo</strong> — dokument wystawiony przed zmianami w składzie zarządu</li>
    <li><strong>Pełnomocnictwo o zbyt wąskim zakresie</strong> — bez wyraźnego upoważnienia do podpisania oferty lub reprezentowania wykonawcy w postępowaniu o udzielenie zamówienia</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">⚖️ Przykład z orzecznictwa KIO</h4>
    <p style="margin-bottom: 0;">W sprawie <strong style="color: #d4af37;">KIO 811/23</strong> oferta została odrzucona, ponieważ pełnomocnictwo załączone do oferty było podpisane przez osobę, która w momencie składania oferty nie pełniła już funkcji członka zarządu. Izba potwierdziła stanowisko zamawiającego, że oferta nie została skutecznie złożona. <a href="/orzeczenie/kio-811-23" style="color: #d4af37;">Przeczytaj pełne orzeczenie →</a></p>
  </div>

  <h3>1.3. Braki w dokumentacji</h3>

  <p>Każdy brakujący załącznik może skutkować wezwaniem do uzupełnienia lub — w przypadku dokumentów niepodlegających uzupełnieniu — bezwzględnym odrzuceniem oferty.</p>

  <p><strong>Najczęściej pomijane dokumenty:</strong></p>
  <ul>
    <li>Oświadczenie JEDZ (Jednolity Europejski Dokument Zamówienia)</li>
    <li>Oświadczenie o przynależności lub braku przynależności do grupy kapitałowej</li>
    <li>Wykaz osób skierowanych do realizacji zamówienia</li>
    <li>Referencje lub inne dokumenty potwierdzające należyte wykonanie zamówień</li>
    <li>Kosztorys ofertowy lub formularz asortymentowo-cenowy</li>
    <li>Karty katalogowe oferowanych produktów</li>
  </ul>

  <p><strong>Jak się zabezpieczyć:</strong> Opracuj wewnętrzną checklistę dla każdego postępowania. Przed wysłaniem oferty przejdź przez SWZ punkt po punkcie i potwierdź kompletność każdego wymaganego dokumentu.</p>

  <h2>2. Uchybienia w kalkulacji ceny</h2>

  <h3>2.1. Nieprawidłowa stawka VAT</h3>

  <p>Zastosowanie niewłaściwej stawki podatku VAT stanowi <strong>błąd w obliczeniu ceny</strong>, który skutkuje odrzuceniem oferty na podstawie art. 226 ust. 1 pkt 10 ustawy Pzp. Co istotne, nieprawidłowość ta co do zasady nie podlega poprawie jako oczywista omyłka rachunkowa.</p>

  <p><strong>Najczęstsze pomyłki:</strong></p>
  <ul>
    <li>Zastosowanie stawki podstawowej 23% dla usług objętych stawką obniżoną (8% lub 5%)</li>
    <li>Zastosowanie stawki krajowej dla usług podlegających mechanizmowi odwrotnego obciążenia</li>
    <li>Błędna kwalifikacja robót budowlanych w kontekście budownictwa mieszkaniowego</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">💰 Przykład liczbowy</h4>
    <p>Wykonawca A złożył ofertę na usługi budowlane w budynku mieszkalnym na kwotę <strong>1 230 000 zł brutto</strong> (1 000 000 netto + 23% VAT). Wykonawca B złożył ofertę na <strong>1 080 000 zł brutto</strong> (1 000 000 netto + 8% VAT). Oferta wykonawcy A została odrzucona z powodu błędnej stawki VAT — mimo identycznej ceny netto, przegrał postępowanie.</p>
    <p style="margin-bottom: 0;"><strong>Wniosek:</strong> Przed złożeniem oferty zweryfikuj właściwą stawkę VAT. W razie wątpliwości wystąp o indywidualną interpretację podatkową lub skonsultuj się z doradcą podatkowym.</p>
  </div>

  <h3>2.2. Niespójności rachunkowe</h3>

  <p>Zamawiający może poprawić oczywiste omyłki rachunkowe, jednak wyłącznie w sytuacji gdy sposób obliczenia jest jednoznaczny. Problemy powstają, gdy:</p>

  <ul>
    <li><strong>Suma pozycji nie odpowiada cenie końcowej</strong> — i nie sposób ustalić, która wartość jest prawidłowa</li>
    <li><strong>Różne ceny w różnych częściach oferty</strong> — rozbieżność między formularzem ofertowym a kosztorysem</li>
    <li><strong>Pominięte pozycje kosztorysu</strong> — brak wyceny niektórych elementów z przedmiaru</li>
    <li><strong>Ceny jednostkowe „0 zł"</strong> — bez wyraźnego wskazania, że pozycja została wkalkulowana w inne elementy</li>
  </ul>

  <h3>2.3. Rażąco niska cena</h3>

  <p>Gdy cena oferty jest znacząco niższa od szacunków zamawiającego lub średniej pozostałych ofert, wykonawca zostaje wezwany do złożenia wyjaśnień. Brak przekonującego uzasadnienia skutkuje odrzuceniem oferty na podstawie art. 226 ust. 1 pkt 8 ustawy Pzp.</p>

  <p><strong>Najczęstsze uchybienia w wyjaśnieniach:</strong></p>
  <ul>
    <li><strong>Ogólnikowe deklaracje</strong> — „posiadamy niskie koszty stałe" bez jakichkolwiek dowodów</li>
    <li><strong>Brak szczegółowego rozbicia ceny</strong> — nieprzedstawienie struktury kosztów</li>
    <li><strong>Powoływanie się na hipotetyczne rabaty</strong> — „możemy uzyskać rabat od dostawcy" bez potwierdzenia</li>
    <li><strong>Niespójność wyjaśnień z treścią oferty</strong> — inne wartości w wyjaśnieniach niż w formularzu ofertowym</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">💰 Przykład liczbowy — skuteczne wyjaśnienia</h4>
    <p>Szacunek zamawiającego: <strong>500 000 zł</strong>. Średnia ofert: <strong>480 000 zł</strong>. Twoja oferta: <strong>380 000 zł</strong> (21% poniżej średniej).</p>
    <p><strong>Skuteczne wyjaśnienie powinno zawierać:</strong></p>
    <ul>
      <li>Robocizna: 180 000 zł (3 pracowników × 6 miesięcy × średnia 10 000 zł/mies.)</li>
      <li>Materiały: 120 000 zł (załącznik: oferty od 2 dostawców)</li>
      <li>Sprzęt własny: 30 000 zł (amortyzacja posiadanego sprzętu)</li>
      <li>Koszty pośrednie: 25 000 zł (8% kosztów bezpośrednich)</li>
      <li>Zysk: 25 000 zł (7,5% — akceptowalny poziom dla utrzymania relacji z zamawiającym)</li>
    </ul>
    <p style="margin-bottom: 0;"><strong>Razem: 380 000 zł</strong> — kalkulacja jest przejrzysta i weryfikowalna.</p>
  </div>

  <h2>3. Niezgodność z warunkami zamówienia</h2>

  <h3>3.1. Niespełnienie wymagań technicznych</h3>

  <p>Oferowany produkt lub usługa musi spełniać <strong>wszystkie wymagania określone w SWZ lub Opisie Przedmiotu Zamówienia (OPZ)</strong>. Nawet pozornie drobna niezgodność może skutkować odrzuceniem oferty.</p>

  <p><strong>Typowe uchybienia:</strong></p>
  <ul>
    <li>Oferowanie produktu o parametrach „zbliżonych" lub „porównywalnych" zamiast zgodnych z wymaganiami</li>
    <li>Brak certyfikatu, atestu lub deklaracji zgodności wymaganych w SWZ</li>
    <li>Proponowanie rozwiązania równoważnego bez wykazania równoważności zgodnie z wymogami zamawiającego</li>
    <li>Niezgodność z wymaganiami dotyczącymi gwarancji lub serwisu</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">⚖️ Przykład z orzecznictwa</h4>
    <p style="margin-bottom: 0;">W sprawie <strong>KIO 668/23</strong> oferta została odrzucona z powodu niezgodności z warunkami zamówienia. Wykonawca zaoferował urządzenie o parametrach przewyższających wymagania SWZ, argumentując że produkt jest „lepszy". Izba potwierdziła stanowisko zamawiającego — nawet korzystniejsze parametry nie usprawiedliwiają niezgodności z opisem przedmiotu zamówienia. Zamawiający ma prawo oczekiwać dokładnie tego, co określił w dokumentacji. <a href="/orzeczenie/kio-668-23" style="color: #d4af37;">Przeczytaj pełne orzeczenie →</a></p>
  </div>

  <h3>3.2. Nieprawidłowa interpretacja kryteriów oceny</h3>

  <p>Wykonawcy często mylą <strong>warunki udziału w postępowaniu</strong> (wymogi bezwzględne — spełnia/nie spełnia) z <strong>kryteriami oceny ofert</strong> (elementy punktowane — więcej = więcej punktów).</p>

  <p><strong>Najczęstsze uchybienia:</strong></p>
  <ul>
    <li>Zadeklarowanie maksymalnego okresu gwarancji bez wkalkulowania kosztów obsługi serwisowej</li>
    <li>Deklaracja ekstremalnie krótkiego terminu realizacji bez zabezpieczenia odpowiednich zasobów</li>
    <li>Błędne zrozumienie wzoru punktacji — np. im więcej dni na dostawę, tym mniej punktów</li>
    <li>Ignorowanie kryteriów pozacenowych przy wyłącznym skupieniu na najniższej cenie</li>
  </ul>

  <h2>4. Uchybienia proceduralne</h2>

  <h3>4.1. Złożenie oferty po upływie terminu</h3>

  <p>W postępowaniach elektronicznych decydujący jest moment <strong>prawidłowego przesłania</strong> pliku oferty do systemu, nie moment rozpoczęcia wysyłki. Najczęstsze przyczyny przekroczenia terminu:</p>

  <ul>
    <li><strong>Problemy z logowaniem</strong> do platformy e-Zamówienia</li>
    <li><strong>Przekroczenie limitu rozmiaru plików</strong> określonego przez zamawiającego</li>
    <li><strong>Awaria techniczna</strong> — przerwa w działaniu internetu lub systemu</li>
    <li><strong>Rozpoczęcie wysyłki zbyt późno</strong> — przesyłanie dużych plików może trwać kilkanaście minut</li>
  </ul>

  <p><strong>Jak się zabezpieczyć:</strong></p>
  <ul>
    <li>Zaloguj się na platformę minimum dzień przed upływem terminu</li>
    <li>Prześlij ofertę co najmniej 1-2 godziny przed terminem składania ofert</li>
    <li>Przygotuj zapasowe łącze internetowe (np. hotspot z telefonu)</li>
    <li>Skompresuj pliki graficzne, jeśli zbliżają się do limitu rozmiaru</li>
  </ul>

  <h3>4.2. Nieodbycie obowiązkowej wizji lokalnej</h3>

  <p>Jeżeli SWZ przewiduje obowiązek odbycia wizji lokalnej, jej nieodbycie stanowi <strong>bezwzględną przesłankę odrzucenia oferty</strong> na podstawie art. 226 ust. 1 pkt 18 ustawy Pzp. Nie ma możliwości uzupełnienia tego braku po upływie terminu.</p>

  <h3>4.3. Nieprawidłowości dotyczące wadium</h3>

  <p><strong>Najczęstsze uchybienia:</strong></p>
  <ul>
    <li>Wniesienie wadium po upływie terminu składania ofert</li>
    <li>Wadium w formie niedopuszczonej przez zamawiającego</li>
    <li>Wskazanie błędnego beneficjenta w gwarancji wadialnej</li>
    <li>Gwarancja wadialna zawierająca ograniczenia lub wyłączenia odpowiedzialności gwaranta</li>
    <li>Wadium w kwocie niższej niż wymagana przez zamawiającego</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">💰 Przykład liczbowy — wadium</h4>
    <p style="margin-bottom: 0;">Wartość zamówienia: <strong>2 000 000 zł</strong>. Wymagane wadium: <strong>20 000 zł</strong> (1%). Wykonawca wniósł wadium w kwocie <strong>19 500 zł</strong> — różnica 500 zł (2,5%) spowodowała odrzucenie oferty. Koszt wadium: ~200 zł/rok za gwarancję ubezpieczeniową. <strong>Oszczędność 200 zł = utrata kontraktu za 2 mln zł.</strong></p>
  </div>

  <h2>5. Uchybienia strategiczne</h2>

  <h3>5.1. Powierzchowna analiza dokumentacji</h3>

  <p>Typowe uchybienie: analiza wyłącznie ogłoszenia o zamówieniu i formularza ofertowego. Tymczasem kluczowe wymagania są często zawarte w:</p>

  <ul>
    <li><strong>Załącznikach do SWZ</strong> — szczegółowe specyfikacje techniczne, przedmiary</li>
    <li><strong>Wzorze umowy</strong> — kary umowne, terminy pośrednie, obowiązki raportowania</li>
    <li><strong>Odpowiedziach na pytania wykonawców</strong> — modyfikacje pierwotnych wymagań</li>
    <li><strong>Opisie przedmiotu zamówienia</strong> — szczegóły techniczne i funkcjonalne</li>
  </ul>

  <p><strong>Jak się zabezpieczyć:</strong> Pobierz komplet dokumentacji postępowania i przeanalizuj ją systematycznie. Sporządź notatki z kluczowych wymagań, terminów i ryzyk.</p>

  <h3>5.2. Składanie ofert mimo niespełnienia warunków</h3>

  <p>Niektórzy wykonawcy składają oferty „na próbę", licząc na pozytywną ocenę mimo braków formalnych lub merytorycznych. To nieefektywne wykorzystanie zasobów — zarówno czasu, jak i środków finansowych.</p>

  <p><strong>Przed złożeniem oferty zweryfikuj:</strong></p>
  <ul>
    <li>Czy posiadasz wymagane doświadczenie (zrealizowane zamówienia o określonej wartości/charakterze)?</li>
    <li>Czy dysponujesz osobami z wymaganymi uprawnieniami i kwalifikacjami?</li>
    <li>Czy spełniasz warunki dotyczące sytuacji finansowej (wymagany poziom obrotów, zdolność kredytowa)?</li>
    <li>Czy możesz przedstawić wymagane referencje lub inne dokumenty potwierdzające?</li>
  </ul>

  <h3>5.3. Nieprawidłowości w ramach konsorcjum</h3>

  <p>Wspólne ubieganie się o zamówienie wymaga precyzyjnych ustaleń formalnoprawnych:</p>

  <ul>
    <li><strong>Brak umowy konsorcjum</strong> lub umowa o niejednoznacznych postanowieniach</li>
    <li><strong>Brak pełnomocnictwa dla lidera</strong> do reprezentowania konsorcjum w postępowaniu</li>
    <li><strong>Nieprawidłowy podział zadań</strong> — każdy konsorcjant powinien realizować część zamówienia odpowiadającą jego kwalifikacjom wskazanym na etapie weryfikacji warunków</li>
    <li><strong>Brak pisemnego zobowiązania podmiotu trzeciego</strong> udostępniającego zasoby</li>
  </ul>

  <h2>6. Praktyczna checklista wykonawcy</h2>

  <h3>Przed przystąpieniem do postępowania</h3>
  <ul>
    <li>☐ Przeanalizuj komplet dokumentacji (SWZ, OPZ, wzór umowy, wszystkie załączniki)</li>
    <li>☐ Sprawdź odpowiedzi na pytania wykonawców i ewentualne modyfikacje SWZ</li>
    <li>☐ Zweryfikuj, czy spełniasz wszystkie warunki udziału w postępowaniu</li>
    <li>☐ Oszacuj realne koszty realizacji zamówienia z uwzględnieniem ryzyk</li>
    <li>☐ Sprawdź kluczowe terminy (składanie ofert, realizacja, gwarancja)</li>
    <li>☐ Zidentyfikuj wymagane certyfikaty, atesty i dokumenty produktowe</li>
  </ul>

  <h3>Przygotowanie oferty</h3>
  <ul>
    <li>☐ Użyj aktualnych wzorów formularzy pobranych z dokumentacji postępowania</li>
    <li>☐ Sprawdź sposób reprezentacji firmy w aktualnym odpisie z KRS</li>
    <li>☐ Przygotuj pełnomocnictwa w wymaganej formie (podpis kwalifikowany)</li>
    <li>☐ Zweryfikuj właściwą stawkę VAT dla przedmiotu zamówienia</li>
    <li>☐ Sprawdź zgodność sum częściowych z ceną końcową</li>
    <li>☐ Skompletuj wszystkie wymagane załączniki zgodnie z SWZ</li>
  </ul>

  <h3>Przed wysłaniem oferty</h3>
  <ul>
    <li>☐ Zweryfikuj format i ważność podpisu elektronicznego</li>
    <li>☐ Sprawdź rozmiar plików (zgodność z limitami platformy)</li>
    <li>☐ Zaloguj się na platformę e-Zamówienia z odpowiednim wyprzedzeniem</li>
    <li>☐ Prześlij ofertę minimum 1-2 godziny przed upływem terminu</li>
    <li>☐ Zachowaj potwierdzenie prawidłowego złożenia oferty (UPO)</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">✅ Zapisz tę checklistę</h4>
    <p style="margin-bottom: 0;">Korzystaj z powyższej checklisty przy każdym postępowaniu. Możesz ją skopiować lub dodać stronę do zakładek. Systematyczne podejście eliminuje większość uchybień formalnych i znacząco zwiększa szanse na pozytywną ocenę oferty.</p>
  </div>

  <h2>7. Procedura po odrzuceniu oferty</h2>

  <h3>7.1. Analiza uzasadnienia</h3>
  <p>Zamawiający ma obowiązek przedstawić wykonawcy pisemne uzasadnienie odrzucenia zawierające podstawę prawną oraz uzasadnienie faktyczne. Przeanalizuj je pod kątem:</p>
  <ul>
    <li>Czy zamawiający prawidłowo zinterpretował treść Twojej oferty?</li>
    <li>Czy wskazana podstawa prawna jest adekwatna do stanu faktycznego?</li>
    <li>Czy w procesie oceny nie popełniono błędu?</li>
  </ul>

  <h3>7.2. Odwołanie do Krajowej Izby Odwoławczej</h3>
  <p>Wykonawcy, którego oferta została odrzucona, przysługuje prawo wniesienia odwołania do Krajowej Izby Odwoławczej. Należy pamiętać o krótkich terminach:</p>
  <ul>
    <li><strong>10 dni</strong> — w postępowaniach o wartości równej lub przekraczającej progi unijne</li>
    <li><strong>5 dni</strong> — w postępowaniach o wartości poniżej progów unijnych</li>
  </ul>

  <p>Terminy liczone są od dnia przekazania informacji o odrzuceniu oferty.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">🔍 Znajdź precedensy do swojej sprawy</h4>
    <p style="margin-bottom: 12px;">Przed wniesieniem odwołania przeanalizuj orzecznictwo KIO w podobnych sprawach. W <a href="/orzecznictwo-kio" style="color: #d4af37;">bazie Przetargowi.pl</a> znajdziesz ponad <strong>1800 orzeczeń</strong> dotyczących odrzucenia ofert z możliwością wyszukiwania semantycznego:</p>
    <ul style="margin-bottom: 12px;">
      <li><a href="/szukaj?q=rażąco+niska+cena+wyjaśnienia" style="color: #d4af37;">„rażąco niska cena wyjaśnienia"</a> — 287 orzeczeń</li>
      <li><a href="/szukaj?q=błąd+w+obliczeniu+ceny+VAT" style="color: #d4af37;">„błąd w obliczeniu ceny VAT"</a> — 143 orzeczenia</li>
      <li><a href="/szukaj?q=niezgodność+z+treścią+SWZ" style="color: #d4af37;">„niezgodność z treścią SWZ"</a> — 412 orzeczeń</li>
      <li><a href="/szukaj?q=wadium+gwarancja+bankowa" style="color: #d4af37;">„wadium gwarancja bankowa"</a> — 89 orzeczeń</li>
    </ul>
    <p style="margin-bottom: 0;"><a href="/orzecznictwo-kio" style="color: #d4af37; font-weight: bold;">→ Przeszukaj bazę orzeczeń KIO</a></p>
  </div>

  <h3>7.3. Wnioski na przyszłość</h3>
  <p>Każde odrzucenie oferty stanowi cenne źródło wiedzy. Warto udokumentować:</p>
  <ul>
    <li>Jakie uchybienie wystąpiło?</li>
    <li>Jakie działania mogły zapobiec temu uchybieniu?</li>
    <li>Jakie procedury wewnętrzne należy wdrożyć lub usprawnić?</li>
  </ul>

  <h2>Podsumowanie</h2>

  <p>Większość uchybień w ofertach przetargowych wynika z trzech głównych przyczyn:</p>

  <ol>
    <li><strong>Presja czasowa</strong> — składanie oferty w ostatniej chwili bez możliwości dokładnej weryfikacji</li>
    <li><strong>Powierzchowna analiza dokumentacji</strong> — ograniczenie się do ogłoszenia i formularza ofertowego</li>
    <li><strong>Brak wewnętrznych procedur kontrolnych</strong> — checklisty, weryfikacji krzyżowej, drugiej pary oczu</li>
  </ol>

  <p><strong>Kluczowe zasady minimalizacji ryzyka:</strong></p>
  <ul>
    <li>Zarezerwuj odpowiednią ilość czasu na przygotowanie oferty</li>
    <li>Przeanalizuj komplet dokumentacji, włącznie z odpowiedziami na pytania wykonawców</li>
    <li>Opracuj i stosuj checklistę weryfikacyjną dla każdego postępowania</li>
    <li>Złóż ofertę z wyprzedzeniem — unikaj ryzyka problemów technicznych</li>
    <li>Analizuj przyczyny odrzuceń i systematycznie usprawniaj procesy wewnętrzne</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">🚀 Zwiększ skuteczność w przetargach</h4>
    <p style="margin-bottom: 12px;">Platforma <strong>Przetargowi.pl</strong> wspiera wykonawców na każdym etapie:</p>
    <ul style="margin-bottom: 12px;">
      <li><a href="/przetargi" style="color: #d4af37;"><strong>Wyszukiwarka przetargów</strong></a> — aktualne ogłoszenia z BZP i TED z filtrami branżowymi</li>
      <li><a href="/orzecznictwo-kio" style="color: #d4af37;"><strong>Baza orzeczeń KIO</strong></a> — ponad 50 000 wyroków z wyszukiwaniem semantycznym AI</li>
      <li><a href="/raporty" style="color: #d4af37;"><strong>Raporty rynkowe</strong></a> — statystyki, trendy cenowe i analizy branżowe</li>
    </ul>
    <p style="margin-bottom: 0;"><a href="/przetargi" style="color: #d4af37; font-weight: bold;">→ Rozpocznij korzystanie z platformy</a></p>
  </div>
  """

  def up do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    escaped_content = String.replace(@content, "'", "''")

    execute("""
    INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
    VALUES (
      'Najczęstsze błędy w ofertach przetargowych — kompletny przewodnik jak ich uniknąć [2026]',
      'najczestsze-bledy-oferty-przetargowe',
      'Analiza 1800 orzeczeń KIO: błędy formalne, kalkulacja ceny, niezgodność z SWZ. Praktyczna checklista, przykłady liczbowe i case study z orzecznictwa.',
      'Najczęstsze błędy w ofertach przetargowych 2026: podpis elektroniczny, wadium, rażąco niska cena, niezgodność z SWZ. Praktyczny przewodnik z przykładami liczbowymi i orzeczeniami KIO. Checklista wykonawcy.',
      'błędy przetargowe, odrzucenie oferty, rażąco niska cena, wadium, podpis elektroniczny, JEDZ, KIO odwołanie, art 226 PZP',
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
      "DELETE FROM articles WHERE slug = 'najczestsze-bledy-oferty-przetargowe'"
    )
  end
end
