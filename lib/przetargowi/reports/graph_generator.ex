defmodule Przetargowi.Reports.GraphGenerator do
  @moduledoc """
  Generates SVG graphs for tender reports.

  Creates simple but effective bar charts and line charts using SVG.
  All graphs are generated server-side and stored as strings in the database.
  """

  @doc """
  Generates all graphs for a report.

  ## Parameters

    * `report_data` - Map containing statistics and trends data

  ## Returns

  A map containing SVG strings for each graph type.
  """
  def generate_graphs(report_data) do
    %{
      "tender_count_trend" => generate_weekly_trend_chart(report_data["trends"]["weekly_counts"]),
      "value_distribution" =>
        generate_value_distribution_chart(report_data["statistics"]["by_value_range"])
    }
  end

  @doc """
  Generates a weekly trend bar chart showing tender counts per week.
  """
  def generate_weekly_trend_chart(weekly_data)
      when is_list(weekly_data) and length(weekly_data) > 0 do
    max_count = weekly_data |> Enum.map(& &1["count"]) |> Enum.max(fn -> 1 end)
    bar_width = 48
    gap = 12
    chart_height = 180
    top_padding = 30
    bottom_padding = 40

    bars =
      weekly_data
      |> Enum.with_index()
      |> Enum.map_join("\n", fn {data, index} ->
        count = data["count"]
        height = if max_count > 0, do: trunc(count / max_count * chart_height), else: 0
        x = index * (bar_width + gap) + 10
        y = top_padding + chart_height - height

        """
        <rect x="#{x}" y="#{y}" width="#{bar_width}" height="#{height}"
              fill="url(#barGradient)" rx="4"/>
        <text x="#{x + bar_width / 2}" y="#{top_padding + chart_height + 20}"
              text-anchor="middle" font-size="11" fill="#0a1628" font-family="DM Sans, system-ui, sans-serif">Tydz. #{data["week"]}</text>
        <text x="#{x + bar_width / 2}" y="#{y - 8}"
              text-anchor="middle" font-size="13" fill="#12233d" font-weight="700" font-family="Playfair Display, Georgia, serif">#{count}</text>
        """
      end)

    width = length(weekly_data) * (bar_width + gap) + 20

    """
    <svg width="100%" viewBox="0 0 #{width} #{top_padding + chart_height + bottom_padding}" xmlns="http://www.w3.org/2000/svg" style="max-width: #{width}px;">
      <defs>
        <linearGradient id="barGradient" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stop-color="#12233d"/>
          <stop offset="100%" stop-color="#1a3052"/>
        </linearGradient>
      </defs>
      <title>Liczba przetargów w poszczególnych tygodniach</title>
      <line x1="10" y1="#{top_padding + chart_height}" x2="#{width - 10}" y2="#{top_padding + chart_height}"
            stroke="#f3e4c3" stroke-width="1"/>
      #{bars}
    </svg>
    """
  end

  def generate_weekly_trend_chart(_), do: generate_no_data_message("Brak danych tygodniowych")

  @doc """
  Generates a horizontal bar chart showing value distribution.
  """
  def generate_value_distribution_chart(value_ranges)
      when is_list(value_ranges) and length(value_ranges) > 0 do
    max_count = value_ranges |> Enum.map(& &1["count"]) |> Enum.max(fn -> 1 end)
    bar_height = 36
    gap = 12
    chart_width = 300
    label_width = 140
    padding = 20

    # Gold color palette for bars
    colors = ["#c9a227", "#b8922a", "#a7832d", "#967430", "#856533"]

    bars =
      value_ranges
      |> Enum.with_index()
      |> Enum.map_join("\n", fn {data, index} ->
        count = data["count"]
        width = if max_count > 0, do: max(trunc(count / max_count * chart_width), 4), else: 4
        y = padding + index * (bar_height + gap)
        color = Enum.at(colors, rem(index, length(colors)))

        """
        <text x="#{padding}" y="#{y + bar_height / 2 + 5}" font-size="13" fill="#0a1628" font-family="DM Sans, system-ui, sans-serif">#{data["label"]}</text>
        <rect x="#{label_width + padding}" y="#{y}" width="#{width}" height="#{bar_height}"
              fill="#{color}" rx="6"/>
        <text x="#{label_width + padding + width + 10}" y="#{y + bar_height / 2 + 5}"
              font-size="14" fill="#12233d" font-weight="700" font-family="Playfair Display, Georgia, serif">#{count}</text>
        """
      end)

    height = padding * 2 + length(value_ranges) * (bar_height + gap)
    total_width = chart_width + label_width + 80

    """
    <svg width="100%" viewBox="0 0 #{total_width} #{height}" xmlns="http://www.w3.org/2000/svg" style="max-width: #{total_width}px;">
      <title>Rozkład przetargów według wartości</title>
      #{bars}
    </svg>
    """
  end

  def generate_value_distribution_chart(_),
    do: generate_no_data_message("Brak danych o wartościach")

  # Helper function for empty data states
  defp generate_no_data_message(message) do
    """
    <div class="report-no-data">
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 013 19.875v-6.75z" fill="#f3e4c3"/>
        <path d="M9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V8.625z" fill="#f3e4c3"/>
        <path d="M16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V4.125z" fill="#f3e4c3"/>
      </svg>
      <span>#{message}</span>
    </div>
    """
  end
end
