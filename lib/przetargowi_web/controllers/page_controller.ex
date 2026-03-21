defmodule PrzetargowiWeb.PageController do
  use PrzetargowiWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(
      :page_title,
      "Wyszukiwarka przetargów i orzeczeń KIO"
    )
    |> assign(
      :meta_description,
      "Przetargowi.pl - wyszukiwarka przetargów publicznych i orzeczeń KIO. Aktualne ogłoszenia o przetargach z BZP, wyroki KIO i orzecznictwo zamówień publicznych."
    )
    |> assign(:canonical_url, "https://przetargowi.pl")
    |> render(:home)
  end
end
