defmodule Przetargowi.Repo.Migrations.InsertBlogArticleWykluczenieSamooczyszczenie do
  use Ecto.Migration

  @slug "wykluczenie-wykonawcy-z-przetargu-podstawy-i-samooczyszczenie"
  @title "Wykluczenie wykonawcy z przetargu — podstawy z art. 108 i 109 Pzp oraz samooczyszczenie"
  @excerpt "Za co zamawiający może wykluczyć wykonawcę z postępowania, czym różnią się podstawy obligatoryjne od fakultatywnych, jak długo trwa wykluczenie i jak przeprowadzić skuteczne samooczyszczenie."
  @meta_description "Wykluczenie wykonawcy z przetargu: obligatoryjne (art. 108 Pzp) i fakultatywne (art. 109 Pzp) podstawy wykluczenia, okresy wykluczenia, samooczyszczenie (art. 110) i orzecznictwo KIO."
  @meta_keywords "wykluczenie wykonawcy, podstawy wykluczenia, art 108 pzp, art 109 pzp, samooczyszczenie, self-cleaning, art 110 pzp, wprowadzenie zamawiającego w błąd, orzecznictwo KIO"

  @content """
  <h2>Wykluczenie to nie to samo co odrzucenie oferty</h2>

  <p>Wykluczenie dotyczy <strong>wykonawcy</strong> — jego rzetelności i przeszłości — a nie treści oferty. W obecnej ustawie Pzp skutkiem zaistnienia podstawy wykluczenia jest odrzucenie oferty na podstawie <a href="/ustawa-pzp#art-226">art. 226 ust. 1 pkt 2 lit. a</a>, ale sama ocena odbywa się według odrębnych przepisów: <a href="/ustawa-pzp#art-108">art. 108</a> i <a href="/ustawa-pzp#art-109">art. 109 Pzp</a>.</p>

  <p>Spory o wykluczenie należą do najczęściej rozpoznawanych przez Krajową Izbę Odwoławczą. Aktualne rozstrzygnięcia znajdziesz tutaj: <a href="/orzecznictwo-kio/wykluczenie-wykonawcy">wykluczenie wykonawcy w orzecznictwie KIO</a>.</p>

  <h2>Podstawy obligatoryjne (art. 108 Pzp)</h2>

  <p>Stosuje się je w każdym postępowaniu, niezależnie od woli zamawiającego. Wykluczeniu podlega m.in. wykonawca:</p>

  <ul>
    <li>będący osobą fizyczną prawomocnie skazaną za przestępstwa wymienione w ustawie (m.in. korupcyjne, skarbowe, udział w zorganizowanej grupie przestępczej) — albo którego członka zarządu lub organu nadzorczego skazano za takie przestępstwo,</li>
    <li>wobec którego wydano prawomocny wyrok lub ostateczną decyzję o zaleganiu z podatkami lub składkami, chyba że przed upływem terminu składania ofert uregulował należności lub zawarł wiążące porozumienie w sprawie spłaty,</li>
    <li>wobec którego orzeczono zakaz ubiegania się o zamówienia publiczne,</li>
    <li>który zawarł z innymi wykonawcami porozumienie mające na celu zakłócenie konkurencji (zmowa przetargowa),</li>
    <li>którego wcześniejsze zaangażowanie w przygotowanie postępowania zakłóciło konkurencję, a zakłócenia nie da się wyeliminować inaczej.</li>
  </ul>

  <h2>Podstawy fakultatywne (art. 109 Pzp)</h2>

  <p>Obowiązują <strong>tylko wtedy, gdy zamawiający wskazał je w ogłoszeniu lub dokumentach zamówienia</strong>. Zawsze sprawdź w SWZ, które z nich zostały przewidziane. Najczęściej stosowane:</p>

  <ul>
    <li><strong>pkt 4</strong> — likwidacja, upadłość, zawieszenie działalności,</li>
    <li><strong>pkt 5</strong> — poważne naruszenie obowiązków zawodowych podważające uczciwość wykonawcy,</li>
    <li><strong>pkt 7</strong> — niewykonanie lub nienależyte wykonanie istotnego zobowiązania z wcześniejszej umowy, które doprowadziło do wypowiedzenia lub odstąpienia od umowy, odszkodowania, wykonania zastępczego lub realizacji uprawnień z rękojmi,</li>
    <li><strong>pkt 8</strong> — wprowadzenie zamawiającego w błąd w wyniku zamierzonego działania lub rażącego niedbalstwa,</li>
    <li><strong>pkt 10</strong> — przedstawienie w wyniku lekkomyślności lub niedbalstwa informacji wprowadzających w błąd, mogących mieć istotny wpływ na decyzje zamawiającego.</li>
  </ul>

  <div style="background: #fff8e1; border-left: 4px solid #c9a227; padding: 16px; margin: 20px 0; border-radius: 0 8px 8px 0;"><p style="margin: 0;"><strong>Proporcjonalność.</strong> W przypadkach z art. 109 ust. 1 pkt 1–5 i 7 zamawiający może nie wykluczać wykonawcy, jeżeli wykluczenie byłoby w sposób oczywisty nieproporcjonalne — np. gdy zaległość podatkowa jest niewielka (art. 109 ust. 3 Pzp).</p></div>

  <h2>Wprowadzenie w błąd — najczęstszy spór</h2>

  <p>Zarzut podania nieprawdziwych informacji pojawia się w odwołaniach najczęściej. Typowe sytuacje to zawyżone doświadczenie w wykazie usług, nieprawdziwe informacje o doświadczeniu osób oraz zatajenie w JEDZ wcześniejszego rozwiązania umowy.</p>

  <p>Z orzecznictwa KIO wynikają dwie praktyczne wskazówki. Po pierwsze, informacja wprowadzająca w błąd <strong>nie podlega uzupełnieniu</strong> — wykonawca nie może zastąpić jej prawdziwą na wezwanie z art. 128 Pzp. Po drugie, to zamawiający (a w postępowaniu odwoławczym odwołujący) musi wykazać, że informacja była nieprawdziwa; nie wystarczy wskazanie wątpliwości.</p>

  <h2>Jak długo trwa wykluczenie</h2>

  <p>Okresy wykluczenia określa <a href="/ustawa-pzp#art-111">art. 111 Pzp</a>. Dla najczęstszych podstaw fakultatywnych:</p>

  <ul>
    <li>poważne naruszenie obowiązków zawodowych i nienależyte wykonanie umowy — <strong>3 lata</strong> od zdarzenia będącego podstawą wykluczenia,</li>
    <li>wprowadzenie w błąd z winy umyślnej lub rażącego niedbalstwa (pkt 8) — <strong>2 lata</strong>,</li>
    <li>wprowadzenie w błąd z lekkomyślności lub niedbalstwa (pkt 10) — <strong>1 rok</strong>.</li>
  </ul>

  <p>Dla skazań okres wynosi co do zasady 5 lat od uprawomocnienia się wyroku, chyba że w wyroku określono inny okres.</p>

  <h2>Samooczyszczenie — jak uniknąć wykluczenia</h2>

  <p>Wykonawca, wobec którego zachodzi podstawa wykluczenia, może się przed nim obronić, przeprowadzając samooczyszczenie (<a href="/ustawa-pzp#art-110">art. 110 ust. 2 Pzp</a>). Musi udowodnić zamawiającemu, że spełnił <strong>łącznie</strong> trzy przesłanki:</p>

  <ol>
    <li><strong>naprawił lub zobowiązał się do naprawienia szkody</strong> wyrządzonej przestępstwem, wykroczeniem lub swoim nieprawidłowym postępowaniem, w tym przez zadośćuczynienie pieniężne,</li>
    <li><strong>wyczerpująco wyjaśnił fakty i okoliczności</strong> związane z nieprawidłowością oraz spowodowanymi przez nią szkodami, aktywnie współpracując z właściwymi organami lub zamawiającym,</li>
    <li><strong>podjął konkretne środki techniczne, organizacyjne i kadrowe</strong> zapobiegające dalszym nieprawidłowościom — np. zerwał powiązania z osobami odpowiedzialnymi, zreorganizował personel, wdrożył system kontroli i wewnętrzne regulacje.</li>
  </ol>

  <h3>Trzy zasady skutecznego samooczyszczenia</h3>

  <ul>
    <li><strong>Przyznaj się.</strong> Samooczyszczenie zakłada przyznanie, że podstawa wykluczenia zaistniała. Wykonawca, który w JEDZ zaznacza „nie”, a dopiero po wykryciu sprawy próbuje się oczyścić, zwykle przegrywa.</li>
    <li><strong>Zrób to od razu.</strong> Wyjaśnienia i dowody składa się wraz z oświadczeniem o niepodleganiu wykluczeniu, a nie dopiero na wezwanie.</li>
    <li><strong>Przedstaw dowody.</strong> Deklaracje nie wystarczą — potrzebne są dokumenty: potwierdzenie zapłaty kar lub odszkodowania, nowe procedury, zmiany kadrowe.</li>
  </ul>

  <p>Zobacz, jak Izba ocenia konkretne przypadki: <a href="/orzecznictwo-kio/samooczyszczenie">samooczyszczenie w orzecznictwie KIO</a>.</p>

  <h2>Co zrobić, gdy zostałeś wykluczony</h2>

  <p>Od czynności odrzucenia oferty z powodu wykluczenia przysługuje odwołanie do KIO. Sprawdź przede wszystkim: czy podstawa wykluczenia była przewidziana w dokumentach zamówienia, czy zamawiający wykazał wszystkie jej przesłanki w uzasadnieniu, czy nie upłynął okres wykluczenia i czy rozważono proporcjonalność. Pomoże Ci poradnik <a href="/blog/jak-odwolac-sie-do-kio">jak odwołać się do KIO</a> oraz zestawienie <a href="/blog/ile-kosztuje-odwolanie-do-kio-2026">kosztów odwołania</a>.</p>

  <h2>Najczęstsze pytania</h2>

  <h3>Czy naliczenie kar umownych oznacza wykluczenie z kolejnych przetargów?</h3>

  <p>Nie samo w sobie. Podstawa z art. 109 ust. 1 pkt 7 Pzp wymaga, aby wykonawca z przyczyn leżących po jego stronie w znacznym stopniu lub zakresie nie wykonał lub nienależycie wykonał istotne zobowiązanie, co doprowadziło do wypowiedzenia lub odstąpienia od umowy, odszkodowania, wykonania zastępczego lub realizacji uprawnień z rękojmi.</p>

  <h3>Czy trzeba ujawnić w JEDZ wcześniejsze rozwiązanie umowy, jeżeli się z nim nie zgadzam?</h3>

  <p>Tak. Wykonawca powinien podać informację o rozwiązaniu umowy i przedstawić swoje stanowisko, a ocena należy do zamawiającego. Zatajenie tej okoliczności naraża na zarzut wprowadzenia zamawiającego w błąd.</p>

  <h3>Czy wykluczenie w jednym postępowaniu działa automatycznie w innych?</h3>

  <p>Nie. Każdy zamawiający samodzielnie ocenia, czy wobec wykonawcy zachodzi podstawa wykluczenia. Wykonawca musi jednak ujawniać w kolejnych postępowaniach okoliczności, które mogą ją stanowić.</p>
  """

  def up do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    execute(fn ->
      repo().query!(
        """
        INSERT INTO articles (title, slug, excerpt, meta_description, meta_keywords, author, published, content, published_at, inserted_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, 'Redakcja Przetargowi.pl', true, $6, $7, $7, $7)
        ON CONFLICT (slug) DO UPDATE SET
          title = EXCLUDED.title,
          excerpt = EXCLUDED.excerpt,
          meta_description = EXCLUDED.meta_description,
          meta_keywords = EXCLUDED.meta_keywords,
          content = EXCLUDED.content,
          updated_at = EXCLUDED.updated_at
        """,
        [@title, @slug, @excerpt, @meta_description, @meta_keywords, @content, now]
      )
    end)
  end

  def down do
    execute(fn -> repo().query!("DELETE FROM articles WHERE slug = $1", [@slug]) end)
  end
end
