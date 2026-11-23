defmodule PrzetargowiWeb.LandingController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Blog
  alias Przetargowi.Judgements
  alias Przetargowi.Judgements.Topics
  alias Przetargowi.SitemapCache

  @base_url "https://przetargowi.pl"
  @pillar_url "#{@base_url}/orzecznictwo-kio"
  @topic_per_page 20

  @doc """
  Pillar page for KIO case law. This is the single indexable entry point for
  "orzecznictwo KIO" / "wyszukiwarka orzeczeń KIO" queries — the old bare `/szukaj`
  URL redirects here so the two pages do not compete with each other.
  """
  def orzecznictwo_kio(conn, _params) do
    total_count = Judgements.count_judgements()

    breadcrumbs = [
      %{name: "Strona główna", url: @base_url},
      %{name: "Orzecznictwo KIO", url: @pillar_url}
    ]

    faqs = [
      %{
        question: "Czym jest orzecznictwo KIO?",
        answer:
          "Orzecznictwo KIO to zbiór wyroków i postanowień wydawanych przez Krajową Izbę Odwoławczą — organ rozpatrujący odwołania w sprawach zamówień publicznych. Orzeczenia KIO stanowią ważne źródło interpretacji przepisów ustawy Prawo zamówień publicznych."
      },
      %{
        question: "Jak szukać orzeczeń KIO?",
        answer:
          "Na Przetargowi.pl możesz wyszukiwać orzeczenia KIO po słowach kluczowych, sygnaturze sprawy, dacie wydania lub rodzaju rozstrzygnięcia. Dostępne jest również wyszukiwanie semantyczne z AI, które znajduje orzeczenia podobne znaczeniowo do Twojego zapytania, oraz przegląd orzeczeń według zagadnień, np. rażąco niska cena czy tajemnica przedsiębiorstwa."
      },
      %{
        question: "Czy orzeczenia KIO są wiążące?",
        answer:
          "Orzeczenia KIO są wiążące dla stron danego postępowania odwoławczego. Choć formalnie nie stanowią precedensów, w praktyce są szeroko stosowane jako wskazówki interpretacyjne przez zamawiających, wykonawców i inne składy orzekające KIO."
      },
      %{
        question: "Ile orzeczeń KIO jest w bazie?",
        answer:
          "Nasza baza zawiera #{total_count} orzeczeń Krajowej Izby Odwoławczej oraz sądów rozpoznających skargi na orzeczenia KIO i jest regularnie aktualizowana. Znajdziesz tu wyroki, postanowienia oraz uchwały dotyczące zamówień publicznych."
      },
      %{
        question: "Jak długo trwa postępowanie przed KIO?",
        answer:
          "KIO rozpoznaje odwołanie w terminie 15 dni od dnia jego doręczenia Prezesowi Izby. Wyrok jest ogłaszany po zamknięciu rozprawy, a pisemne uzasadnienie doręczane stronom."
      },
      %{
        question: "Czy dostęp do orzeczeń KIO jest bezpłatny?",
        answer:
          "Tak. Przeglądanie i wyszukiwanie orzeczeń KIO w serwisie Przetargowi.pl jest bezpłatne i nie wymaga rejestracji."
      }
    ]

    conn
    |> assign(:page_title, "Orzecznictwo KIO — wyszukiwarka orzeczeń i wyroków KIO")
    |> assign(
      :meta_description,
      "Orzecznictwo KIO: #{total_count} wyroków i postanowień Krajowej Izby Odwoławczej. Wyszukiwarka orzeczeń KIO po sygnaturze, słowach kluczowych i z AI oraz przegląd według zagadnień."
    )
    |> assign(:canonical_url, @pillar_url)
    |> assign(:og_url, @pillar_url)
    |> assign(:breadcrumbs, breadcrumbs)
    |> assign(:faqs, faqs)
    |> assign(:topics, Topics.all())
    |> assign(:recent_judgements, Judgements.list_recent_judgements(9))
    |> assign(:recent_articles, Blog.list_recent_articles(3))
    |> assign(:outcomes, Judgements.outcome_summary(:all))
    |> assign(:year_counts, Judgements.year_counts(:all, 6))
    |> assign(:total_count, total_count)
    |> render(:orzecznictwo_kio)
  end

  @doc """
  KIO statistics: how appeals end, by year and by legal issue. Original data
  computed from the database — meant to be the page others cite.
  """
  def statistics(conn, _params) do
    stats = cached_statistics()
    canonical_url = "#{@pillar_url}/statystyki"

    breadcrumbs = [
      %{name: "Strona główna", url: @base_url},
      %{name: "Orzecznictwo KIO", url: @pillar_url},
      %{name: "Statystyki", url: canonical_url}
    ]

    conn
    |> assign(:page_title, "Statystyki KIO — ile odwołań uwzględnia Izba")
    |> assign(
      :meta_description,
      "Statystyki orzeczeń KIO: #{stats.outcomes.upheld_rate}% odwołań rozpoznanych merytorycznie zostało uwzględnionych. Skuteczność odwołań według lat i zagadnień na podstawie #{stats.outcomes.total} orzeczeń."
    )
    |> assign(:canonical_url, canonical_url)
    |> assign(:og_url, canonical_url)
    |> assign(:breadcrumbs, breadcrumbs)
    |> assign(:stats, stats)
    |> render(:statistics)
  end

  # ~27 aggregate queries; the figures change only when new rulings are synced.
  defp cached_statistics do
    case SitemapCache.get("kio-statistics") do
      {:ok, stats} ->
        stats

      :miss ->
        stats = build_statistics()
        SitemapCache.put("kio-statistics", stats, 3600)
        stats
    end
  end

  defp build_statistics do
    topics =
      Topics.all()
      |> Enum.map(fn topic ->
        summary = Judgements.outcome_summary(topic.issues)

        %{
          topic: topic,
          count: Judgements.count_topic_judgements(topic.issues),
          decided: group_count(summary, :upheld) + group_count(summary, :dismissed),
          upheld_rate: summary.upheld_rate
        }
      end)
      |> Enum.sort_by(& &1.count, :desc)

    %{
      total_count: Judgements.count_judgements(),
      outcomes: Judgements.outcome_summary(:all),
      years: Judgements.outcomes_by_year(10),
      topics: topics,
      generated_on: Date.utc_today()
    }
  end

  defp group_count(summary, key) do
    case Enum.find(summary.groups, &(&1.key == key)) do
      nil -> 0
      group -> group.count
    end
  end

  @doc """
  Topic hub: rulings on one legal issue with editorial copy and statistics.

  Hubs and single rulings share the `/orzecznictwo-kio/:slug` namespace. Hub
  slugs are a small curated set, so they are matched first; anything else is
  treated as a ruling slug (e.g. `kio-1499-26`) and handed to
  `JudgementController`, which answers 404 for unknown slugs.
  """
  def topic(conn, %{"slug" => slug} = params) do
    case Topics.get(slug) do
      nil ->
        conn
        |> put_view(html: PrzetargowiWeb.JudgementHTML)
        |> PrzetargowiWeb.JudgementController.show(params)

      topic ->
        render_topic(conn, topic, parse_page(params["strona"]))
    end
  end

  defp render_topic(conn, topic, page) do
    total_count = Judgements.count_topic_judgements(topic.issues)
    total_pages = max(ceil(total_count / @topic_per_page), 1)

    if page > total_pages do
      redirect(conn, to: Topics.path(topic))
    else
      judgements =
        Judgements.list_topic_judgements(topic.issues,
          limit: @topic_per_page,
          offset: (page - 1) * @topic_per_page
        )

      canonical_url = @base_url <> Topics.path(topic)

      breadcrumbs = [
        %{name: "Strona główna", url: @base_url},
        %{name: "Orzecznictwo KIO", url: @pillar_url},
        %{name: topic.name, url: canonical_url}
      ]

      conn
      |> assign(:page_title, topic_title(topic, page))
      |> assign(
        :meta_description,
        "#{topic.name} w orzecznictwie KIO — #{total_count} wyroków i postanowień Krajowej Izby Odwoławczej, statystyka rozstrzygnięć, podstawa prawna i najnowsze orzeczenia."
      )
      |> assign(:canonical_url, page_url(canonical_url, page))
      |> assign(:og_url, page_url(canonical_url, page))
      |> maybe_noindex_pagination(page)
      |> assign(:breadcrumbs, breadcrumbs)
      |> assign(:topic, topic)
      |> assign(:other_topics, Enum.reject(Topics.all(), &(&1.slug == topic.slug)))
      |> assign(:judgements, judgements)
      |> assign(:total_count, total_count)
      |> assign(:current_page, page)
      |> assign(:total_pages, total_pages)
      |> assign(:outcomes, Judgements.outcome_summary(topic.issues))
      |> assign(:year_counts, Judgements.year_counts(topic.issues, 6))
      |> assign(:top_provisions, Judgements.top_provisions(topic.issues, 8))
      |> render(:topic)
    end
  end

  defp topic_title(topic, 1), do: "#{topic.name} — orzecznictwo KIO, wyroki i postanowienia"
  defp topic_title(topic, page), do: "#{topic.name} — orzecznictwo KIO, strona #{page}"

  defp page_url(url, 1), do: url
  defp page_url(url, page), do: "#{url}?strona=#{page}"

  # Deeper pages are plain lists without the editorial copy; keep them
  # crawlable for discovery but out of the index.
  defp maybe_noindex_pagination(conn, 1), do: conn
  defp maybe_noindex_pagination(conn, _page), do: assign(conn, :meta_robots, "noindex, follow")

  defp parse_page(nil), do: 1

  defp parse_page(value) when is_binary(value) do
    case Integer.parse(value) do
      {page, ""} when page > 0 -> page
      _ -> 1
    end
  end

  defp parse_page(_), do: 1
end
