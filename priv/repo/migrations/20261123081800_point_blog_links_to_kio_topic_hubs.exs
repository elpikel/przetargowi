defmodule Przetargowi.Repo.Migrations.PointBlogLinksToKioTopicHubs do
  use Ecto.Migration

  # Blog articles linked to search result URLs (/szukaj?...), which are noindex
  # and pass no value. Point them at the indexable KIO pillar page and topic
  # hubs instead, so the blog feeds internal links to the pages we want ranked.
  @replacements [
    {~s(href="/szukaj?zagadnienie=ra%C5%BC%C4%85co%20niska%20cena" rel="nofollow"),
     ~s(href="/orzecznictwo-kio/razaco-niska-cena")},
    {~s(href="/szukaj?zagadnienie=wyja%C5%9Bnienia%20ra%C5%BC%C4%85co%20niskiej%20ceny" rel="nofollow"),
     ~s(href="/orzecznictwo-kio/razaco-niska-cena")},
    {~s(href="/szukaj?zagadnienie=oferta%20zawieraj%C4%85ca%20ra%C5%BC%C4%85co%20nisk%C4%85%20cen%C4%99" rel="nofollow"),
     ~s(href="/orzecznictwo-kio/razaco-niska-cena")},
    {~s(href="/szukaj?zagadnienie=odrzucenie%20oferty" rel="nofollow"),
     ~s(href="/orzecznictwo-kio/odrzucenie-oferty")},
    {~s(href="/szukaj?q=rażąco+niska+cena+wyjaśnienia"),
     ~s(href="/orzecznictwo-kio/razaco-niska-cena")},
    {~s(href="/szukaj?q=błąd+w+obliczeniu+ceny+VAT"),
     ~s(href="/orzecznictwo-kio/blad-w-obliczeniu-ceny")},
    {~s(href="/szukaj?q=niezgodność+z+treścią+SWZ"),
     ~s(href="/orzecznictwo-kio/niezgodnosc-oferty-z-warunkami-zamowienia")},
    {~s(href="/szukaj?q=wadium+gwarancja+bankowa"), ~s(href="/orzecznictwo-kio/wadium")},
    {~s(href="/szukaj"), ~s(href="/orzecznictwo-kio")}
  ]

  def up do
    for {from, to} <- @replacements do
      execute(fn ->
        repo().query!(
          """
          UPDATE articles
          SET content = replace(content, $1, $2), updated_at = now()
          WHERE position($1 in content) > 0
          """,
          [from, to]
        )
      end)
    end
  end

  # Content rewrite only; the old links were not worth restoring.
  def down, do: :ok
end
