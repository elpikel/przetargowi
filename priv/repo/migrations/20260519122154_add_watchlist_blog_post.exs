defmodule Przetargowi.Repo.Migrations.AddWatchlistBlogPost do
  use Ecto.Migration

  def up do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    content = """
    <h2>Problem: gubisz się w gąszczu przetargów</h2>

    <p>Każdego dnia w Biuletynie Zamówień Publicznych pojawia się <strong>ponad 1000 nowych ogłoszeń</strong>. Jako specjalista ds. zamówień publicznych lub przedsiębiorca startujący w przetargach, musisz przeszukiwać setki ogłoszeń, aby znaleźć te, które pasują do Twojej firmy.</p>

    <p>Gdy już znajdziesz interesujący przetarg, zaczyna się wyścig z czasem. Musisz:</p>

    <ul>
      <li>Przygotować dokumentację</li>
      <li>Zebrać niezbędne zaświadczenia</li>
      <li>Skalkulować ofertę</li>
      <li>Złożyć ją przed upływem terminu</li>
    </ul>

    <p>A przecież śledzisz jednocześnie <strong>wiele przetargów</strong>. Łatwo przegapić termin, szczególnie gdy terminy składania ofert pokrywają się lub gdy musisz czekać na dokumenty z urzędów.</p>

    <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3); border-radius: 12px; padding: 20px; margin: 24px 0;">
      <h4 style="color: #d4af37; margin-top: 0;">Czy wiesz, że...</h4>
      <p style="color: #e0e0e0; margin-bottom: 0;">Według naszych danych, <strong>23% użytkowników</strong> przynajmniej raz przegapiło termin składania oferty w interesującym ich przetargu. To stracone możliwości biznesowe warte setki tysięcy złotych.</p>
    </div>

    <h2>Rozwiązanie: Lista obserwowanych przetargów</h2>

    <p>Dlatego wprowadziliśmy <strong>funkcję obserwowania przetargów</strong> — prosty, ale potężny sposób na zarządzanie interesującymi Cię ogłoszeniami.</p>

    <h3>Jak to działa?</h3>

    <p>Gdy przeglądasz listę przetargów lub szczegóły ogłoszenia, zobaczysz <strong>ikonę gwiazdki</strong>. Wystarczy jedno kliknięcie, aby dodać przetarg do listy obserwowanych.</p>

    <p>Od tego momentu:</p>

    <ol>
      <li><strong>Wszystkie obserwowane przetargi</strong> znajdziesz w jednym miejscu — w zakładce „Obserwowane"</li>
      <li><strong>7 dni przed terminem</strong> otrzymasz e-mail z przypomnieniem</li>
      <li><strong>1 dzień przed terminem</strong> dostaniesz pilne powiadomienie</li>
    </ol>

    <p>Dzięki temu nigdy nie przegapisz ważnego terminu, nawet gdy śledzisz wiele przetargów jednocześnie.</p>

    <h2>Korzyści dla Twojej firmy</h2>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin: 24px 0;">
      <div style="background: #f8f9fa; border-radius: 12px; padding: 20px; border-left: 4px solid #d4af37;">
        <h4 style="margin-top: 0; color: #1a1a2e;">Oszczędność czasu</h4>
        <p style="margin-bottom: 0; color: #333;">Koniec z codziennym sprawdzaniem terminów w kalendarzu lub arkuszach Excel. System automatycznie przypomni Ci o zbliżających się deadlinach.</p>
      </div>

      <div style="background: #f8f9fa; border-radius: 12px; padding: 20px; border-left: 4px solid #d4af37;">
        <h4 style="margin-top: 0; color: #1a1a2e;">Lepsze zarządzanie</h4>
        <p style="margin-bottom: 0; color: #333;">Wszystkie interesujące Cię przetargi w jednym miejscu. Łatwo porównasz terminy i zdecydujesz, którym ogłoszeniom poświęcić najwięcej uwagi.</p>
      </div>

      <div style="background: #f8f9fa; border-radius: 12px; padding: 20px; border-left: 4px solid #d4af37;">
        <h4 style="margin-top: 0; color: #1a1a2e;">Więcej wygranych</h4>
        <p style="margin-bottom: 0; color: #333;">Nigdy więcej przegapionych terminów. Każdy obserwowany przetarg to potencjalny kontrakt, którego nie stracisz przez zapomnienie.</p>
      </div>
    </div>

    <h2>Darmowe konto vs Premium</h2>

    <p>Funkcja obserwowania przetargów jest dostępna dla wszystkich użytkowników Przetargowi.pl:</p>

    <table style="width: 100%; border-collapse: collapse; margin: 24px 0;">
      <tr style="background: #1a1a2e; color: #d4af37;">
        <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: left;">Funkcja</th>
        <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: center;">Konto darmowe</th>
        <th style="padding: 14px; border: 1px solid rgba(212, 175, 55, 0.3); text-align: center;">Premium (29 zł/mies.)</th>
      </tr>
      <tr>
        <td style="padding: 12px; border: 1px solid #ddd;">Obserwowanie przetargów</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">do 5 przetargów</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #2e7d32; font-weight: bold;">bez limitu</td>
      </tr>
      <tr style="background: #f9f9f9;">
        <td style="padding: 12px; border: 1px solid #ddd;">Przypomnienia e-mail (7 dni)</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #2e7d32;">tak</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #2e7d32;">tak</td>
      </tr>
      <tr>
        <td style="padding: 12px; border: 1px solid #ddd;">Przypomnienia e-mail (1 dzień)</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #2e7d32;">tak</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #2e7d32;">tak</td>
      </tr>
      <tr style="background: #f9f9f9;">
        <td style="padding: 12px; border: 1px solid #ddd;">Alerty o nowych przetargach</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">1 alert</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #2e7d32; font-weight: bold;">bez limitu</td>
      </tr>
      <tr>
        <td style="padding: 12px; border: 1px solid #ddd;">Wyszukiwanie semantyczne KIO</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #c62828;">nie</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #2e7d32;">tak</td>
      </tr>
      <tr style="background: #f9f9f9;">
        <td style="padding: 12px; border: 1px solid #ddd;">Automatyczne wypełnianie dokumentów</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #c62828;">nie</td>
        <td style="padding: 12px; border: 1px solid #ddd; text-align: center; color: #2e7d32;">tak</td>
      </tr>
    </table>

    <div style="background: linear-gradient(135deg, #d4af37 0%, #c9a227 100%); border-radius: 12px; padding: 24px; margin: 24px 0; text-align: center;">
      <h3 style="color: #1a1a2e; margin-top: 0;">Śledzisz więcej niż 5 przetargów?</h3>
      <p style="color: #1a1a2e; margin-bottom: 16px;">Przejdź na konto Premium i obserwuj nieograniczoną liczbę ogłoszeń. Dodatkowo zyskasz dostęp do alertów, wyszukiwania semantycznego orzeczeń KIO i automatycznego wypełniania dokumentów.</p>
      <a href="/subskrypcja/nowa" style="display: inline-block; background: #1a1a2e; color: #d4af37; padding: 12px 32px; border-radius: 8px; text-decoration: none; font-weight: bold;">Wypróbuj Premium</a>
    </div>

    <h2>Jak zacząć?</h2>

    <p>Korzystanie z funkcji obserwowania przetargów jest proste:</p>

    <ol>
      <li><strong>Zaloguj się</strong> na swoje konto (lub <a href="/rejestracja">załóż darmowe konto</a>, jeśli jeszcze go nie masz)</li>
      <li><strong>Znajdź interesujący przetarg</strong> w wyszukiwarce</li>
      <li><strong>Kliknij ikonę gwiazdki</strong> przy ogłoszeniu</li>
      <li><strong>Gotowe!</strong> Przetarg zostanie dodany do Twojej listy obserwowanych</li>
    </ol>

    <p>Od teraz otrzymasz automatyczne przypomnienia przed upływem terminu składania ofert.</p>

    <h2>Podsumowanie</h2>

    <p>Funkcja obserwowania przetargów to proste narzędzie, które może znacząco zwiększyć Twoją skuteczność w zamówieniach publicznych. Nie ryzykuj utraty kontraktów przez przegapiony termin — <strong>zacznij obserwować przetargi już dziś</strong>.</p>

    <p>Masz pytania? Napisz do nas na <a href="mailto:kontakt@przetargowi.pl">kontakt@przetargowi.pl</a> — chętnie pomożemy!</p>
    """
    |> String.replace("'", "''")
    |> String.trim()

    execute("""
    INSERT INTO articles (title, slug, excerpt, content, meta_description, meta_keywords, author, published, published_at, inserted_at, updated_at)
    VALUES (
      'Obserwuj przetargi i nigdy nie przegap terminu — nowa funkcja Przetargowi.pl',
      'obserwuj-przetargi-nowa-funkcja',
      'Przedstawiamy nową funkcję obserwowania przetargów. Dodawaj interesujące Cię ogłoszenia do listy obserwowanych, otrzymuj przypomnienia o zbliżających się terminach i zwiększ swoje szanse na wygranie przetargów.',
      '#{content}',
      'Obserwuj przetargi publiczne i otrzymuj przypomnienia o terminach. Nowa funkcja Przetargowi.pl pomaga śledzić interesujące ogłoszenia z BZP. Darmowe dla 5 przetargów.',
      'obserwowanie przetargów, przypomnienia o terminach, lista obserwowanych, przetargi publiczne, BZP, terminy składania ofert, zarządzanie przetargami',
      'Redakcja Przetargowi.pl',
      true,
      '#{now}',
      '#{now}',
      '#{now}'
    )
    """)
  end

  def down do
    execute("DELETE FROM articles WHERE slug = 'obserwuj-przetargi-nowa-funkcja'")
  end
end
