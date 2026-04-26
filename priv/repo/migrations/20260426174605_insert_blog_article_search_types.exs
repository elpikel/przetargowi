defmodule Przetargowi.Repo.Migrations.InsertBlogArticleSearchTypes do
  use Ecto.Migration

  @content """
  <h2>Wprowadzenie</h2>

  <p>Wyszukiwarka orzeczeń KIO na platformie <strong>Przetargowi.pl</strong> oferuje dwa tryby wyszukiwania: <strong>słowa kluczowe</strong> oraz <strong>wyszukiwanie semantyczne (AI)</strong>. Każdy z nich sprawdza się w innych sytuacjach i pozwala efektywniej znajdować potrzebne orzeczenia. W tym artykule wyjaśniamy, kiedy stosować który tryb — z perspektywy praktyki prawnej w zamówieniach publicznych.</p>

  <h2>1. Wyszukiwanie słów kluczowych — dla precyzyjnych zapytań</h2>

  <p>Tryb <strong>„Słowa kluczowe"</strong> działa jak klasyczna wyszukiwarka prawnicza. System znajduje orzeczenia zawierające dokładnie te słowa lub frazy, które wpiszesz. To narzędzie pierwszego wyboru, gdy wiesz czego szukasz.</p>

  <h3>Kiedy stosować?</h3>

  <ul>
    <li><strong>Wyszukiwanie po sygnaturze</strong> — „KIO 1234/24", „KIO 567/23"</li>
    <li><strong>Wyszukiwanie po przepisie</strong> — „art. 226 pkt 5", „art. 109 ust. 1 pkt 4"</li>
    <li><strong>Wyszukiwanie po terminie prawnym</strong> — „rażąco niska cena", „wadium", „JEDZ", „podmiot trzeci"</li>
    <li><strong>Wyszukiwanie po nazwie zamawiającego</strong> — gdy szukasz orzeczeń dotyczących konkretnej instytucji</li>
  </ul>

  <h3>Przykłady skutecznych zapytań</h3>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">💡 Przykłady zapytań słów kluczowych</h4>
    <ul style="margin-bottom: 0;">
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">KIO 811/23</code> — znajdzie orzeczenie o tej sygnaturze</li>
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">art. 226 pkt 5</code> — orzeczenia powołujące ten przepis</li>
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">rażąco niska cena wyjaśnienia</code> — sprawy o wyjaśnienia ceny</li>
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">self-cleaning art. 110 ust. 2</code> — procedura samooczyszczenia</li>
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">wadium gwarancja bankowa termin</code> — sprawy o terminy wniesienia wadium</li>
    </ul>
  </div>

  <h3>Zalety trybu słów kluczowych</h3>

  <ul>
    <li><strong>Natychmiastowe wyniki</strong> — wyszukiwanie trwa ułamek sekundy</li>
    <li><strong>Precyzyjne dopasowanie</strong> — znajdziesz dokładnie to, czego szukasz</li>
    <li><strong>Pełna paginacja</strong> — możesz przeglądać wszystkie wyniki (setki/tysiące orzeczeń)</li>
    <li><strong>Idealne do budowania linii orzeczniczej</strong> — wyszukuj po konkretnym przepisie</li>
  </ul>

  <h2>2. Wyszukiwanie semantyczne (AI) — dla opisu sytuacji faktycznej</h2>

  <p>Tryb <strong>„Semantyczne (AI)"</strong> rozumie <em>znaczenie</em> Twojego zapytania. Możesz opisać stan faktyczny sprawy własnymi słowami — system znajdzie orzeczenia dotyczące podobnych sytuacji, nawet jeśli używają innej terminologii.</p>

  <h3>Kiedy stosować?</h3>

  <ul>
    <li><strong>Szukasz precedensów do konkretnej sprawy</strong> — opisz stan faktyczny, a system znajdzie podobne przypadki</li>
    <li><strong>Nie znasz dokładnego przepisu</strong> — opisz problem, system znajdzie odpowiednie orzeczenia</li>
    <li><strong>Przygotowujesz argumentację odwołania</strong> — znajdź orzeczenia z podobnymi zarzutami</li>
    <li><strong>Słowa kluczowe nie dają satysfakcjonujących wyników</strong> — spróbuj opisać problem inaczej</li>
  </ul>

  <h3>Przykłady skutecznych zapytań</h3>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">💡 Przykłady zapytań semantycznych</h4>
    <ul style="margin-bottom: 0;">
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">wykonawca nie dołączył dokumentów potwierdzających doświadczenie w robotach budowlanych</code></li>
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">spór o kwalifikację omyłki w ofercie — oczywista czy istotna</code></li>
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">czy można uzupełnić brakujące pełnomocnictwo po upływie terminu składania ofert</code></li>
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">oferta odrzucona po niewystarczających wyjaśnieniach rażąco niskiej ceny</code></li>
      <li><code style="background: rgba(212, 175, 55, 0.2); padding: 2px 6px; border-radius: 4px;">konsorcjum powołuje się na doświadczenie partnera który nie będzie realizował zamówienia</code></li>
    </ul>
  </div>

  <h3>Zalety trybu semantycznego</h3>

  <ul>
    <li><strong>Rozumie kontekst</strong> — nie musisz znać dokładnej terminologii prawnej</li>
    <li><strong>Znajduje podobne przypadki</strong> — idealne do wyszukiwania precedensów</li>
    <li><strong>Pokazuje dopasowane fragmenty</strong> — od razu widzisz, dlaczego dane orzeczenie pasuje</li>
    <li><strong>Uzupełnia wyszukiwanie słów kluczowych</strong> — gdy tradycyjne metody zawodzą</li>
  </ul>

  <h2>3. Porównanie trybów — kiedy który wybrać</h2>

  <div style="overflow-x: auto;">
    <table style="width: 100%; border-collapse: collapse; margin: 24px 0;">
      <thead>
        <tr style="background: linear-gradient(135deg, #12233d 0%, #1a3052 100%); color: #fefcf8;">
          <th style="padding: 12px 16px; text-align: left; border: 1px solid #234168;">Sytuacja</th>
          <th style="padding: 12px 16px; text-align: left; border: 1px solid #234168;">Rekomendowany tryb</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;">Znam sygnaturę orzeczenia</td>
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;"><strong>Słowa kluczowe</strong></td>
        </tr>
        <tr style="background: #fdf8ed;">
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;">Szukam orzeczeń dotyczących konkretnego przepisu</td>
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;"><strong>Słowa kluczowe</strong></td>
        </tr>
        <tr>
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;">Buduję linię orzeczniczą w konkretnej kwestii</td>
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;"><strong>Słowa kluczowe</strong> + filtry</td>
        </tr>
        <tr style="background: #fdf8ed;">
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;">Szukam precedensów do sprawy klienta</td>
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;"><strong>Semantyczne (AI)</strong></td>
        </tr>
        <tr>
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;">Opisuję stan faktyczny własnymi słowami</td>
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;"><strong>Semantyczne (AI)</strong></td>
        </tr>
        <tr style="background: #fdf8ed;">
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;">Nie wiem, jaki przepis dotyczy mojego problemu</td>
          <td style="padding: 12px 16px; border: 1px solid #f3e4c3;"><strong>Semantyczne (AI)</strong></td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>4. Filtry — zawężanie wyników w obu trybach</h2>

  <p>Niezależnie od wybranego trybu, możesz zawęzić wyniki używając filtrów:</p>

  <ul>
    <li><strong>Rodzaj dokumentu</strong> — wyrok, postanowienie, uchwała</li>
    <li><strong>Sposób rozstrzygnięcia</strong> — oddalone, uwzględnione, umorzone, odrzucone</li>
    <li><strong>Organ wydający</strong> — KIO, Sąd Okręgowy, Sąd Apelacyjny</li>
    <li><strong>Tryb postępowania</strong> — przetarg nieograniczony, tryb podstawowy, zamówienie z wolnej ręki</li>
    <li><strong>Zakres dat</strong> — od/do kiedy wydano orzeczenie</li>
  </ul>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">⚖️ Praktyka: Szukanie korzystnych precedensów</h4>
    <p style="margin-bottom: 0;">Gdy reprezentujesz odwołującego, użyj wyszukiwania semantycznego z opisem stanu faktycznego, a następnie dodaj filtr <strong>„Sposób rozstrzygnięcia: uwzględnione"</strong>. Znajdziesz orzeczenia, w których KIO przyznało rację odwołującemu w podobnych sprawach — gotowe precedensy do argumentacji.</p>
  </div>

  <h2>5. Praktyczne scenariusze z praktyki prawniczej</h2>

  <h3>Scenariusz 1: Przygotowanie odwołania — rażąco niska cena</h3>

  <p>Klient otrzymał wezwanie do wyjaśnienia rażąco niskiej ceny. Potrzebujesz znaleźć orzeczenia dotyczące skutecznych wyjaśnień.</p>

  <p><strong>Krok 1:</strong> Tryb słów kluczowych: <code style="background: #f3e4c3; padding: 2px 6px; border-radius: 4px;">rażąco niska cena wyjaśnienia</code></p>
  <p><strong>Krok 2:</strong> Filtr: „Sposób rozstrzygnięcia: uwzględnione"</p>
  <p><strong>Rezultat:</strong> Orzeczenia, w których KIO uznało wyjaśnienia za wystarczające — wzorce skutecznej argumentacji.</p>

  <h3>Scenariusz 2: Ocena szans odwołania — odrzucenie oferty</h3>

  <p>Klient chce zaskarżyć odrzucenie oferty z powodu rzekomej niezgodności z SWZ. Musisz ocenić szanse powodzenia.</p>

  <p><strong>Krok 1:</strong> Tryb semantyczny: <code style="background: #f3e4c3; padding: 2px 6px; border-radius: 4px;">oferta odrzucona z powodu niezgodności z opisem przedmiotu zamówienia mimo spełnienia wymagań</code></p>
  <p><strong>Krok 2:</strong> Przeanalizuj znalezione orzeczenia — czy w podobnych sprawach KIO uwzględniało czy oddalało odwołania?</p>
  <p><strong>Rezultat:</strong> Realistyczna ocena szans i argumenty do wykorzystania.</p>

  <h3>Scenariusz 3: Reprezentacja zamawiającego — obrona przed zarzutami</h3>

  <p>Zamawiający otrzymał odwołanie z zarzutem naruszenia art. 226 ust. 1 pkt 5 PZP. Potrzebujesz linii orzeczniczej.</p>

  <p><strong>Krok 1:</strong> Tryb słów kluczowych: <code style="background: #f3e4c3; padding: 2px 6px; border-radius: 4px;">art. 226 ust. 1 pkt 5</code></p>
  <p><strong>Krok 2:</strong> Filtr: „Sposób rozstrzygnięcia: oddalone"</p>
  <p><strong>Krok 3:</strong> Filtr dat: ostatnie 2 lata (aktualna linia orzecznicza)</p>
  <p><strong>Rezultat:</strong> Orzeczenia, w których KIO oddaliło podobne zarzuty — argumenty do odpowiedzi na odwołanie.</p>

  <h3>Scenariusz 4: Konsultacja — wykluczenie wykonawcy</h3>

  <p>Klient pyta, czy może zostać wykluczony z postępowania z powodu zdarzenia sprzed 2 lat. Nie jesteś pewien, który przepis ma zastosowanie.</p>

  <p><strong>Krok 1:</strong> Tryb semantyczny: <code style="background: #f3e4c3; padding: 2px 6px; border-radius: 4px;">wykluczenie wykonawcy z powodu nierzetelności przy realizacji poprzedniego zamówienia termin</code></p>
  <p><strong>Krok 2:</strong> Przeanalizuj znalezione orzeczenia — zidentyfikuj odpowiednie przepisy i wykładnię KIO</p>
  <p><strong>Rezultat:</strong> Odpowiedź na pytanie klienta poparta orzecznictwem.</p>

  <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0; color: #e0e0e0;">
    <h4 style="color: #d4af37; margin-top: 0;">🚀 Wypróbuj wyszukiwarkę</h4>
    <p style="margin-bottom: 12px;">Baza <strong>Przetargowi.pl</strong> zawiera ponad <strong>50 000 orzeczeń KIO</strong> z pełnymi uzasadnieniami. Każde orzeczenie zawiera automatycznie wygenerowane <strong>meritum</strong> — streszczenie najważniejszych tez prawnych.</p>
    <p style="margin-bottom: 0;"><a href="/orzecznictwo-kio" style="color: #d4af37; font-weight: bold;">→ Przejdź do wyszukiwarki orzeczeń KIO</a></p>
  </div>

  <h2>Podsumowanie</h2>

  <ul>
    <li><strong>Słowa kluczowe</strong> — gdy znasz sygnaturę, przepis lub konkretny termin prawny</li>
    <li><strong>Semantyczne (AI)</strong> — gdy opisujesz stan faktyczny i szukasz precedensów</li>
    <li><strong>Filtry</strong> — zawsze używaj do zawężania wyników (szczególnie „Sposób rozstrzygnięcia")</li>
    <li><strong>Łącz oba tryby</strong> — zacznij od słów kluczowych, pogłębiaj wyszukiwaniem semantycznym</li>
  </ul>

  <p>Efektywne korzystanie z bazy orzeczeń KIO wymaga dopasowania trybu wyszukiwania do potrzeb konkretnej sprawy. Gdy pracujesz z konkretnym przepisem — słowa kluczowe. Gdy szukasz podobnych przypadków — wyszukiwanie semantyczne. Kombinacja obu metod daje najpełniejsze wyniki.</p>
  """

  def up do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    escaped_content = String.replace(@content, "'", "''")

    execute("""
    INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
    VALUES (
      'Wyszukiwarka orzeczeń KIO — jak efektywnie szukać precedensów',
      'wyszukiwarka-orzeczen-kio-tryby-wyszukiwania',
      'Jak korzystać z wyszukiwarki orzeczeń KIO: słowa kluczowe vs wyszukiwanie semantyczne AI. Praktyczne wskazówki dla prawników zamówień publicznych.',
      'Wyszukiwarka orzeczeń KIO — przewodnik dla prawników. Słowa kluczowe, wyszukiwanie semantyczne AI, filtry. Jak efektywnie znajdować precedensy w bazie KIO.',
      'wyszukiwarka KIO, orzeczenia KIO, precedensy, zamówienia publiczne, baza orzeczeń, odwołanie KIO, linia orzecznicza',
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
      "DELETE FROM articles WHERE slug = 'wyszukiwarka-orzeczen-kio-tryby-wyszukiwania'"
    )
  end
end
