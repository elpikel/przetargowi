defmodule Przetargowi.Repo.Migrations.InsertBlogArticleKioAppeal do
  use Ecto.Migration

  @content """
<h2>Czym jest odwołanie do KIO?</h2>

<p>Odwołanie do Krajowej Izby Odwoławczej (KIO) to podstawowy środek ochrony prawnej przysługujący wykonawcom w postępowaniach o udzielenie zamówienia publicznego. Pozwala zakwestionować czynności lub zaniechania zamawiającego, które naruszają przepisy ustawy <a href="/ustawa-pzp">Prawo zamówień publicznych</a>.</p>

<p>Zgodnie z <a href="/ustawa-pzp#art-505">art. 505 ustawy Pzp</a>, odwołanie przysługuje wykonawcy, uczestnikowi konkursu oraz innemu podmiotowi, jeżeli ma lub miał interes w uzyskaniu zamówienia oraz poniósł lub może ponieść szkodę w wyniku naruszenia przepisów ustawy.</p>

<h2>Od jakich czynności można się odwołać?</h2>

<p>Zgodnie z <a href="/ustawa-pzp#art-513">art. 513 ustawy Pzp</a> odwołanie przysługuje na:</p>

<ul>
  <li><strong>Niezgodną z przepisami czynność zamawiającego</strong> — np. wybór oferty konkurenta, odrzucenie Twojej oferty, wykluczenie z postępowania</li>
  <li><strong>Zaniechanie czynności</strong> — np. nieodrzucenie oferty, która powinna być odrzucona</li>
  <li><strong>Zaniechanie przeprowadzenia postępowania</strong> — gdy zamawiający powinien był ogłosić przetarg, ale tego nie zrobił</li>
</ul>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <p style="margin: 0; color: #d4af37;"><strong>💡 Wskazówka:</strong> Przed złożeniem odwołania sprawdź podobne sprawy w naszej <a href="/szukaj" style="color: #d4af37;">bazie orzeczeń KIO</a>. Znajdziesz tam tysiące wyroków, które pomogą Ci ocenić szanse powodzenia.</p>
</div>

<h2>Terminy na wniesienie odwołania</h2>

<p>Terminy określone w <a href="/ustawa-pzp#art-515">art. 515 ustawy Pzp</a> są <strong>nieprzekraczalne</strong> — ich niedotrzymanie skutkuje odrzuceniem odwołania:</p>

<h3>Postępowania powyżej progów unijnych</h3>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Przedmiot odwołania</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Termin</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Czynność zamawiającego (informacja elektronicznie)</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>10 dni</strong></td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Czynność zamawiającego (informacja w inny sposób)</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>15 dni</strong></td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Treść ogłoszenia lub dokumentów zamówienia</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>10 dni</strong> od publikacji</td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Czynność, o której nie poinformowano</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>30 dni</strong> od publikacji ogłoszenia o udzieleniu zamówienia</td>
  </tr>
</table>

<h3>Postępowania poniżej progów unijnych</h3>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Przedmiot odwołania</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Termin</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Czynność zamawiającego (informacja elektronicznie)</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>5 dni</strong></td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Czynność zamawiającego (informacja w inny sposób)</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>10 dni</strong></td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Treść ogłoszenia lub dokumentów zamówienia</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>5 dni</strong> od publikacji</td>
  </tr>
</table>

<h2>Koszty odwołania do KIO</h2>

<p>Wniesienie odwołania wiąże się z obowiązkiem uiszczenia wpisu. Wysokość wpisu zależy od rodzaju i wartości zamówienia:</p>

<h3>Wpis od odwołania (2024)</h3>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Rodzaj zamówienia</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Poniżej progów UE</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Powyżej progów UE</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Dostawy i usługi</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>7 500 zł</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>15 000 zł</strong></td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Roboty budowlane</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>10 000 zł</strong></td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>20 000 zł</strong></td>
  </tr>
</table>

<h3>Dodatkowe koszty</h3>

<ul>
  <li><strong>Koszty zastępstwa prawnego</strong> — od 3 600 zł (stawka minimalna)</li>
  <li><strong>Koszty biegłego</strong> — jeśli zostanie powołany (rzadko)</li>
  <li><strong>Koszty dojazdu</strong> — rozprawa odbywa się w Warszawie</li>
</ul>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <p style="margin: 0; color: #d4af37;"><strong>⚠️ Ważne:</strong> W przypadku uwzględnienia odwołania, zamawiający zwraca odwołującemu wpis oraz ponosi koszty zastępstwa prawnego. W przypadku oddalenia — koszty ponosi odwołujący.</p>
</div>

<h2>Jak napisać odwołanie — wymagane elementy</h2>

<p>Zgodnie z <a href="/ustawa-pzp#art-516">art. 516 ustawy Pzp</a> odwołanie musi zawierać:</p>

<ol>
  <li><strong>Oznaczenie zamawiającego</strong> — pełna nazwa i adres</li>
  <li><strong>Określenie przedmiotu zamówienia</strong> — nazwa postępowania, numer referencyjny</li>
  <li><strong>Wskazanie zaskarżonej czynności lub zaniechania</strong> — co dokładnie kwestionujesz</li>
  <li><strong>Zarzuty</strong> — jakie przepisy naruszył zamawiający (z podaniem konkretnych artykułów)</li>
  <li><strong>Żądanie</strong> — czego oczekujesz (np. unieważnienia czynności wyboru, powtórzenia oceny)</li>
  <li><strong>Uzasadnienie</strong> — argumenty faktyczne i prawne</li>
  <li><strong>Dowody</strong> — dokumenty potwierdzające Twoje stanowisko</li>
  <li><strong>Podpis</strong> — osoby uprawnionej do reprezentacji</li>
</ol>

<h3>Przykładowa struktura odwołania</h3>

<ol>
  <li>Dane odwołującego i zamawiającego</li>
  <li>Oznaczenie postępowania</li>
  <li>Wskazanie zaskarżonej czynności</li>
  <li>Zarzuty (numerowane)</li>
  <li>Żądania (numerowane)</li>
  <li>Uzasadnienie faktyczne</li>
  <li>Uzasadnienie prawne (z powołaniem na orzecznictwo)</li>
  <li>Wnioski dowodowe</li>
  <li>Załączniki</li>
</ol>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">📚 Szukaj argumentów w orzecznictwie</h4>
  <p style="color: #e0e0e0; margin-bottom: 12px;">Powołanie się na wcześniejsze wyroki KIO znacząco wzmacnia argumentację. W naszej <a href="/szukaj" style="color: #d4af37;">bazie orzeczeń</a> znajdziesz:</p>
  <ul style="color: #e0e0e0; margin-bottom: 0;">
    <li>Wyroki dotyczące podobnych stanów faktycznych</li>
    <li>Interpretacje konkretnych przepisów ustawy Pzp</li>
    <li>Linie orzecznicze w spornych kwestiach</li>
  </ul>
</div>

<h2>Procedura odwoławcza krok po kroku</h2>

<h3>1. Wniesienie odwołania</h3>
<p>Odwołanie wnosi się do Prezesa KIO w formie elektronicznej przez <a href="https://ezamowienia.gov.pl" target="_blank" rel="noopener">platformę e-Zamówienia</a>. Jednocześnie należy przesłać kopię odwołania zamawiającemu.</p>

<h3>2. Badanie formalne</h3>
<p>Prezes KIO sprawdza, czy odwołanie spełnia wymogi formalne (termin, wpis, wymagane elementy). W przypadku braków — wzywa do uzupełnienia.</p>

<h3>3. Odpowiedź zamawiającego</h3>
<p>Zamawiający może uwzględnić odwołanie w całości (sprawa zakończona) lub wnieść odpowiedź na odwołanie.</p>

<h3>4. Przystąpienie innych wykonawców</h3>
<p>Inni wykonawcy mogą przystąpić do postępowania odwoławczego po stronie odwołującego lub zamawiającego (termin: 3 dni od otrzymania kopii odwołania).</p>

<h3>5. Rozprawa</h3>
<p>KIO rozpoznaje odwołanie na rozprawie. Termin: nie później niż 15 dni od dnia doręczenia odwołania (powyżej progów UE) lub 7 dni (poniżej progów).</p>

<h3>6. Wyrok</h3>
<p>KIO wydaje wyrok: uwzględnia odwołanie (w całości lub części) albo oddala. Wyrok jest ostateczny w administracyjnym toku instancji.</p>

<h2>Kiedy warto się odwołać?</h2>

<p>Odwołanie ma sens, gdy:</p>

<ul>
  <li><strong>Masz mocne argumenty prawne</strong> — naruszenie przepisów jest ewidentne</li>
  <li><strong>Wartość zamówienia jest znacząca</strong> — koszty odwołania są proporcjonalne do potencjalnych korzyści</li>
  <li><strong>Orzecznictwo jest po Twojej stronie</strong> — podobne sprawy były rozstrzygane na korzyść odwołujących</li>
  <li><strong>Masz dowody</strong> — możesz udowodnić swoje twierdzenia</li>
</ul>

<p>Odwołanie może nie być opłacalne, gdy:</p>

<ul>
  <li>Wartość zamówienia jest niska (koszty przekroczą potencjalne korzyści)</li>
  <li>Naruszenie jest dyskusyjne, a orzecznictwo niejednolite</li>
  <li>Brakuje dowodów na poparcie zarzutów</li>
  <li>Termin realizacji zamówienia jest bardzo krótki</li>
</ul>

<h2>Statystyki skuteczności odwołań do KIO</h2>

<p>Na podstawie danych z ostatnich lat:</p>

<table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
  <tr style="background: #f5f5f5;">
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Rozstrzygnięcie</th>
    <th style="padding: 12px; border: 1px solid #ddd; text-align: left;">Odsetek</th>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Odwołania uwzględnione</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>~35-40%</strong></td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Odwołania oddalone</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>~35-40%</strong></td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Odwołania uwzględnione przez zamawiającego</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>~10-15%</strong></td>
  </tr>
  <tr>
    <td style="padding: 12px; border: 1px solid #ddd;">Odwołania odrzucone/umorzone</td>
    <td style="padding: 12px; border: 1px solid #ddd;"><strong>~10-15%</strong></td>
  </tr>
</table>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">📊 Analizuj orzecznictwo przed decyzją</h4>
  <p style="color: #e0e0e0; margin-bottom: 0;">W <a href="/szukaj" style="color: #d4af37;">bazie orzeczeń Przetargowi.pl</a> możesz sprawdzić statystyki rozstrzygnięć dla konkretnych typów spraw, zamawiających czy przewodniczących składów orzekających.</p>
</div>

<h2>Najczęstsze błędy przy składaniu odwołań</h2>

<ol>
  <li><strong>Przekroczenie terminu</strong> — najczęstsza przyczyna odrzucenia</li>
  <li><strong>Brak wpisu</strong> — odwołanie bez opłaconego wpisu zostanie zwrócone</li>
  <li><strong>Zbyt ogólne zarzuty</strong> — należy wskazać konkretne przepisy</li>
  <li><strong>Brak interesu prawnego</strong> — musisz wykazać, że naruszenie wpływa na Twoją sytuację</li>
  <li><strong>Niedostarczenie kopii zamawiającemu</strong> — obowiązek ustawowy</li>
</ol>

<h2>Skarga do sądu na orzeczenie KIO</h2>

<p>Od wyroku KIO przysługuje skarga do Sądu Okręgowego w Warszawie — sądu zamówień publicznych. Termin: <strong>14 dni</strong> od doręczenia orzeczenia. Wpis od skargi wynosi 5-krotność wpisu od odwołania (37 500 - 100 000 zł).</p>

<h2>Podsumowanie</h2>

<p>Odwołanie do KIO to skuteczny środek ochrony prawnej, ale wymaga:</p>

<ul>
  <li>Dotrzymania krótkich terminów (5-15 dni)</li>
  <li>Poniesienia kosztów wpisu (7 500 - 20 000 zł)</li>
  <li>Profesjonalnego przygotowania argumentacji</li>
  <li>Znajomości orzecznictwa KIO</li>
</ul>

<div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
  <h4 style="color: #d4af37; margin-top: 0;">🔍 Przetargowi.pl — Twoje źródło wiedzy o KIO</h4>
  <p style="color: #e0e0e0; margin-bottom: 12px;">Korzystaj z naszych narzędzi:</p>
  <ul style="color: #e0e0e0; margin-bottom: 0;">
    <li><a href="/szukaj" style="color: #d4af37;"><strong>Baza orzeczeń KIO</strong></a> — tysiące wyroków z wyszukiwarką semantyczną</li>
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
      'Jak odwołać się do KIO - krok po kroku',
      'jak-odwolac-sie-do-kio',
      'Praktyczny przewodnik po procedurze odwoławczej przed Krajową Izbą Odwoławczą. Terminy, koszty, wymagane dokumenty oraz statystyki skuteczności odwołań.',
      'Jak złożyć odwołanie do KIO? Terminy (10/15 dni), koszty (7500-20000 zł), wymagane dokumenty, statystyki skuteczności. Praktyczny poradnik krok po kroku.',
      'odwołanie do KIO, Krajowa Izba Odwoławcza, terminy odwołania KIO, koszty odwołania KIO, jak napisać odwołanie, środki ochrony prawnej, zamówienia publiczne',
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
      "DELETE FROM articles WHERE slug = 'jak-odwolac-sie-do-kio'"
    )
  end
end
