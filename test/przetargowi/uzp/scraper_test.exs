defmodule Przetargowi.UZP.ScraperTest do
  use ExUnit.Case, async: true

  import Mox

  alias Przetargowi.UZP.Scraper

  setup :verify_on_exit!

  @list_page_html """
  <input type="hidden" value="500,480,15,3,2" id="resultCounts" />
  <div class="search-list-item">
    <p><label>Organ wydający:</label> Krajowa Izba Odwoławcza</p>
    <p><label>Rodzaj dokumentu:</label> Wyrok</p>
    <p><label>Sygnatura:</label> KIO 1234/24</p>
    <p><label>Data wydania:</label> 15-12-2024</p>
    <a class="link-details" href="/Home/Details/12345">Wyświetl szczegóły</a>
  </div>
  <div class="search-list-item">
    <p><label>Organ wydający:</label> Krajowa Izba Odwoławcza</p>
    <p><label>Rodzaj dokumentu:</label> Postanowienie</p>
    <p><label>Sygnatura:</label> KIO 1235/24</p>
    <p><label>Data wydania:</label> 14-12-2024</p>
    <a class="link-details" href="/Home/Details/12346">Wyświetl szczegóły</a>
  </div>
  <nav class="results-pager">
    <ul class="pagination">
      <li><a href="#" data-page="1">1 z 50</a></li>
    </ul>
  </nav>
  """

  @details_page_html """
  <!DOCTYPE html>
  <html>
  <body>
    <div class="details">
      <div class="details-metrics">
        <div class="row">
          <div class="col-md-6">
            <p><label>Przewodniczący</label> Jan Kowalski</p>
          </div>
          <div class="col-md-6">
            <p><label>Zamawiający</label> Gmina Warszawa</p>
          </div>
          <div class="col-md-6">
            <p><label>Miejscowość</label> Warszawa</p>
          </div>
          <div class="col-md-6">
            <p><label>Tryb postępowania</label> Przetarg nieograniczony</p>
          </div>
          <div class="col-md-6">
            <label>Sygnatura akt / Sposób rozstrzygnięcia</label>
            <ul><li>KIO 1234/24 / Oddalenie odwołania</li></ul>
          </div>
        </div>
        <div>
          <b>Kluczowe przepisy ustawy Pzp</b>
          <p><a href="/Home/Search?Phrase=art" title="Kliknij">Art. 226 ust. 1 | Art. 109 ust. 1 pkt 7</a></p>
          <b>Zagadnienia merytoryczne w odwołaniu z Indeksu tematycznego</b>
          <p><a href="/Home/Search" title="indeksu tematycznego">| Wykluczenie wykonawcy | Odrzucenie oferty |</a></p>
        </div>
      </div>
      <div class="doc-preview">
        <iframe id="iframeContent" src="/Home/ContentHtml/12345?Kind=KIO"></iframe>
      </div>
      <a href="/Home/PdfContent/12345">Pobierz PDF</a>
    </div>
  </body>
  </html>
  """

  @empty_list_html """
  <input type="hidden" value="0,0,0,0,0" id="resultCounts" />
  <div class="row">
    <div class="col-md-12">
    </div>
  </div>
  """

  describe "fetch_list_page/1" do
    test "parses judgements from list page" do
      Przetargowi.UZP.HTTPClientMock
      |> expect(:post, fn url, body ->
        assert String.contains?(url, "/Home/GetResults")
        assert String.contains?(body, "Pg=1")
        {:ok, %{status: 200, body: @list_page_html}}
      end)

      assert {:ok, result} = Scraper.fetch_list_page(1)
      assert %{judgements: judgements, total_pages: 50} = result
      assert length(judgements) == 2

      [first | _] = judgements
      assert first.uzp_id == "12345"
      assert first.signature == "KIO 1234/24"
      assert first.issuing_authority == "Krajowa Izba Odwoławcza"
      assert first.document_type == "Wyrok"
      assert first.decision_date == ~D[2024-12-15]
    end

    test "returns empty list when no results" do
      Przetargowi.UZP.HTTPClientMock
      |> expect(:post, fn _url, _body ->
        {:ok, %{status: 200, body: @empty_list_html}}
      end)

      assert {:ok, %{judgements: [], total_pages: 1}} = Scraper.fetch_list_page(1)
    end

    test "returns error on non-200 status" do
      Przetargowi.UZP.HTTPClientMock
      |> expect(:post, fn _url, _body ->
        {:ok, %{status: 500, body: "Internal Server Error"}}
      end)

      assert {:error, "Unexpected status code: 500"} = Scraper.fetch_list_page(1)
    end

    test "returns error on HTTP failure" do
      Przetargowi.UZP.HTTPClientMock
      |> expect(:post, fn _url, _body ->
        {:error, %Req.TransportError{reason: :timeout}}
      end)

      assert {:error, _} = Scraper.fetch_list_page(1)
    end
  end

  @content_html """
  <!DOCTYPE html><html><body>
  <p><b>Sygn. akt: KIO 1234/24</b></p>
  <p><b>WYROK</b></p>
  <p>Krajowa Izba Odwoławcza w składzie: Przewodniczący: Jan Kowalski...</p>
  </body></html>
  """

  describe "fetch_details/1" do
    test "parses details from detail page and fetches content HTML" do
      Przetargowi.UZP.HTTPClientMock
      |> expect(:get, fn url ->
        assert String.contains?(url, "/Home/Details/12345")
        {:ok, %{status: 200, body: @details_page_html}}
      end)
      |> expect(:get, fn url ->
        assert String.contains?(url, "/Home/ContentHtml/12345")
        {:ok, %{status: 200, body: @content_html}}
      end)

      assert {:ok, details} = Scraper.fetch_details("12345")

      assert details.chairman == "Jan Kowalski"
      assert details.contracting_authority == "Gmina Warszawa"
      assert details.location == "Warszawa"
      assert details.procedure_type == "Przetarg nieograniczony"
      assert details.resolution_method == "Oddalenie odwołania"
      assert "Art. 226 ust. 1" in details.key_provisions
      assert "Art. 109 ust. 1 pkt 7" in details.key_provisions
      assert "Wykluczenie wykonawcy" in details.thematic_issues
      assert "Odrzucenie oferty" in details.thematic_issues
      assert details.content_html =~ "Sygn. akt: KIO 1234/24"
      assert details.content_html =~ "WYROK"
      assert details.pdf_url =~ "/Home/PdfContent/12345"
      assert details.details_synced_at != nil
    end

    test "returns error on non-200 status" do
      Przetargowi.UZP.HTTPClientMock
      |> expect(:get, fn _url ->
        {:ok, %{status: 404, body: "Not Found"}}
      end)

      assert {:error, "Unexpected status code: 404"} = Scraper.fetch_details("99999")
    end

    test "returns error on HTTP failure" do
      Przetargowi.UZP.HTTPClientMock
      |> expect(:get, fn _url ->
        {:error, %Req.TransportError{reason: :econnrefused}}
      end)

      assert {:error, _} = Scraper.fetch_details("12345")
    end
  end
end
