defmodule Przetargowi.Repo.Migrations.InsertBlogArticleCateringSchoolsHospitals do
  use Ecto.Migration

  @content """
  <h2>Wprowadzenie — rynek cateringu dla instytucji publicznych</h2>

  <p>Catering dla szkół i szpitali to jeden z największych segmentów zamówień publicznych w Polsce. Według danych z <strong>Przetargowi.pl</strong>, w kategorii CPV 55 (usługi hotelarskie, restauracyjne i handlu detalicznego) publikowanych jest rocznie ponad <strong>500 przetargów</strong> na usługi gastronomiczne dla placówek oświatowych i medycznych.</p>

  <p>To stabilny rynek z przewidywalnym zapotrzebowaniem — szkoły potrzebują posiłków przez 10 miesięcy w roku, szpitale przez cały rok. Dla firm cateringowych oznacza to możliwość budowania długoterminowych kontraktów i stałych przychodów. Jednak wejście na ten rynek wymaga spełnienia szeregu wymogów sanitarnych, wdrożenia systemu HACCP oraz znajomości specyfiki zamówień publicznych.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">📊 Kluczowe kody CPV dla cateringu</h4>
    <ul style="margin-bottom: 0;">
      <li><strong>55.52.00.00-1</strong> — Usługi dostarczania posiłków</li>
      <li><strong>55.32.10.00-6</strong> — Usługi przygotowywania posiłków</li>
      <li><strong>55.32.00.00-9</strong> — Usługi podawania posiłków</li>
      <li><strong>55.32.20.00-3</strong> — Usługi gotowania posiłków</li>
      <li><strong>15.89.42.10-6</strong> — Posiłki szkolne</li>
    </ul>
  </div>

  <h2>1. Podstawy prawne — co musisz wiedzieć</h2>

  <p>Działalność cateringowa dla placówek publicznych podlega kilku aktom prawnym:</p>

  <ul>
    <li><strong>Rozporządzenie (WE) nr 852/2004</strong> Parlamentu Europejskiego i Rady w sprawie higieny środków spożywczych — podstawa systemu HACCP</li>
    <li><strong>Ustawa o bezpieczeństwie żywności i żywienia</strong> (Dz.U. 2006 Nr 171 poz. 1225 z późn. zm.) — krajowe przepisy sanitarne</li>
    <li><strong>Rozporządzenie Ministra Zdrowia z 26 lipca 2016 r.</strong> w sprawie grup środków spożywczych przeznaczonych do sprzedaży dzieciom w jednostkach systemu oświaty — wymogi żywieniowe dla szkół</li>
    <li><strong>Ustawa Prawo zamówień publicznych</strong> — procedury przetargowe</li>
  </ul>

  <p>Placówki takie jak szkoły i szpitale są traktowane jako <strong>zakłady żywienia zbiorowego zamkniętego</strong>. Oznacza to, że zarówno firma cateringowa, jak i sama placówka (jeśli posiada wydawalnię posiłków) muszą spełniać wymogi sanitarne i posiadać odpowiednie zgody Sanepidu.</p>

  <h2>2. Rejestracja działalności — pierwsze kroki</h2>

  <h3>Krok 1: Zgłoszenie do Sanepidu</h3>

  <p>Przed rozpoczęciem działalności musisz zgłosić się do <strong>Powiatowej Stacji Sanitarno-Epidemiologicznej</strong> właściwej dla lokalizacji Twojej kuchni. Sanepid przeprowadzi kontrolę lokalu i wyda opinię, czy spełnia on wymagania higieniczno-sanitarne.</p>

  <h3>Krok 2: Przygotowanie dokumentacji</h3>

  <p>Wymagana dokumentacja obejmuje:</p>

  <ul>
    <li><strong>Księgę HACCP</strong> — opis systemu kontroli bezpieczeństwa żywności</li>
    <li><strong>Dokumentację GHP/GMP</strong> — procedury Dobrej Praktyki Higienicznej i Produkcyjnej</li>
    <li><strong>Książeczki sanitarno-epidemiologiczne</strong> pracowników</li>
    <li><strong>Rejestr szkoleń</strong> personelu z zakresu higieny</li>
    <li><strong>Umowę na wywóz odpadów</strong> gastronomicznych</li>
    <li><strong>Umowę z firmą DDD</strong> (deratyzacja, dezynfekcja, dezynsekcja)</li>
  </ul>

  <h3>Krok 3: Odbiór pojazdu do transportu żywności</h3>

  <p>Jeśli planujesz dostarczać posiłki, Twój samochód również musi przejść odbiór Sanepidu. Pojazd musi mieć:</p>

  <ul>
    <li>Łatwe do czyszczenia powierzchnie (najlepiej stal nierdzewna lub tworzywo)</li>
    <li>Możliwość utrzymania odpowiedniej temperatury (termosy, bemary, lodówki)</li>
    <li>Zamykane pojemniki chroniące żywność przed zanieczyszczeniem</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">💡 Wskazówka praktyczna</h4>
    <p style="margin-bottom: 0;">Nie musisz kupować własnego samochodu — możesz podnająć pojazd z ważnym odbiorem sanitarnym od innej firmy. To dobry sposób na obniżenie kosztów wejścia na rynek.</p>
  </div>

  <h2>3. System HACCP — fundament bezpieczeństwa żywności</h2>

  <p><strong>HACCP</strong> (Hazard Analysis and Critical Control Points) to system kontroli bezpieczeństwa żywności, który jest <strong>obowiązkowy</strong> dla każdego przedsiębiorcy zajmującego się produkcją lub dystrybucją żywności. System pozwala identyfikować i eliminować zagrożenia biologiczne, chemiczne i fizyczne na każdym etapie procesu.</p>

  <h3>7 zasad HACCP</h3>

  <ol>
    <li><strong>Analiza zagrożeń</strong> — identyfikacja potencjalnych zagrożeń na każdym etapie produkcji</li>
    <li><strong>Określenie krytycznych punktów kontroli (CCP)</strong> — etapy, gdzie kontrola jest niezbędna</li>
    <li><strong>Ustalenie limitów krytycznych</strong> — np. minimalna temperatura gotowania</li>
    <li><strong>Monitorowanie CCP</strong> — regularne pomiary i obserwacje</li>
    <li><strong>Działania korygujące</strong> — procedury na wypadek przekroczenia limitów</li>
    <li><strong>Weryfikacja systemu</strong> — okresowe audyty i przeglądy</li>
    <li><strong>Dokumentacja</strong> — prowadzenie zapisów z monitoringu i działań korygujących</li>
  </ol>

  <h3>Krytyczne punkty kontroli w cateringu</h3>

  <p>Dla firmy cateringowej typowe CCP to:</p>

  <ul>
    <li><strong>Przyjęcie surowców</strong> — kontrola temperatury i jakości dostaw</li>
    <li><strong>Przechowywanie</strong> — monitoring temperatur w lodówkach i magazynach</li>
    <li><strong>Obróbka cieplna</strong> — temperatura w centrum produktu min. 75°C</li>
    <li><strong>Schładzanie</strong> — szybkie schłodzenie do temp. poniżej 4°C (jeśli dotyczy)</li>
    <li><strong>Wydawanie posiłków</strong> — temperatura dań ciepłych min. 63°C</li>
    <li><strong>Transport</strong> — utrzymanie łańcucha chłodniczego/cieplnego</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">🌡️ Wymagane temperatury posiłków</h4>
    <ul style="margin-bottom: 0;">
      <li><strong>Zupy</strong> — minimum 75°C w momencie wydania</li>
      <li><strong>Dania gorące</strong> — minimum 63°C w momencie wydania</li>
      <li><strong>Produkty chłodzone</strong> — maksimum 4°C</li>
      <li><strong>Produkty mrożone</strong> — maksimum -18°C</li>
    </ul>
  </div>

  <h2>4. Wymogi dotyczące pomieszczeń i infrastruktury</h2>

  <h3>Kuchnia produkcyjna</h3>

  <ul>
    <li><strong>Wysokość pomieszczeń produkcyjnych</strong> — minimum 3,3 m (możliwe odstępstwo przy niższej wysokości)</li>
    <li><strong>Wysokość pomieszczeń sanitarnych</strong> — minimum 2,5 m</li>
    <li><strong>Powierzchnie</strong> — łatwo zmywalne, nienasiąkliwe, bez uszkodzeń (ściany, podłogi, blaty)</li>
    <li><strong>Wentylacja</strong> — wydajna, z okapami nad stanowiskami obróbki cieplnej</li>
    <li><strong>Oświetlenie</strong> — wystarczające do pracy, osłonięte (zabezpieczenie przed odłamkami)</li>
  </ul>

  <h3>Strefy funkcjonalne</h3>

  <p>Kuchnia musi mieć wydzielone strefy, aby zapobiec krzyżowaniu się dróg „czystych" i „brudnych":</p>

  <ul>
    <li><strong>Strefa przyjęcia towaru</strong> — oddzielna od produkcji</li>
    <li><strong>Magazyny</strong> — suche, chłodnicze, mroźnicze</li>
    <li><strong>Strefa obróbki wstępnej</strong> — mycie, obieranie warzyw</li>
    <li><strong>Strefa obróbki cieplnej</strong> — gotowanie, smażenie, pieczenie</li>
    <li><strong>Strefa wydawania/pakowania</strong> — przygotowanie do transportu</li>
    <li><strong>Zmywalnia</strong> — osobne pomieszczenie na brudne naczynia</li>
    <li><strong>Pomieszczenie socjalne</strong> — szatnia i toaleta dla personelu</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">💡 Wskazówka praktyczna</h4>
    <p style="margin-bottom: 0;">Jeśli nie masz miejsca na osobną toaletę dla personelu, możesz podpisać umowę z pobliskim lokalem (sklep, restauracja) na korzystanie z ich sanitariatów. Takie rozwiązanie akceptuje Sanepid.</p>
  </div>

  <h2>5. Personel — wymagania i szkolenia</h2>

  <h3>Badania sanitarno-epidemiologiczne</h3>

  <p>Każdy pracownik mający kontakt z żywnością musi posiadać <strong>aktualne orzeczenie lekarskie</strong> (dawniej „książeczka sanepidowska") wydane przez lekarza medycyny pracy. Badania obejmują:</p>

  <ul>
    <li>Badanie ogólne</li>
    <li>Badanie na nosicielstwo pałeczek Salmonella i Shigella</li>
    <li>Badania okresowe (co 2-3 lata lub częściej w zależności od zaleceń)</li>
  </ul>

  <h3>Szkolenia</h3>

  <p>Personel musi regularnie uczestniczyć w szkoleniach z zakresu:</p>

  <ul>
    <li>Zasad GHP/GMP i systemu HACCP</li>
    <li>Higieny osobistej</li>
    <li>Bezpieczeństwa żywności</li>
    <li>Postępowania z alergenami</li>
  </ul>

  <p>Szkolenia należy dokumentować — Sanepid podczas kontroli sprawdza rejestr szkoleń.</p>

  <h3>Higiena personelu</h3>

  <ul>
    <li>Czysta odzież robocza (fartuch, czepek lub siatka na włosy)</li>
    <li>Zakaz noszenia biżuterii podczas pracy</li>
    <li>Regularne mycie i dezynfekcja rąk</li>
    <li>Zakaz pracy przy objawach chorobowych (biegunka, wymioty, choroby skóry)</li>
  </ul>

  <h2>6. Specyfika cateringu szkolnego</h2>

  <h3>Wymogi żywieniowe dla dzieci</h3>

  <p>Rozporządzenie Ministra Zdrowia z 2016 roku określa szczegółowe wymagania dla posiłków w placówkach oświatowych:</p>

  <ul>
    <li><strong>Ograniczenie soli</strong> — maksymalnie 5g dziennie</li>
    <li><strong>Ograniczenie cukrów</strong> — napoje i produkty z dodatkiem cukru ograniczone</li>
    <li><strong>Zakaz niektórych produktów</strong> — chipsy, słodycze, napoje gazowane</li>
    <li><strong>Wartości odżywcze</strong> — posiłki muszą pokrywać określony % dziennego zapotrzebowania</li>
  </ul>

  <h3>Wydawalnia posiłków w szkole</h3>

  <p>Jeśli szkoła nie ma własnej kuchni, a jedynie wydawalnię, również musi:</p>

  <ul>
    <li>Zgłosić działalność do Sanepidu</li>
    <li>Posiadać dokumentację GHP/GMP</li>
    <li>Zapewnić odpowiednie warunki do przechowywania i wydawania posiłków</li>
    <li>Prowadzić monitoring temperatur</li>
  </ul>

  <h3>Próbki żywnościowe</h3>

  <p>Obowiązek pobierania i przechowywania próbek żywnościowych przez <strong>72 godziny</strong> w temperaturze do 4°C. Próbki służą do ewentualnej kontroli w przypadku zatrucia pokarmowego.</p>

  <h2>7. Specyfika cateringu szpitalnego</h2>

  <p>Catering dla szpitali to bardziej wymagający segment rynku, ale też lepiej płatny. Wymaga dodatkowych kompetencji:</p>

  <h3>Diety lecznicze</h3>

  <p>Szpital wymaga przygotowania wielu rodzajów diet:</p>

  <ul>
    <li><strong>Dieta podstawowa</strong> — dla pacjentów bez ograniczeń</li>
    <li><strong>Dieta lekkostrawna</strong> — ograniczenie tłuszczów i błonnika</li>
    <li><strong>Dieta cukrzycowa</strong> — niski indeks glikemiczny</li>
    <li><strong>Dieta niskosodowa</strong> — dla pacjentów z nadciśnieniem</li>
    <li><strong>Dieta bezglutenowa</strong> — wymaga osobnej linii produkcyjnej</li>
    <li><strong>Dieta papkowata/płynna</strong> — dla pacjentów z problemami z połykaniem</li>
    <li><strong>Dieta eliminacyjna</strong> — wykluczenie alergenów</li>
    <li><strong>Dieta wegańska/wegetariańska</strong></li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">⚠️ Uwaga — dieta bezglutenowa</h4>
    <p style="margin-bottom: 0;">Dla diety bezglutenowej zaleca się <strong>osobną linię produkcyjną</strong> lub przynajmniej wydzielone stanowisko i sprzęt. Krzyżowe zanieczyszczenie glutenem może być niebezpieczne dla pacjentów z celiakią.</p>
  </div>

  <h3>Dodatkowe wymagania szpitalne</h3>

  <ul>
    <li><strong>Całodobowa dostępność</strong> — posiłki 3-5 razy dziennie, 7 dni w tygodniu</li>
    <li><strong>Elastyczność</strong> — możliwość szybkiej zmiany diety pacjenta</li>
    <li><strong>System tacowy</strong> — indywidualne tace dla każdego pacjenta z przypisaną dietą</li>
    <li><strong>Współpraca z dietetykiem szpitalnym</strong> — konsultacje jadłospisów</li>
    <li><strong>Certyfikaty jakości</strong> — ISO 22000, FSSC 22000 mogą być wymagane lub punktowane</li>
  </ul>

  <h2>8. Jak wygrać przetarg na catering — praktyczne wskazówki</h2>

  <h3>Gdzie szukać przetargów?</h3>

  <p>Na platformie <strong><a href="/przetargi">Przetargowi.pl</a></strong> znajdziesz aktualne ogłoszenia o zamówieniach publicznych. Użyj wyszukiwarki z kodami CPV:</p>

  <ul>
    <li><strong>55.52.00.00</strong> — usługi dostarczania posiłków</li>
    <li><strong>55.32.10.00</strong> — usługi przygotowywania posiłków</li>
    <li><strong>15.89.42.10</strong> — posiłki szkolne</li>
  </ul>

  <p>Możesz też wyszukiwać po słowach kluczowych: „catering szkolny", „żywienie pacjentów", „usługi gastronomiczne".</p>

  <h3>Kryteria oceny ofert</h3>

  <p>W przetargach na catering stosuje się zazwyczaj kryteria:</p>

  <ul>
    <li><strong>Cena</strong> — typowo 60% wagi</li>
    <li><strong>Doświadczenie wykonawcy</strong> — np. liczba zrealizowanych kontraktów</li>
    <li><strong>Lokalizacja kuchni</strong> — bliskość do placówki (krótszy czas dostawy)</li>
    <li><strong>Certyfikaty jakości</strong> — ISO, HACCP ponad wymagane minimum</li>
    <li><strong>Jadłospis próbny</strong> — ocena wartości odżywczych i różnorodności</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">📈 Strategia cenowa</h4>
    <p style="margin-bottom: 0;">Przed ustaleniem ceny przeanalizuj kryteria oceny. Jeśli cena to 60%, a doświadczenie 40%, i masz silne referencje — możesz zaoferować wyższą cenę i nadal wygrać. Policz: <code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">Punkty za cenę = (cena najniższa / Twoja cena) × 60</code></p>
  </div>

  <h3>Typowe wymagania w SWZ</h3>

  <p>Zamawiający zazwyczaj wymagają:</p>

  <ul>
    <li><strong>Doświadczenie</strong> — np. 2-3 kontrakty na podobne usługi w ostatnich 3 latach</li>
    <li><strong>Zgoda Sanepidu</strong> — aktualna decyzja na produkcję i transport posiłków</li>
    <li><strong>Potencjał techniczny</strong> — własna kuchnia, środki transportu</li>
    <li><strong>Ubezpieczenie OC</strong> — polisa na działalność cateringową</li>
    <li><strong>Brak zaległości</strong> — ZUS, US, KRK</li>
  </ul>

  <h3>Najczęstsze błędy wykonawców</h3>

  <ol>
    <li><strong>Brak kompletu dokumentów</strong> — jedna brakująca strona może oznaczać odrzucenie</li>
    <li><strong>Nieaktualne zaświadczenia</strong> — ZUS, US muszą być z ostatnich 3 miesięcy</li>
    <li><strong>Błędny podpis elektroniczny</strong> — oferta musi być podpisana kwalifikowanym podpisem</li>
    <li><strong>Niedoszacowanie kosztów</strong> — zaniżona cena prowadzi do problemów z realizacją</li>
    <li><strong>Brak referencji</strong> — jeśli SWZ wymaga, dołącz potwierdzenie należytego wykonania</li>
  </ol>

  <h2>9. Kontrole i odpowiedzialność</h2>

  <h3>Kontrole Sanepidu</h3>

  <p>Sanepid przeprowadza kontrole:</p>

  <ul>
    <li><strong>Planowe</strong> — zazwyczaj raz w roku</li>
    <li><strong>Doraźne</strong> — na skutek skarg lub zatruć pokarmowych</li>
  </ul>

  <p>Podczas kontroli sprawdzane są:</p>

  <ul>
    <li>Dokumentacja HACCP, GHP/GMP</li>
    <li>Książeczki zdrowia personelu</li>
    <li>Temperatury w urządzeniach chłodniczych</li>
    <li>Czystość pomieszczeń i sprzętu</li>
    <li>Oznakowanie produktów i terminy przydatności</li>
    <li>Próbki żywnościowe (czy są pobierane i przechowywane)</li>
  </ul>

  <h3>Konsekwencje nieprawidłowości</h3>

  <ul>
    <li><strong>Nakaz usunięcia uchybień</strong> — z wyznaczonym terminem</li>
    <li><strong>Mandat</strong> — do 500 zł za drobne uchybienia</li>
    <li><strong>Kara administracyjna</strong> — do kilkudziesięciu tysięcy złotych</li>
    <li><strong>Zamknięcie zakładu</strong> — w przypadku zagrożenia dla zdrowia publicznego</li>
    <li><strong>Odpowiedzialność karna</strong> — w przypadku zatruć pokarmowych</li>
  </ul>

  <h2>10. Ile kosztuje wejście na rynek?</h2>

  <p>Orientacyjne koszty rozpoczęcia działalności cateringowej:</p>

  <ul>
    <li><strong>Adaptacja lokalu</strong> — 50 000 - 200 000 zł (zależnie od stanu)</li>
    <li><strong>Wyposażenie kuchni</strong> — 100 000 - 500 000 zł</li>
    <li><strong>Pojazd do transportu</strong> — 50 000 - 150 000 zł (lub leasing)</li>
    <li><strong>Dokumentacja HACCP</strong> — 2 000 - 10 000 zł (zlecenie firmie zewnętrznej)</li>
    <li><strong>Szkolenia personelu</strong> — 500 - 2 000 zł/osobę</li>
    <li><strong>Ubezpieczenie OC</strong> — 2 000 - 10 000 zł/rok</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">💡 Alternatywa — podwykonawstwo</h4>
    <p style="margin-bottom: 0;">Jeśli nie masz kapitału na własną kuchnię, rozważ współpracę jako podwykonawca większej firmy cateringowej. Możesz też wynająć kuchnię produkcyjną na godziny (tzw. dark kitchen). To sposób na zdobycie doświadczenia i referencji przy niższych kosztach wejścia.</p>
  </div>

  <h2>Podsumowanie — lista kontrolna przed startem</h2>

  <p>Zanim złożysz pierwszą ofertę przetargową, upewnij się że masz:</p>

  <ul>
    <li>✅ Zarejestrowaną działalność gospodarczą (PKD 56.29.Z — pozostała usługowa działalność gastronomiczna)</li>
    <li>✅ Zgłoszenie i akceptację Sanepidu dla kuchni</li>
    <li>✅ Wdrożony system HACCP z pełną dokumentacją</li>
    <li>✅ Procedury GHP/GMP</li>
    <li>✅ Przeszkolony personel z aktualnymi badaniami</li>
    <li>✅ Pojazd z odbiorem sanitarnym (własny lub wynajęty)</li>
    <li>✅ Ubezpieczenie OC</li>
    <li>✅ Umowę z firmą DDD</li>
    <li>✅ Umowę na wywóz odpadów gastronomicznych</li>
    <li>✅ Referencje (jeśli masz wcześniejsze doświadczenie)</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">🔍 Znajdź przetargi na catering</h4>
    <p style="margin-bottom: 12px;">Platforma <strong>Przetargowi.pl</strong> agreguje ogłoszenia o zamówieniach publicznych z całej Polski. Skonfiguruj powiadomienia dla kodów CPV 55.52 i 55.32, aby otrzymywać informacje o nowych przetargach na usługi cateringowe.</p>
    <p style="margin-bottom: 0;"><a href="/przetargi" style="color: #d4af37; font-weight: bold;">→ Przejdź do wyszukiwarki przetargów</a></p>
  </div>
  """

  def up do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    escaped_content = String.replace(@content, "'", "''")

    execute("""
    INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
    VALUES (
      'Catering dla szkół i szpitali — wymogi sanitarne, HACCP i jak wygrać przetarg',
      'catering-szkoly-szpitale-haccp-przetargi',
      'Kompleksowy przewodnik po cateringu dla placówek publicznych. Wymogi HACCP, Sanepid, kody CPV, jak przygotować ofertę i wygrać przetarg na usługi gastronomiczne.',
      'Catering dla szkół i szpitali — przewodnik 2026. Wymogi sanitarne, system HACCP, GHP/GMP, rejestracja w Sanepidzie, kody CPV 55, jak wygrać przetarg na usługi cateringowe.',
      'catering szkolny, catering szpitalny, HACCP, wymogi sanitarne, sanepid, przetarg catering, CPV 55, usługi gastronomiczne, żywienie zbiorowe, diety szpitalne, GHP GMP',
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
    execute("DELETE FROM articles WHERE slug = 'catering-szkoly-szpitale-haccp-przetargi'")
  end
end
