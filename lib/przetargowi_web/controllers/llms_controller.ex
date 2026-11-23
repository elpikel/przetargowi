defmodule PrzetargowiWeb.LlmsController do
  @moduledoc """
  Serves `/llms.txt` — a plain Markdown map of the site for AI assistants and
  answer engines (https://llmstxt.org). It is generated from the same sources
  as the pages themselves, so new topic hubs and articles appear automatically.
  """
  use PrzetargowiWeb, :controller

  alias Przetargowi.Blog
  alias Przetargowi.Judgements
  alias Przetargowi.Judgements.Topics
  alias Przetargowi.SitemapCache

  @base_url "https://przetargowi.pl"
  @ttl_seconds 3600

  def index(conn, _params) do
    body =
      case SitemapCache.get("llms.txt") do
        {:ok, body} ->
          body

        :miss ->
          body = build()
          SitemapCache.put("llms.txt", body, @ttl_seconds)
          body
      end

    conn
    |> put_resp_content_type("text/plain")
    |> put_resp_header("cache-control", "public, max-age=#{@ttl_seconds}")
    |> send_resp(200, body)
  end

  defp build do
    topics =
      Enum.map_join(Topics.all(), "\n", fn topic ->
        "- [#{topic.name} — orzecznictwo KIO](#{@base_url}#{Topics.path(topic)}): #{topic.lead}"
      end)

    articles =
      Enum.map_join(Blog.list_articles(limit: 50), "\n", fn article ->
        "- [#{article.title}](#{@base_url}/blog/#{article.slug}): #{one_line(article.excerpt)}"
      end)

    """
    # Przetargowi.pl

    > Polski serwis o zamówieniach publicznych: baza #{Judgements.count_judgements()} orzeczeń Krajowej Izby Odwoławczej (KIO) i sądów rozpoznających skargi na te orzeczenia, wyszukiwarka aktualnych przetargów z Biuletynu Zamówień Publicznych (BZP), tekst ustawy Prawo zamówień publicznych oraz poradniki dla wykonawców i zamawiających.

    Orzeczenia pochodzą z oficjalnej bazy Urzędu Zamówień Publicznych (orzeczenia.uzp.gov.pl). Każde orzeczenie ma stały adres w postaci #{@base_url}/orzecznictwo-kio/{sygnatura}, np. #{@base_url}/orzecznictwo-kio/kio-1499-26 dla sygnatury KIO 1499/26, i zawiera pełną treść, streszczenie, sposób rozstrzygnięcia, powołane przepisy ustawy Pzp oraz zagadnienia merytoryczne. Strony zagadnień podają statystykę rozstrzygnięć liczoną na bieżąco z bazy.

    ## Orzecznictwo KIO

    - [Orzecznictwo KIO — strona główna bazy](#{@base_url}/orzecznictwo-kio): wyszukiwarka orzeczeń, statystyka rozstrzygnięć KIO i przegląd zagadnień
    - [Statystyki KIO](#{@base_url}/orzecznictwo-kio/statystyki): odsetek odwołań uwzględnionych i oddalonych według lat i zagadnień, liczony z bazy orzeczeń
    #{topics}

    ## Przepisy

    - [Ustawa Prawo zamówień publicznych](#{@base_url}/ustawa-pzp): pełny tekst ustawy z 11 września 2019 r.; artykuły mają kotwice w postaci #art-226

    ## Przetargi

    - [Aktualne przetargi publiczne](#{@base_url}/przetargi): ogłoszenia o zamówieniach z BZP z terminami składania ofert
    - [Przetargi budowlane](#{@base_url}/przetargi/branza/budowlane): ogłoszenia z działu CPV 45
    - [Analiza rynku przetargów](#{@base_url}/analiza-rynku): kto wygrywa przetargi w danej branży i regionie
    - [Raporty przetargowe](#{@base_url}/raporty): comiesięczne raporty rynku zamówień publicznych

    ## Poradniki

    #{articles}

    ## Informacje

    - [O nas](#{@base_url}/o-nas)
    - [Kontakt](#{@base_url}/kontakt)
    - [Mapa witryny (XML)](#{@base_url}/sitemap.xml)
    """
  end

  defp one_line(nil), do: ""
  defp one_line(text), do: text |> String.replace(~r/\s+/, " ") |> String.trim()
end
