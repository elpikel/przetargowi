defmodule PrzetargowiWeb.PageControllerTest do
  use PrzetargowiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Znajdź orzeczenie"
  end
end
