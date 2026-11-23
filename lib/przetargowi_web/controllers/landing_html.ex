defmodule PrzetargowiWeb.LandingHTML do
  @moduledoc """
  This module contains pages rendered by LandingController.
  """
  use PrzetargowiWeb, :html

  alias Przetargowi.Judgements.Topics

  embed_templates "landing_html/*"

  def format_date(nil), do: nil
  def format_date(%Date{} = date), do: Calendar.strftime(date, "%d.%m.%Y")

  def topic_path(topic), do: Topics.path(topic)

  def topic_page_path(topic, 1), do: Topics.path(topic)
  def topic_page_path(topic, page), do: "#{Topics.path(topic)}?strona=#{page}"

  @doc "Heading for a ruling in a list, e.g. \"Wyrok KIO 1234/25\"."
  def ruling_heading(%{document_type: type, signature: signature}) when is_binary(type) do
    "#{String.capitalize(type)} #{Przetargowi.Judgements.Judgement.display_signature(signature)}"
  end

  def ruling_heading(%{signature: signature}),
    do: Przetargowi.Judgements.Judgement.display_signature(signature)

  @doc "Appeals decided on the merits (upheld + dismissed) in an outcome summary."
  def merits_count(outcomes) do
    outcomes.groups
    |> Enum.filter(&(&1.key in [:upheld, :dismissed]))
    |> Enum.map(& &1.count)
    |> Enum.sum()
  end

  @doc """
  Rows for the "by year" list that add up to the total: the most recent years,
  then the remaining years as one row, then rulings without a usable date.
  """
  def year_rows(year_counts, total, shown \\ 6) do
    {recent, older} = Enum.split(year_counts, shown)
    older_count = older |> Enum.map(&elem(&1, 1)) |> Enum.sum()
    dated = year_counts |> Enum.map(&elem(&1, 1)) |> Enum.sum()

    Enum.map(recent, fn {year, count} -> {year, nil, count} end) ++
      if(older_count > 0, do: [{"wcześniejsze lata", nil, older_count}], else: []) ++
      if(total > dated, do: [{"bez daty", nil, total - dated}], else: [])
  end

  def excerpt(nil, _length), do: nil

  def excerpt(text, length) do
    if String.length(text) > length do
      String.slice(text, 0, length) <> "…"
    else
      text
    end
  end

  # Outcome colours are categorical, not a verdict: the site serves both
  # contractors and contracting authorities, so "upheld" is not painted as good
  # and "dismissed" as bad. Each group gets a clearly different tone, and the
  # same colour marks the outcome in ruling lists.
  def outcome_bar_class(:upheld), do: "bg-primary"
  def outcome_bar_class(:dismissed), do: "bg-neutral"
  def outcome_bar_class(:discontinued), do: "bg-slate-400"
  def outcome_bar_class(:rejected), do: "bg-amber-500"
  def outcome_bar_class(:returned), do: "bg-teal-500"
  def outcome_bar_class(_), do: "bg-slate-300"

  def outcome_dot_class(resolution_method) do
    resolution_method |> Przetargowi.Judgements.outcome_group() |> outcome_bar_class()
  end

  attr :outcomes, :map, required: true
  attr :id, :string, required: true

  def outcome_stats(assigns) do
    ~H"""
    <div id={@id} class="space-y-3">
      <div :for={group <- @outcomes.groups}>
        <div class="flex items-baseline justify-between text-sm mb-1">
          <span class="text-base-content/80">{group.label}</span>
          <span class="font-semibold text-base-content tabular-nums">
            {group.percent}%
            <span class="font-normal text-base-content/50">({format_count(group.count)})</span>
          </span>
        </div>
        <div class="h-2 rounded-full bg-base-300 overflow-hidden">
          <div
            class={["h-full rounded-full transition-all duration-500", outcome_bar_class(group.key)]}
            style={"width: #{max(group.percent, 1)}%"}
          >
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc "A ruling as a result card. Pass `highlight` to show a matched passage instead of the summary."
  attr :judgement, :map, required: true
  attr :compact, :boolean, default: false
  attr :highlight, :string, default: nil

  def ruling_card(assigns) do
    ~H"""
    <.result_card
      href={"/orzecznictwo-kio/#{@judgement.slug || @judgement.id}"}
      title={ruling_heading(@judgement)}
      cue="Zobacz orzeczenie"
      compact={@compact}
    >
      <:meta>
        <span :if={@judgement.decision_date}>{format_date(@judgement.decision_date)}</span>
        <.tag
          :if={@judgement[:resolution_method]}
          dot={outcome_dot_class(@judgement.resolution_method)}
        >
          {@judgement.resolution_method}
        </.tag>
      </:meta>
      <%= cond do %>
        <% @highlight -> %>
          <p class="text-sm font-medium text-base-content/60 mb-1">Dopasowany fragment</p>
          <p>{excerpt(@highlight, 320)}</p>
        <% @judgement[:meritum] -> %>
          <p class={@compact && "text-sm line-clamp-3"}>
            {excerpt(@judgement.meritum, if(@compact, do: 160, else: 320))}
          </p>
        <% true -> %>
      <% end %>
    </.result_card>
    """
  end

  @browse_groups [
    {"browse-offer", "Oferta i cena",
     ~w(razaco-niska-cena odrzucenie-oferty niezgodnosc-oferty-z-warunkami-zamowienia blad-w-obliczeniu-ceny wyjasnienia-tresci-oferty-i-poprawianie-omylek wadium termin-zwiazania-oferta przedmiotowe-srodki-dowodowe czyn-nieuczciwej-konkurencji)},
    {"browse-contractor", "Wykonawca i warunki zamówienia",
     ~w(wykluczenie-wykonawcy samooczyszczenie warunki-udzialu-w-postepowaniu wezwanie-do-uzupelnienia-dokumentow tajemnica-przedsiebiorstwa konsorcjum-i-zasoby-podmiotu-trzeciego opis-przedmiotu-zamowienia kryteria-oceny-ofert postanowienia-umowy zasady-udzielania-zamowien)}
  ]

  @doc """
  Columns for the "browse case law" block: every topic hub, grouped. Topics
  not named in a group fall into the last column, so a newly added topic is
  never left out.
  """
  def browse_columns do
    grouped = Enum.flat_map(@browse_groups, fn {_id, _title, slugs} -> slugs end)

    columns =
      for {id, title, slugs} <- @browse_groups do
        topics = slugs |> Enum.map(&Topics.get/1) |> Enum.reject(&is_nil/1)
        %{id: id, title: title, links: Enum.map(topics, &{Topics.path(&1), &1.name})}
      end

    rest = Enum.reject(Topics.all(), &(&1.slug in grouped))

    columns ++
      [
        %{
          id: "browse-appeal",
          title: "Wybór oferty i odwołanie",
          links:
            Enum.map(rest, &{Topics.path(&1), &1.name}) ++
              [
                {"/orzecznictwo-kio/statystyki", "Statystyki KIO"},
                {"/orzecznictwo-kio", "Wszystkie zagadnienia"}
              ]
        }
      ]
  end
end
