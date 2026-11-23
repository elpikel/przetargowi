defmodule PrzetargowiWeb.MarketDashboardLiveTest do
  use PrzetargowiWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Przetargowi.Cpv

  defp open_page(conn, path \\ "/analiza-rynku") do
    {:ok, view, _html} = live(conn, path)
    render_async(view)
    view
  end

  defp input_value(view) do
    view
    |> element("#cpv-input")
    |> render()
    |> LazyHTML.from_fragment()
    |> LazyHTML.attribute("value")
  end

  describe "first visit" do
    test "selects the first industry on the list and shows its analysis", %{conn: conn} do
      {_prefix, code, description} = List.first(Cpv.all())

      view = open_page(conn)

      assert input_value(view) == ["#{code} — #{description}"]
      assert has_element?(view, "#dashboard-charts")
      assert has_element?(view, "#analysis-figures")
    end

    test "has no submit button: every change applies on its own", %{conn: conn} do
      view = open_page(conn)

      refute has_element?(view, "#analysis-controls button[type=submit]")
    end

    test "carries a description and FAQ", %{conn: conn} do
      view = open_page(conn)

      assert has_element?(view, "#analysis-overview")
      assert has_element?(view, "#analysis-faq details")
    end
  end

  describe "changing the province" do
    test "refreshes the analysis for the selected industry", %{conn: conn} do
      view = open_page(conn, "/analiza-rynku?cpv=45000000-7")

      view |> form("#province-form") |> render_change(%{province: "PL14"})

      assert_patch(view, "/analiza-rynku?cpv=45000000-7&wojewodztwo=PL14")
      render_async(view)
      assert has_element?(view, "#dashboard-charts")
    end

    test "ignores a province that does not exist", %{conn: conn} do
      view = open_page(conn, "/analiza-rynku?wojewodztwo=XX")

      assert has_element?(view, ~s(#province-select option[selected][value=""]))
    end
  end

  describe "industry picker" do
    test "opening lists every industry, whatever is selected", %{conn: conn} do
      view = open_page(conn, "/analiza-rynku?cpv=45000000-7")

      view |> element("#cpv-combobox") |> render_hook("cpv_open", %{})

      options =
        view
        |> render()
        |> LazyHTML.from_fragment()
        |> LazyHTML.query("#cpv-options [data-cpv-option]")

      assert Enum.count(options) == length(Cpv.all())

      assert has_element?(
               view,
               ~s(#cpv-options [aria-selected="true"][phx-value-code="45000000-7"])
             )
    end

    test "typing filters the list", %{conn: conn} do
      view = open_page(conn)

      view |> element("#cpv-combobox") |> render_hook("cpv_search", %{"query" => "budowlane"})

      assert has_element?(view, ~s(#cpv-options [phx-value-code="45000000-7"]))
      refute has_element?(view, ~s(#cpv-options [phx-value-code="33000000-0"]))
    end

    test "choosing an industry refreshes the analysis and closes the list", %{conn: conn} do
      view = open_page(conn, "/analiza-rynku?wojewodztwo=PL14")

      view |> element("#cpv-combobox") |> render_hook("cpv_open", %{})
      view |> element(~s(#cpv-options [phx-value-code="45000000-7"])) |> render_click()

      assert_patch(view, "/analiza-rynku?cpv=45000000-7&wojewodztwo=PL14")
      render_async(view)

      refute has_element?(view, "#cpv-options")
      assert [label] = input_value(view)
      assert label =~ "45000000-7"
    end

    test "closing without choosing keeps the selection", %{conn: conn} do
      view = open_page(conn, "/analiza-rynku?cpv=45000000-7")

      view |> element("#cpv-combobox") |> render_hook("cpv_open", %{})
      view |> element("#cpv-combobox") |> render_hook("cpv_close", %{})

      refute has_element?(view, "#cpv-options")
      assert [label] = input_value(view)
      assert label =~ "45000000-7"
    end

    test "Enter picks the best match for the typed text", %{conn: conn} do
      view = open_page(conn)

      view |> element("#cpv-combobox") |> render_hook("cpv_enter", %{"query" => "45"})

      assert_patch(view, "/analiza-rynku?cpv=45000000-7")
    end

    test "Enter with nothing matching marks the field as invalid", %{conn: conn} do
      view = open_page(conn)

      view |> element("#cpv-combobox") |> render_hook("cpv_enter", %{"query" => "zzzzzz"})

      assert has_element?(view, "#cpv-input.is-invalid")
      assert has_element?(view, "#cpv-error")
    end
  end

  describe "links from before the redesign" do
    test "a bare numeric prefix still works", %{conn: conn} do
      view = open_page(conn, "/analiza-rynku?cpv=4523")

      assert input_value(view) == ["4523"]
      assert has_element?(view, "#dashboard-charts")
    end

    test "an unrecognisable industry is flagged instead of analysed", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/analiza-rynku?cpv=x")

      assert has_element?(view, "#cpv-input.is-invalid")
      refute has_element?(view, "#dashboard-charts")
    end
  end
end
