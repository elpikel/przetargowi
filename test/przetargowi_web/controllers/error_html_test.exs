defmodule PrzetargowiWeb.ErrorHTMLTest do
  use PrzetargowiWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template, only: [render_to_string: 4]

  test "renders 404.html" do
    html = render_to_string(PrzetargowiWeb.ErrorHTML, "404", "html", [])

    assert html =~ ~s(id="not-found")
    assert html =~ ~s(href="/orzecznictwo-kio")
  end

  test "renders 500.html" do
    assert render_to_string(PrzetargowiWeb.ErrorHTML, "500", "html", []) ==
             "Internal Server Error"
  end
end
