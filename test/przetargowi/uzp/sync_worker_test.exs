defmodule Przetargowi.UZP.SyncWorkerTest do
  use Przetargowi.DataCase, async: true
  use Oban.Testing, repo: Przetargowi.Repo

  import Mox

  alias Przetargowi.UZP.SyncWorker
  alias Przetargowi.Judgements

  setup :verify_on_exit!

  @list_page_html """
  <input type="hidden" value="1,1,0,0,0" id="resultCounts" />
  <div class="search-list-item">
    <p><label>Organ wydający:</label> Krajowa Izba Odwoławcza</p>
    <p><label>Rodzaj dokumentu:</label> Wyrok</p>
    <p><label>Sygnatura:</label> KIO 1234/24</p>
    <p><label>Data wydania:</label> 15-12-2024</p>
    <a class="link-details" href="/Home/Details/12345">Wyświetl szczegóły</a>
  </div>
  """

  @empty_list_html """
  <input type="hidden" value="0,0,0,0,0" id="resultCounts" />
  <div class="row">
    <div class="col-md-12">
    </div>
  </div>
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
            <label>Sygnatura akt / Sposób rozstrzygnięcia</label>
            <ul><li>KIO 1234/24 / Oddalenie odwołania</li></ul>
          </div>
        </div>
      </div>
      <div class="doc-preview">
        <iframe id="iframeContent" src="/Home/ContentHtml/12345?Kind=KIO"></iframe>
      </div>
    </div>
  </body>
  </html>
  """

  describe "perform/1 with mode: list" do
    test "syncs judgements from list pages" do
      # First page returns one judgement, second page is empty
      Przetargowi.UZP.HTTPClientMock
      |> expect(:post, fn _url, body ->
        if String.contains?(body, "Pg=1") do
          {:ok, %{status: 200, body: @list_page_html}}
        else
          {:ok, %{status: 200, body: @empty_list_html}}
        end
      end)
      |> expect(:post, fn _url, _body ->
        {:ok, %{status: 200, body: @empty_list_html}}
      end)

      assert :ok = perform_job(SyncWorker, %{"mode" => "list", "max_pages" => 2})

      # Verify judgement was saved
      assert [judgement] = Judgements.list_judgements()
      assert judgement.uzp_id == "12345"
      assert judgement.signature == "KIO 1234/24"
    end

    @tag :capture_log
    test "handles HTTP errors gracefully" do
      Przetargowi.UZP.HTTPClientMock
      |> expect(:post, fn _url, _body ->
        {:error, %Req.TransportError{reason: :timeout}}
      end)

      assert {:error, _} = perform_job(SyncWorker, %{"mode" => "list", "max_pages" => 1})
    end
  end

  @content_html """
  <!DOCTYPE html><html><body>
  <p><b>Sygn. akt: KIO 1234/24</b></p>
  <p><b>POSTANOWIENIE</b></p>
  <p>Krajowa Izba Odwoławcza...</p>
  </body></html>
  """

  describe "perform/1 with mode: details" do
    test "fetches details for judgements missing details" do
      # Create a judgement without details
      {:ok, judgement} =
        Judgements.upsert_from_list(%{
          uzp_id: "12345",
          signature: "KIO 1234/24",
          synced_at: DateTime.utc_now()
        })

      assert is_nil(judgement.details_synced_at)

      Przetargowi.UZP.HTTPClientMock
      |> expect(:get, fn url ->
        assert String.contains?(url, "/Home/Details/12345")
        {:ok, %{status: 200, body: @details_page_html}}
      end)
      |> expect(:get, fn url ->
        assert String.contains?(url, "/Home/ContentHtml/12345")
        {:ok, %{status: 200, body: @content_html}}
      end)

      assert :ok = perform_job(SyncWorker, %{"mode" => "details"})

      # Verify details were updated
      updated = Judgements.get_judgement(judgement.id)
      assert updated.chairman == "Jan Kowalski"
      assert updated.contracting_authority == "Gmina Warszawa"
      assert updated.content_html =~ "Sygn. akt: KIO 1234/24"
      assert updated.details_synced_at != nil
    end
  end

  describe "job scheduling" do
    test "job is created with correct queue" do
      job_changeset = SyncWorker.new(%{mode: "full"})

      # Access the changes from the changeset
      assert job_changeset.changes.queue == "uzp_sync"
      assert job_changeset.changes.args == %{mode: "full"}
    end
  end
end
