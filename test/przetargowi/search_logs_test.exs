defmodule Przetargowi.SearchLogsTest do
  use Przetargowi.DataCase

  alias Przetargowi.SearchLogs
  alias Przetargowi.SearchLogs.SearchLog

  import Przetargowi.AccountsFixtures

  describe "log_search/1" do
    test "logs a tender search" do
      SearchLogs.log_search(%{
        query: "budowa drogi",
        source: "tenders",
        filters: %{regions: ["mazowieckie"]}
      })

      # Wait for async task
      Process.sleep(100)

      assert [log] = Repo.all(SearchLog)
      assert log.query == "budowa drogi"
      assert log.source == "tenders"
      assert log.filters == %{"regions" => ["mazowieckie"]}
      assert is_nil(log.user_id)
    end

    test "logs a KIO search" do
      SearchLogs.log_search(%{
        query: "odwołanie",
        source: "kio",
        filters: %{document_type: "wyrok"}
      })

      Process.sleep(100)

      assert [log] = Repo.all(SearchLog)
      assert log.query == "odwołanie"
      assert log.source == "kio"
    end

    test "logs a report search" do
      SearchLogs.log_search(%{
        query: "raport roczny",
        source: "reports",
        filters: %{}
      })

      Process.sleep(100)

      assert [log] = Repo.all(SearchLog)
      assert log.query == "raport roczny"
      assert log.source == "reports"
    end

    test "logs search with user_id" do
      user = user_fixture()

      SearchLogs.log_search(%{
        query: "zamówienie",
        source: "tenders",
        filters: %{},
        user_id: user.id
      })

      Process.sleep(100)

      assert [log] = Repo.all(SearchLog)
      assert log.user_id == user.id
    end
  end

  describe "get_user_id/1" do
    test "returns user_id when current_scope is present" do
      user = user_fixture()
      scope = user_scope_fixture(user)
      conn = %Plug.Conn{assigns: %{current_scope: scope}}

      assert SearchLogs.get_user_id(conn) == user.id
    end

    test "returns nil when current_scope is nil" do
      conn = %Plug.Conn{assigns: %{current_scope: nil}}

      assert is_nil(SearchLogs.get_user_id(conn))
    end

    test "returns nil when current_scope is missing" do
      conn = %Plug.Conn{assigns: %{}}

      assert is_nil(SearchLogs.get_user_id(conn))
    end
  end

  describe "SearchLog.changeset/2" do
    test "valid with required fields" do
      changeset = SearchLog.changeset(%{source: "tenders"})
      assert changeset.valid?
    end

    test "valid with all fields" do
      user = user_fixture()

      changeset =
        SearchLog.changeset(%{
          query: "test query",
          source: "kio",
          filters: %{key: "value"},
          user_id: user.id
        })

      assert changeset.valid?
    end

    test "invalid without source" do
      changeset = SearchLog.changeset(%{query: "test"})
      refute changeset.valid?
      assert %{source: ["can't be blank"]} = errors_on(changeset)
    end

    test "invalid with wrong source" do
      changeset = SearchLog.changeset(%{source: "invalid"})
      refute changeset.valid?
      assert %{source: ["is invalid"]} = errors_on(changeset)
    end

    test "valid sources" do
      for source <- ~w(tenders reports kio) do
        changeset = SearchLog.changeset(%{source: source})
        assert changeset.valid?, "Expected #{source} to be valid"
      end
    end
  end
end
