defmodule Przetargowi.Repo.Migrations.InsertInitialBlogArticle do
  use Ecto.Migration

  @content """
  <h2>Wprowadzenie</h2>

  <p>Rynek dostaw środków medycznych do szpitali w Polsce to branża warta miliardy złotych rocznie. Województwo pomorskie, z 15 dużymi placówkami szpitalnymi i dziesiątkami mniejszych jednostek, regularnie ogłasza przetargi na dostawy sprzętu i materiałów medycznych. W tym artykule przedstawiamy konkretne dane i analizę rynku opartą na rzeczywistych przetargach, uzupełnioną o wymogi prawne i praktyczne wskazówki.</p>

  <h2>1. Wymogi prawne — dobra wiadomość dla początkujących</h2>

  <p>W przeciwieństwie do obrotu lekami, <strong>dystrybucja wyrobów medycznych nie wymaga koncesji ani zezwolenia</strong>. To znacznie obniża barierę wejścia na rynek. Musisz jednak spełnić wymogi wynikające z Rozporządzenia MDR (UE) 2017/745 oraz polskiej ustawy o wyrobach medycznych.</p>

  <h3>Obowiązki dystrybutora wg MDR</h3>
  <p>Jako dystrybutor wyrobów medycznych masz obowiązek:</p>
  <ul>
    <li><strong>Weryfikować oznakowanie CE</strong> — przed wprowadzeniem do obrotu sprawdź, czy wyrób ma oznakowanie CE i deklarację zgodności</li>
    <li><strong>Sprawdzić producenta</strong> — upewnij się, że producent jest znany i ma autoryzowanego przedstawiciela w UE</li>
    <li><strong>Kontrolować etykiety</strong> — wyrób musi mieć etykiety i instrukcje w języku polskim</li>
    <li><strong>Prowadzić rejestr</strong> — dokumentuj reklamacje, wyroby niezgodne, przypadki wycofania</li>
    <li><strong>Zapewnić identyfikowalność</strong> — przez 10-15 lat (dla implantów) musisz umieć wskazać, od kogo kupiłeś i komu sprzedałeś wyrób</li>
    <li><strong>Przechowywać zgodnie z instrukcją</strong> — warunki magazynowania i transportu muszą być zgodne z wymaganiami producenta</li>
  </ul>

  <h3>Rejestracja w URPL</h3>
  <p>Od 30 czerwca 2024 roku obowiązuje <strong>wymóg rejestracji dystrybutora</strong> w wykazie prowadzonym przez Prezesa Urzędu Rejestracji Produktów Leczniczych (URPL). Przed pierwszym wprowadzeniem wyrobu do obrotu w Polsce masz 14 dni na zgłoszenie.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <p style="margin: 0; color: #d4af37;"><strong>⚠️ Uwaga:</strong> Jeśli planujesz sprzedawać również leki (produkty farmaceutyczne), potrzebujesz zezwolenia na prowadzenie hurtowni farmaceutycznej — koszt opłaty to 6756 PLN i wymogi są znacznie wyższe. Na start rekomendujemy skupienie się na wyrobach medycznych.</p>
  </div>

  <h2>2. Główne placówki medyczne w Pomorskiem</h2>

  <p>Na podstawie analizy aktualnych przetargów zidentyfikowaliśmy kluczowe placówki zamawiające środki medyczne w regionie:</p>

  <ul>
    <li><strong>Uniwersyteckie Centrum Kliniczne (UCK) w Gdańsku</strong> — największy zamawiający w regionie, regularnie ogłasza przetargi na odczynniki laboratoryjne, zestawy operacyjne, implanty i sprzęt specjalistyczny</li>
    <li><strong>Szpitale Pomorskie Sp. z o.o.</strong> — sieć szpitali powiatowych z centralnymi zamówieniami</li>
    <li><strong>Wojewódzki Szpital Specjalistyczny w Słupsku</strong> — duży szpital wielospecjalistyczny</li>
    <li><strong>Szpital Powiatu Bytowskiego</strong> — materiały opatrunkowe, opatrunki, pieluchomajtki</li>
    <li><strong>Pomorskie Centrum Reumatologiczne w Sopocie</strong> — implanty ortopedyczne</li>
    <li><strong>7 Szpital Marynarki Wojennej w Gdańsku</strong> — sprzęt wojskowo-medyczny</li>
    <li><strong>Szpitale Tczewskie SA</strong> — materiały jednorazowe i sprzęt diagnostyczny</li>
    <li><strong>Szpitale powiatowe</strong> w Chojnicach, Kościerzynie, Prabutach, Malborku i innych miastach</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <p style="margin: 0; color: #d4af37;"><strong>💡 Wskazówka:</strong> Śledź przetargi wszystkich tych placówek w jednym miejscu. Na <a href="/przetargi/pomorskie" style="color: #d4af37;">Przetargowi.pl</a> znajdziesz aktualne ogłoszenia z województwa pomorskiego z automatycznymi aktualizacjami.</p>
  </div>

  <h2>3. Najczęściej zamawiane kategorie produktów (analiza CPV)</h2>

  <p>Analiza kodów CPV z przetargów pomorskich szpitali pokazuje, które kategorie produktów są najczęściej zamawiane:</p>

  <ol>
    <li><strong>Odczynniki laboratoryjne (CPV 33696500-0)</strong> — 13% przetargów. UCK regularnie zamawia odczynniki do profilowania DNA, cytometrii przepływowej i diagnostyki.</li>
    <li><strong>Urządzenia medyczne (CPV 33100000-1)</strong> — 10% przetargów. Sprzęt diagnostyczny, aparatura specjalistyczna.</li>
    <li><strong>Przyrządy chirurgiczne (CPV 33169000-2)</strong> — 6% przetargów. Instrumentarium operacyjne.</li>
    <li><strong>Implanty chirurgiczne (CPV 33184100-4)</strong> — 6% przetargów. Pomorskie Centrum Reumatologiczne w Sopocie jest głównym zamawiającym.</li>
    <li><strong>Materiały medyczne jednorazowe (CPV 33141000-0)</strong> — 4% przetargów. Podstawowe materiały eksploatacyjne.</li>
    <li><strong>Produkty farmaceutyczne (CPV 33600000-6)</strong> — 4% przetargów. Leki i preparaty.</li>
    <li><strong>Środki antyseptyczne i dezynfekcyjne (CPV 33631600-8)</strong> — 4% przetargów.</li>
    <li><strong>Opatrunki (CPV 33141110-4)</strong> — materiały opatrunkowe, pieluchomajtki, podkłady.</li>
  </ol>

  <p>Dla początkującego przedsiębiorcy najłatwiejszy punkt wejścia to <strong>materiały jednorazowe, opatrunki i środki dezynfekcyjne</strong> — wymagają mniejszych certyfikacji niż sprzęt specjalistyczny czy implanty.</p>

  <h2>4. Kryteria oceny ofert — co naprawdę liczy się w przetargach</h2>

  <p>Przeanalizowaliśmy kryteria oceny z setek przetargów medycznych. Oto rzeczywiste dane:</p>

  <h3>Waga ceny w przetargach</h3>
  <ul>
    <li><strong>100% cena</strong> — 31% przetargów (wyłącznie najniższa cena)</li>
    <li><strong>80% cena + 20% inne</strong> — 28% przetargów</li>
    <li><strong>60% cena + 40% inne</strong> — 33% przetargów</li>
    <li><strong>90% cena + 10% inne</strong> — 4% przetargów</li>
  </ul>

  <p><strong>Średnia waga ceny: 78,7%</strong>. Oznacza to, że cena nadal jest decydująca, ale nie możesz ignorować innych kryteriów.</p>

  <h3>Najczęstsze kryteria pozacenowe</h3>
  <ol>
    <li><strong>Okres gwarancji</strong> — występuje w 27% przetargów. Typowa waga: 10-20%. Dłuższa gwarancja = więcej punktów.</li>
    <li><strong>Termin dostawy</strong> — występuje w 11% przetargów. Waga: 10-40%. Szpitale cenią szybkie dostawy.</li>
    <li><strong>Parametry techniczne/jakość</strong> — 3% przetargów. Waga: do 40% w przypadku sprzętu specjalistycznego.</li>
    <li><strong>"Zamówienia zielone"</strong> — coraz częściej (10% wagi) dla produktów ekologicznych.</li>
  </ol>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <h4 style="color: #d4af37; margin-top: 0;">🎯 Praktyczna wskazówka</h4>
    <p style="color: #e0e0e0; margin-bottom: 12px;">Gdy cena to 60% wagi, a termin dostawy 40%, możesz wygrać mimo wyższej ceny oferując:</p>
    <ul style="color: #e0e0e0; margin-bottom: 0;">
      <li>Dostawę w 24h zamiast 7 dni</li>
      <li>Magazyn w regionie z natychmiastową dostępnością</li>
      <li>Gwarancję realizacji zamówień pilnych</li>
    </ul>
  </div>

  <h2>5. Jak wygrywać przetargi — praktyczne strategie</h2>

  <p>Kluczem do sukcesu jest dobre przygotowanie. Oto sprawdzone strategie:</p>

  <h3>Przygotowanie dokumentacji</h3>
  <ul>
    <li><strong>Stwórz checklistę</strong> — każdy brakujący dokument może oznaczać odrzucenie oferty</li>
    <li><strong>Sprawdź aktualność</strong> — certyfikaty CE, polisy OC, odpisy KRS muszą być aktualne</li>
    <li><strong>Dokładnie przeczytaj SIWZ</strong> — zapoznaj się ze wszystkimi warunkami udziału przed złożeniem oferty</li>
    <li><strong>Przygotuj pytania</strong> — jeśli coś jest niejasne, zadaj pytanie zamawiającemu przed terminem składania ofert</li>
  </ul>

  <h3>Strategia cenowa</h3>
  <ul>
    <li><strong>Poznaj budżet szpitala</strong> — placówki mają ograniczone środki finansowe, zbyt wysoka cena oznacza automatyczne odrzucenie</li>
    <li><strong>Analizuj poprzednie przetargi</strong> — sprawdź, jakie ceny wygrywały wcześniej</li>
    <li><strong>Kalkuluj marżę realnie</strong> — w materiałach jednorazowych: 15-25%, w sprzęcie: 10-20%</li>
    <li><strong>Nie licytuj na ślepo</strong> — zbyt niska cena podważa wiarygodność i może oznaczać problemy z realizacją</li>
  </ul>

  <h3>Budowanie wiarygodności</h3>
  <ul>
    <li><strong>Zbieraj referencje</strong> — każda zrealizowana umowa to potencjalna referencja do kolejnego przetargu</li>
    <li><strong>Certyfikaty jakościowe</strong> — ISO 9001 czy ISO 13485 zwiększają punktację w wielu przetargach</li>
    <li><strong>Networking</strong> — uczestnictwo w targach medycznych i konferencjach branżowych buduje rozpoznawalność</li>
    <li><strong>Transparentność</strong> — prezentuj oferty jasno i profesjonalnie</li>
  </ul>

  <h3>Po wygraniu przetargu</h3>
  <ul>
    <li><strong>Monitoruj realizację</strong> — terminowość dostaw wpływa na przyszłe przetargi</li>
    <li><strong>Reaguj na problemy</strong> — szybka reakcja na reklamacje buduje długoterminowe relacje</li>
    <li><strong>Dokumentuj wszystko</strong> — protokoły odbioru, potwierdzenia dostaw, korespondencja</li>
  </ul>

  <h2>6. Wymagania formalne — dokumenty i certyfikaty</h2>

  <h3>Rejestracja działalności</h3>
  <p>Podstawowe kody PKD dla dystrybutora środków medycznych:</p>
  <ul>
    <li><strong>46.46.Z</strong> — Sprzedaż hurtowa wyrobów farmaceutycznych i medycznych</li>
    <li><strong>47.74.Z</strong> — Sprzedaż detaliczna wyrobów medycznych (opcjonalnie)</li>
  </ul>
  <p>Rekomendowana forma prawna to <strong>spółka z o.o.</strong> — zapewnia ograniczenie odpowiedzialności osobistej i większą wiarygodność w oczach zamawiających.</p>

  <h3>Certyfikaty w zależności od kategorii produktów</h3>
  <ul>
    <li><strong>Materiały jednorazowe, opatrunki, środki dezynfekcyjne</strong> — Certyfikat CE produktów (od producenta), deklaracje zgodności. Relatywnie niski próg wejścia.</li>
    <li><strong>Sprzęt diagnostyczny i laboratoryjny</strong> — Certyfikat CE, często ISO 13485, karty katalogowe z parametrami technicznymi.</li>
    <li><strong>Implanty i wyroby inwazyjne</strong> — Pełna dokumentacja MDR, certyfikaty jednostki notyfikowanej, wpis do rejestru URPL. Wysoki próg wejścia.</li>
    <li><strong>Produkty farmaceutyczne</strong> — Zezwolenie na prowadzenie hurtowni farmaceutycznej. Bardzo rygorystyczne wymogi.</li>
  </ul>

  <h3>Standardowe dokumenty przetargowe</h3>
  <p>Na podstawie analizy SIWZ pomorskich szpitali, typowo wymagane są:</p>
  <ul>
    <li>Formularz ofertowy (wzór zamawiającego)</li>
    <li>Oświadczenie JEDZ lub oświadczenie o niepodleganiu wykluczeniu</li>
    <li>Odpis z KRS lub CEIDG</li>
    <li>Certyfikaty CE i deklaracje zgodności dla oferowanych produktów</li>
    <li>Karty katalogowe z parametrami technicznymi</li>
    <li>Referencje (dla większych zamówień)</li>
    <li>Polisa OC działalności</li>
  </ul>

  <h2>7. Strategia wejścia na rynek — krok po kroku</h2>

  <h3>Krok 1: Wybierz niszę produktową</h3>
  <p>Dla początkującego przedsiębiorcy rekomendujemy start od:</p>
  <ul>
    <li><strong>Materiały opatrunkowe i jednorazowe</strong> — regularnie zamawiane, niższe wymogi certyfikacyjne</li>
    <li><strong>Środki dezynfekcyjne i antyseptyczne</strong> — stały popyt, zwłaszcza po pandemii</li>
    <li><strong>Artykuły higieniczne</strong> — pieluchomajtki, podkłady, rękawiczki</li>
  </ul>

  <h3>Krok 2: Załatw formalności</h3>
  <ul>
    <li>Zarejestruj spółkę z o.o. lub działalność gospodarczą</li>
    <li>Zgłoś się do URPL jako dystrybutor wyrobów medycznych</li>
    <li>Wykup polisę OC działalności</li>
    <li>Przygotuj regulamin i politykę prywatności (RODO)</li>
  </ul>

  <h3>Krok 3: Nawiąż współpracę z producentami</h3>
  <ul>
    <li>Uzyskaj status autoryzowanego dystrybutora od 2-3 producentów</li>
    <li>Negocjuj warunki: ceny zakupu, terminy płatności, wsparcie marketingowe</li>
    <li>Upewnij się, że producent zapewnia pełną dokumentację CE i deklaracje zgodności</li>
    <li>Sprawdź, czy instrukcje i etykiety są dostępne w języku polskim</li>
  </ul>

  <h3>Krok 4: Zbuduj infrastrukturę</h3>
  <ul>
    <li><strong>Magazyn</strong> — odpowiednie warunki przechowywania zgodne z wymaganiami producenta (temperatura, wilgotność)</li>
    <li><strong>Logistyka</strong> — możliwość szybkich dostaw w regionie</li>
    <li><strong>System zarządzania</strong> — śledzenie partii produktów, terminów ważności, reklamacji</li>
  </ul>

  <h3>Krok 5: Pierwsze przetargi</h3>
  <p>Zacznij od mniejszych zamówień w szpitalach powiatowych:</p>
  <ul>
    <li>Szpital Powiatu Bytowskiego — regularnie zamawia materiały opatrunkowe</li>
    <li>SPZOZ w Człuchowie — mniejsze przetargi na plastry i opatrunki</li>
    <li>Powiatowe Centrum Zdrowia w Malborku — dreny i materiały do laparoskopii</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <h4 style="color: #d4af37; margin-top: 0;">🔍 Monitoruj przetargi automatycznie</h4>
    <p style="color: #e0e0e0; margin-bottom: 12px;"><a href="/przetargi/pomorskie" style="color: #d4af37;">Przetargowi.pl</a> agreguje wszystkie ogłoszenia z BZP i TED. Możesz:</p>
    <ul style="color: #e0e0e0; margin-bottom: 0;">
      <li>Filtrować po kodach CPV (np. 33141110-4 dla opatrunków)</li>
      <li>Śledzić konkretne szpitale</li>
      <li>Ustawić alerty na nowe przetargi</li>
    </ul>
    <p style="color: #e0e0e0; margin-top: 12px; margin-bottom: 0;"><a href="/przetargi/pomorskie" style="color: #d4af37; font-weight: bold;">→ Sprawdź aktualne przetargi medyczne w Pomorskiem</a></p>
  </div>

  <h2>8. Realistyczny budżet startowy</h2>

  <p>Na podstawie analizy przetargów pomorskich, oto realistyczne koszty wejścia:</p>

  <h3>Koszty jednorazowe</h3>
  <ul>
    <li><strong>Rejestracja spółki z o.o.</strong> — 2 000-5 000 PLN (notariusz, KRS, kapitał zakładowy min. 5000 PLN)</li>
    <li><strong>Pierwszy zakup towaru</strong> — 50 000-150 000 PLN (w zależności od kategorii)</li>
    <li><strong>Magazyn (wyposażenie)</strong> — 10 000-30 000 PLN</li>
    <li><strong>Polisa OC</strong> — 2 000-5 000 PLN/rok</li>
    <li><strong>System ERP/magazynowy</strong> — 5 000-15 000 PLN</li>
    <li><strong>Konsultacja prawna</strong> — 2 000-5 000 PLN (rekomendowane na start)</li>
  </ul>

  <h3>Koszty przetargowe</h3>
  <ul>
    <li><strong>Wadium</strong> — rzadko wymagane w mniejszych przetargach medycznych (według naszej analizy &lt;10% wymaga wadium)</li>
    <li><strong>Zabezpieczenie należytego wykonania</strong> — 5-10% wartości kontraktu (gwarancja bankowa lub ubezpieczeniowa)</li>
  </ul>

  <h3>Rekomendowany kapitał startowy</h3>
  <p><strong>Minimum 100 000 PLN</strong> dla ostrożnego startu z materiałami jednorazowymi.<br>
  <strong>250 000-500 000 PLN</strong> dla komfortowej działalności z szerszym asortymentem.</p>

  <h2>9. Odwołania do KIO — kiedy warto?</h2>

  <p>Jeśli Twoja oferta została odrzucona lub uważasz, że zamawiający naruszył procedurę, masz prawo złożyć odwołanie do Krajowej Izby Odwoławczej.</p>

  <p>Najczęstsze podstawy odwołań w przetargach medycznych:</p>
  <ul>
    <li>Zbyt restrykcyjne wymagania techniczne wykluczające konkurencję</li>
    <li>Nieprawidłowa ocena ofert według kryteriów</li>
    <li>Nieuzasadnione odrzucenie oferty</li>
    <li>Dyskryminacyjne warunki udziału</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
    <p style="margin: 0; color: #d4af37;"><strong>⚖️ Analizuj orzecznictwo:</strong> Przed złożeniem odwołania sprawdź podobne sprawy w naszej <a href="/orzecznictwo-kio" style="color: #d4af37;">bazie orzeczeń KIO</a>. Znajdziesz tam tysiące wyroków z wyszukiwarką semantyczną — wpisz problem (np. "zbyt restrykcyjne wymagania techniczne sprzęt medyczny") i znajdź precedensy.</p>
  </div>

  <h2>10. Kluczowe wskaźniki sukcesu</h2>

  <p>Śledź te metryki, aby ocenić rozwój swojej działalności:</p>

  <ul>
    <li><strong>Wskaźnik wygranych przetargów</strong> — na początku oczekuj 5-10%, doświadczeni gracze osiągają 20-30%</li>
    <li><strong>Średnia marża</strong> — w materiałach jednorazowych: 15-25%, w sprzęcie: 10-20%</li>
    <li><strong>Terminowość dostaw</strong> — utrzymuj 98%+ dla budowania reputacji</li>
    <li><strong>Rotacja zapasów</strong> — unikaj zamrożenia kapitału w wolno rotującym towarze</li>
    <li><strong>Poziom reklamacji</strong> — poniżej 1% świadczy o dobrej jakości</li>
  </ul>

  <h2>Podsumowanie</h2>

  <p>Rynek dostaw medycznych w Pomorskiem jest realną szansą dla nowych przedsiębiorców. Kluczowe wnioski:</p>

  <ul>
    <li><strong>Brak wymogu koncesji</strong> — dystrybucja wyrobów medycznych nie wymaga zezwolenia (w przeciwieństwie do leków)</li>
    <li><strong>Cena jest ważna (78,7% średnia waga)</strong>, ale nie jedyna — terminowość i gwarancja dają przewagę</li>
    <li><strong>Zacznij od materiałów jednorazowych</strong> — niższy próg wejścia niż sprzęt czy implanty</li>
    <li><strong>UCK w Gdańsku to największy gracz</strong>, ale szpitale powiatowe oferują łatwiejszy start</li>
    <li><strong>Monitoruj przetargi systematycznie</strong> — terminy są krótkie (często 7-14 dni)</li>
    <li><strong>Buduj relacje z producentami</strong> — lepsze ceny zakupu = wyższa konkurencyjność</li>
    <li><strong>Spełnij wymogi MDR</strong> — rejestracja w URPL i prowadzenie dokumentacji to obowiązek</li>
  </ul>

  <h3>Narzędzia na start</h3>
  <ul>
    <li><a href="/przetargi/pomorskie"><strong>Wyszukiwarka przetargów</strong></a> — wszystkie ogłoszenia z Pomorskiego w jednym miejscu</li>
    <li><a href="/orzecznictwo-kio"><strong>Baza orzeczeń KIO</strong></a> — tysiące wyroków z wyszukiwarką AI</li>
    <li><a href="/raporty"><strong>Raporty i analizy</strong></a> — statystyki rynku zamówień publicznych</li>
  </ul>

  <h3>Źródła i dalsze informacje</h3>
  <ul>
    <li><a href="https://www.gov.pl/web/zdrowie/wprowadzenie-wyrobow-medycznych-do-obrotu-i-do-uzywania">Ministerstwo Zdrowia — wprowadzenie wyrobów medycznych do obrotu</a></li>
    <li><a href="https://wyrobymedyczneokiemtemidy.pl/koncesja-i-wyroby-medyczne/">Wyroby medyczne okiem Temidy — wymogi prawne</a></li>
    <li><a href="https://tzlaw.pl/obowiazki-dystrybutora-w-swietle-rozporzadzenia-mdr-i-bezpieczenstwa-obrotu-wyrobow-medycznych/">Obowiązki dystrybutora wg MDR</a></li>
  </ul>
  """

  def up do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    escaped_content = String.replace(@content, "'", "''")

    execute("""
    INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
    VALUES (
      'Jak rozpocząć działalność dostarczania środków medycznych do szpitali w województwie pomorskim',
      'dostarczanie-srodkow-medycznych-do-szpitali-pomorskie',
      'Analiza rynku przetargów medycznych w Pomorskiem: kody CPV, kryteria oceny, główni zamawiający, wymogi prawne MDR. Praktyczny przewodnik oparty na danych z rzeczywistych przetargów.',
      'Jak dostarczać środki medyczne do szpitali w Pomorskiem. Analiza przetargów: UCK Gdańsk, szpitale powiatowe, kody CPV, wymogi MDR, rejestracja URPL. Dane z rzeczywistych ogłoszeń.',
      'przetargi medyczne pomorskie, dostawy do szpitali, UCK Gdańsk przetargi, materiały medyczne przetarg, MDR wyroby medyczne, URPL rejestracja, CPV 33140000, jak wygrać przetarg szpitalny',
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
      "DELETE FROM articles WHERE slug = 'dostarczanie-srodkow-medycznych-do-szpitali-pomorskie'"
    )
  end
end
