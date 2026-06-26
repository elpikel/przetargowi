defmodule Przetargowi.Repo.Migrations.InsertBlogArticleOchronaFizyczna do
  use Ecto.Migration

  @content """
<h2>Dlaczego warto startować w przetargach na ochronę fizyczną?</h2>

<p>Usługi ochrony fizycznej to jeden z najstabilniejszych segmentów zamówień publicznych. Instytucje publiczne — sądy, szpitale, uczelnie, muzea, jednostki wojskowe — muszą chronić swoje obiekty całorocznie. To oznacza <strong>powtarzalne kontrakty</strong>, często na 12-24 miesięcy, z opcją przedłużenia.</p>

<p>Według danych z <strong>Przetargowi.pl</strong>, w BZP publikowanych jest rocznie ponad <strong>300 przetargów</strong> na usługi ochroniarskie (CPV 79710000-4). Średnio to prawie jeden nowy przetarg dziennie.</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
  <h4 style="color: #d4af37; margin-top: 0;">Kody CPV, pod którymi szukać przetargów</h4>
  <ul style="margin-bottom: 0;">
    <li><strong>79710000-4</strong> — Usługi ochroniarskie (główny kod)</li>
    <li><strong>79711000-1</strong> — Usługi nadzoru przy użyciu alarmu</li>
    <li><strong>79713000-5</strong> — Usługi strażnicze</li>
    <li><strong>79714000-2</strong> — Usługi w zakresie nadzoru</li>
    <li><strong>79715000-9</strong> — Usługi patrolowe</li>
  </ul>
</div>

<h2>Kto zleca ochronę — główni zamawiający</h2>

<p>Analiza 329 przetargów na ochronę fizyczną z BZP pokazuje wyraźny obraz tego, kto najczęściej szuka firm ochroniarskich:</p>

<h3>Sądy i prokuratury — 20% rynku</h3>

<p>To największa pojedyncza kategoria zamawiających. Sądy rejonowe, okręgowe i apelacyjne regularnie ogłaszają przetargi na <strong>całodobową ochronę budynków</strong> wraz z obsługą systemu kontroli dostępu i monitoringu. Kontrakty obejmują zwykle 12-24 miesięcy. Wymagają pracowników z <strong>wpisem na listę kwalifikowanych pracowników ochrony</strong>.</p>

<h3>Spółki komunalne i przedsiębiorstwa — 14% rynku</h3>

<p>Miejskie przedsiębiorstwa gospodarki komunalnej, wodociągi, zakłady energetyczne. Obiekty infrastrukturalne — stacje uzdatniania wody, oczyszczalnie ścieków, sortownie odpadów. Często wymagają ochrony <strong>terenów rozległych</strong>, co oznacza konieczność patrolowania.</p>

<h3>Instytucje kultury — 12% rynku</h3>

<p>Muzea, teatry, galerie sztuki, filharmonie, centra kultury. Przykłady z ostatnich miesięcy: Sinfonia Varsovia w Warszawie, Galeria Sztuki Współczesnej w Opolu, Centrum Kultury „Muza" w Lubinie. Oprócz standardowej ochrony często wymagają <strong>obsługi szatni i recepcji</strong> oraz zabezpieczenia imprez.</p>

<h3>Uczelnie i placówki oświatowe — 8% rynku</h3>

<p>Politechniki, uniwersytety, szkoły. Politechnika Częstochowska, Politechnika Gdańska, szkoły w Krakowie. Specyfika: <strong>wiele budynków rozproszonych po kampusie</strong>, obsługa portierni, dozorowanie w godzinach nocnych.</p>

<h3>Szpitale — 6% rynku</h3>

<p>Szpitale wielospecjalistyczne, centra zdrowia, sanatoria. Wymagają ochrony <strong>24/7</strong>, często ze szczególnym naciskiem na izby przyjęć i SOR. Mogą wymagać przeszkolenia pracowników w zakresie zachowania w sytuacjach zagrożenia zdrowia.</p>

<h3>Jednostki wojskowe — specjalistyczny segment</h3>

<p>Wojskowy Instytut Medycyny Lotniczej, jednostki wojskowe, AMW. Wymagają <strong>poświadczeń bezpieczeństwa</strong> i doświadczenia w ochronie obiektów o charakterze obronnym. Wysokie wymagania, ale stabilne kontrakty.</p>

<h2>Gdzie jest najwięcej ogłoszeń?</h2>

<p>Przetargi na ochronę fizyczną rozkładają się nierównomiernie po kraju. Miasta z największą liczbą ogłoszeń:</p>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
  <h4 style="color: #d4af37; margin-top: 0;">Top 10 miast — przetargi na ochronę fizyczną</h4>
  <ol style="margin-bottom: 0;">
    <li><strong>Warszawa</strong> — 15,8% wszystkich przetargów na ochronę</li>
    <li><strong>Łódź</strong> — 6,2%</li>
    <li><strong>Wrocław</strong> — 5,6%</li>
    <li><strong>Kraków</strong> — 4,3%</li>
    <li><strong>Poznań</strong> — 3,7%</li>
    <li><strong>Szczecin</strong> — 3,7%</li>
    <li><strong>Katowice</strong> — 3,4%</li>
    <li><strong>Lublin</strong> — 3,1%</li>
    <li><strong>Białystok</strong> — 2,2%</li>
    <li><strong>Koszalin</strong> — 1,9%</li>
  </ol>
</div>

<p>Warszawa dominuje — co szósty przetarg na ochronę w Polsce jest publikowany przez stołeczne instytucje. Ale szanse są w każdym dużym mieście.</p>

<p><a href="/przetargi?q=ochrona+os%C3%B3b+i+mienia&amp;order_types[]=Us%C5%82ugi" rel="nofollow">Sprawdź aktualne przetargi na ochronę w swoim regionie →</a></p>

<h2>Co jest potrzebne, żeby startować?</h2>

<h3>1. Koncesja MSWiA — bez tego nie ruszysz</h3>

<p>Absolutny fundament to <strong>koncesja Ministra Spraw Wewnętrznych i Administracji</strong> na prowadzenie działalności gospodarczej w zakresie usług ochrony osób i mienia. Podstawa prawna: ustawa z dnia 22 sierpnia 1997 r. o ochronie osób i mienia (Dz.U. 2021, poz. 1995 z późn. zm.).</p>

<p>Bez koncesji oferta zostanie odrzucona — to warunek konieczny w <strong>100% przetargów</strong> na ochronę fizyczną.</p>

<p>Jak uzyskać: złożyć wniosek do MSWiA z dokumentacją potwierdzającą spełnienie warunków technicznych, kadrowych i finansowych. Procedura trwa ok. 2-3 miesięcy.</p>

<h3>2. Wpis na listę kwalifikowanych pracowników ochrony</h3>

<p>Zamawiający wymagają, aby pracownicy ochrony posiadali <strong>wpis na listę kwalifikowanych pracowników ochrony fizycznej</strong>, prowadzoną przez Komendanta Głównego Policji. Dotyczy to szczególnie:</p>

<ul>
  <li>Sądów i prokuratur</li>
  <li>Obiektów wojskowych</li>
  <li>Obiektów, w których przetwarzane są informacje niejawne</li>
</ul>

<p>Wpis wymaga: ukończenia kursu kwalifikowanego pracownika ochrony, braku karalności, zdolności fizycznej i psychicznej.</p>

<h3>3. Doświadczenie — konkretne referencje</h3>

<p>Najczęstszy wymóg: <strong>co najmniej 2-3 usługi ochrony</strong> zrealizowane w ciągu ostatnich 3 lat, każda:</p>

<ul>
  <li>Trwająca <strong>nieprzerwanie minimum 12 miesięcy</strong></li>
  <li>O wartości zbliżonej do szacunkowej wartości zamówienia</li>
  <li>Dotycząca obiektów <strong>o podobnym charakterze</strong> (np. obiekty użyteczności publicznej)</li>
</ul>

<p>Dla nowych firm: zacznij od mniejszych przetargów (szkoły, centra kultury), zbuduj referencje, potem celuj w większe kontrakty (sądy, szpitale).</p>

<h3>4. Ubezpieczenie OC</h3>

<p>Standardowo wymagane na kwotę od <strong>500 000 do 2 000 000 PLN</strong>. Im większy obiekt i wyższa wartość zamówienia, tym wyższa wymagana suma ubezpieczenia.</p>

<h3>5. Grupa interwencyjna</h3>

<p>Większość przetargów wymaga <strong>zapewnienia grupy interwencyjnej</strong> z czasem reakcji 10-15 minut. To oznacza, że musisz mieć bazę operacyjną (lub umowę z podwykonawcą) w pobliżu chronionego obiektu.</p>

<h3>6. Poświadczenie bezpieczeństwa (opcjonalnie)</h3>

<p>Dla obiektów wojskowych, rządowych lub przetwarzających informacje niejawne. Wymaga procedury sprawdzającej przeprowadzanej przez ABW lub SKW.</p>

<h2>Jak wygrywać przetargi na ochronę?</h2>

<h3>Zrozum kryteria oceny</h3>

<p>Typowe kryteria w przetargach na ochronę fizyczną:</p>

<ul>
  <li><strong>Cena — 60%</strong> (najczęściej)</li>
  <li><strong>Doświadczenie koordynatora — 20%</strong> (np. 5+ lat = max punktów)</li>
  <li><strong>Czas reakcji grupy interwencyjnej — 10%</strong> (im krócej, tym więcej punktów)</li>
  <li><strong>Odsetek kwalifikowanych pracowników — 10%</strong></li>
</ul>

<p>Cena waży dużo, ale nie jest jedynym kryterium. Mając doświadczonego koordynatora i szybką grupę interwencyjną, możesz wygrać nawet z nieco wyższą ceną.</p>

<h3>Kalkulacja ceny — nie schodź poniżej kosztów</h3>

<p>Najczęstszy błąd: zaniżanie ceny poniżej realnych kosztów pracowniczych. Pamiętaj:</p>

<ul>
  <li>Minimalna stawka godzinowa wynosi ponad <strong>30 zł brutto</strong> — i rośnie co roku</li>
  <li>Do stawki dolicz: składki ZUS, urlopy, L4, mundury, szkolenia, ubezpieczenie, koszty zarządu, zysk</li>
  <li>Jeśli cena jest o 30% niższa od szacunkowej wartości lub średniej ofert, zamawiający <strong>wezwie Cię do wyjaśnień</strong> w trybie rażąco niskiej ceny</li>
</ul>

<p><strong>Rażąco niska cena</strong> to najczęstszy powód odwołań do KIO w branży ochroniarskiej. Oferta bez rzetelnej kalkulacji zostanie odrzucona.</p>

<h3>Analizuj konkurencję</h3>

<p>Przed złożeniem oferty sprawdź, kto wygrywał podobne przetargi i w jakich cenach. Według danych z Przetargowi.pl, wśród najaktywniejszych firm ochroniarskich w zamówieniach publicznych w ostatnich miesiącach wyróżniają się m.in.:</p>

<ul>
  <li><strong>Basma Security Sp. z o.o.</strong> (Warszawa)</li>
  <li><strong>Protection Ochrona Mienia Sp. z o.o.</strong> (Tychy)</li>
  <li><strong>Makropol Sp. z o.o.</strong> (Poznań)</li>
  <li><strong>SOLID Security Sp. z o.o.</strong> (Warszawa)</li>
  <li><strong>STEKOP S.A.</strong> (Warszawa)</li>
  <li><strong>MAXUS Sp. z o.o.</strong> (Łódź)</li>
</ul>

<p>To nie znaczy, że mniejsze firmy nie mają szans — wręcz przeciwnie. Lokalne firmy ochroniarskie często wygrywają dzięki krótszemu czasowi dojazdu grupy interwencyjnej i znajomości specyfiki regionu.</p>

<p>Na <a href="/analiza-rynku">Przetargowi.pl</a> możesz sprawdzić, kto wygrywał podobne przetargi w Twoim regionie i w jakich cenach składał oferty.</p>

<h3>Startuj w konsorcjum</h3>

<p>Jeśli sam nie spełniasz warunków udziału (za mało referencji, za mała kadra), rozważ <strong>konsorcjum z inną firmą ochroniarską</strong>. Doświadczenie i potencjał kadrowy konsorcjantów sumują się. To częsta praktyka — wiele wygranych ofert to konsorcja dwóch lub trzech firm.</p>

<h2>Orzecznictwo KIO — na co uważać</h2>

<p>Spory w przetargach na ochronę fizyczną trafiają regularnie przed KIO. Najczęstsze tematy odwołań:</p>

<ul>
  <li><strong>Rażąco niska cena</strong> — weryfikacja, czy oferta pokrywa minimalne wynagrodzenie i koszty pośrednie</li>
  <li><strong>Niespełnienie warunków udziału</strong> — kwestionowanie referencji konkurenta (np. czy ochrona parkingu to „ochrona obiektu użyteczności publicznej")</li>
  <li><strong>Opis przedmiotu zamówienia</strong> — zbyt wąskie wymagania ograniczające konkurencję</li>
</ul>

<p>Przykładowe orzeczenia KIO w sprawach ochrony fizycznej:</p>

<ul>
  <li><a href="/orzeczenie/kio-202-26">KIO 202/26</a> — przetarg na ochronę Politechniki Warszawskiej w Płocku</li>
  <li><a href="/orzeczenie/kio-5738-25">KIO 5738/25</a> — ochrona cmentarzy komunalnych m.st. Warszawy</li>
  <li><a href="/orzeczenie/kio-5633-25">KIO 5633/25</a> — odwołanie konsorcjum firm ochroniarskich w Książnicy Beskidzkiej</li>
  <li><a href="/orzeczenie/kio-5769-25">KIO 5769/25</a> — spór dotyczący Agencji Ochrony DOGMAT</li>
</ul>

<p><a href="/szukaj?q=ochrona+fizyczna+osób+i+mienia" rel="nofollow">Przeszukaj pełną bazę orzeczeń KIO dotyczących ochrony fizycznej →</a></p>

<h2>Przetargi na ochronę — praktyczny harmonogram działania</h2>

<p>Jeśli dopiero wchodzisz w zamówienia publiczne, oto realistyczna ścieżka:</p>

<ol>
  <li><strong>Miesiąc 1-3:</strong> Uzyskaj koncesję MSWiA, wykup ubezpieczenie OC, zarejestruj pracowników na listę kwalifikowanych</li>
  <li><strong>Miesiąc 3-6:</strong> Zacznij od małych przetargów — szkoły, centra kultury, mniejsze urzędy. Buduj referencje</li>
  <li><strong>Miesiąc 6-12:</strong> Z 2-3 referencjami startuj w większych przetargach — sądy, szpitale, uczelnie</li>
  <li><strong>Rok 2+:</strong> Rozważaj konsorcja dla dużych kontraktów i specjalistycznych obiektów (wojsko, obiekty rządowe)</li>
</ol>

<h2>Jak nie przegapić nowych przetargów</h2>

<p>Terminy składania ofert w przetargach na ochronę bywają krótkie — najczęściej <strong>7-14 dni</strong> od publikacji. Żeby nie przegapić żadnego ogłoszenia:</p>

<ol>
  <li><strong>Ustaw alert e-mail</strong> na <a href="/przetargi">Przetargowi.pl</a> — otrzymasz powiadomienie o każdym nowym przetargu na usługi ochroniarskie w wybranym województwie</li>
  <li><strong>Monitoruj CPV 79710000-4</strong> — to główny kod dla usług ochroniarskich</li>
  <li><strong>Sprawdzaj wyniki podobnych przetargów</strong> — zobacz kto wygrał i za ile, zanim złożysz swoją ofertę</li>
</ol>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 24px; margin: 24px 0; color: #e0e0e0; text-align: center;">
  <h4 style="color: #d4af37; margin-top: 0;">Szukasz przetargów na ochronę fizyczną?</h4>
  <p style="margin-bottom: 16px;">Przeglądaj aktualne ogłoszenia z całej Polski i ustaw powiadomienia e-mail.</p>
  <a href="/przetargi?q=ochrona+os%C3%B3b+i+mienia&amp;order_types[]=Us%C5%82ugi" style="display: inline-block; background: #d4af37; color: #1a1a2e; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600;" rel="nofollow">Przeglądaj przetargi na ochronę →</a>
</div>
"""

  def up do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    escaped_content = String.replace(@content, "'", "''")

    execute("""
    INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
    VALUES (
      'Przetargi na ochronę fizyczną — jak startować i wygrywać [2026]',
      'przetargi-ochrona-fizyczna-jak-startowac',
      'Kompletny przewodnik po przetargach na usługi ochrony osób i mienia. Wymagania formalne, koncesja MSWiA, kryteria oceny ofert, orzecznictwo KIO i jak skutecznie składać oferty.',
      'Przetargi na ochronę fizyczną 2026. Koncesja MSWiA, CPV 79710000-4, kryteria oceny ofert, kalkulacja ceny, orzecznictwo KIO. Kto zleca, jak wygrywać.',
      'przetargi ochrona fizyczna, ochrona osób i mienia, CPV 79710000, koncesja MSWiA, usługi ochroniarskie, przetarg ochrona, ochrona obiektów, grupa interwencyjna, kwalifikowani pracownicy ochrony',
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
      "DELETE FROM articles WHERE slug = 'przetargi-ochrona-fizyczna-jak-startowac'"
    )
  end
end
