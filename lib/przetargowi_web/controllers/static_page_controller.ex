defmodule PrzetargowiWeb.StaticPageController do
  use PrzetargowiWeb, :controller

  def about(conn, _params) do
    conn
    |> assign(:page_title, "O nas")
    |> assign(:meta_description, "Przetargowi to wyszukiwarka orzeczeń KIO, SO, SA i SN w sprawach zamówień publicznych.")
    |> assign(:canonical_url, "https://przetargowi.pl/o-nas")
    |> render(:about)
  end

  def contact(conn, _params) do
    conn
    |> assign(:page_title, "Kontakt")
    |> assign(:meta_description, "Skontaktuj się z zespołem Przetargowi. Chętnie odpowiemy na Twoje pytania.")
    |> assign(:canonical_url, "https://przetargowi.pl/kontakt")
    |> render(:contact)
  end

  def terms(conn, _params) do
    conn
    |> assign(:page_title, "Regulamin")
    |> assign(:meta_description, "Regulamin korzystania z serwisu Przetargowi.")
    |> assign(:canonical_url, "https://przetargowi.pl/regulamin")
    |> render(:terms)
  end

  def privacy(conn, _params) do
    conn
    |> assign(:page_title, "Polityka Prywatności")
    |> assign(:meta_description, "Polityka prywatności serwisu Przetargowi. Dowiedz się jak przetwarzamy Twoje dane.")
    |> assign(:canonical_url, "https://przetargowi.pl/polityka-prywatnosci")
    |> render(:privacy)
  end
end
