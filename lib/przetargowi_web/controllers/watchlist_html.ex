defmodule PrzetargowiWeb.WatchlistHTML do
  use PrzetargowiWeb, :html

  embed_templates "watchlist_html/*"

  def format_deadline(nil), do: "Brak terminu"

  def format_deadline(datetime) do
    now = DateTime.utc_now()

    case DateTime.compare(datetime, now) do
      :lt ->
        "Zakończony"

      _ ->
        days = DateTime.diff(datetime, now, :day)

        cond do
          days == 0 -> "Dzisiaj"
          days == 1 -> "Jutro"
          days < 7 -> "Za #{days} dni"
          true -> Calendar.strftime(datetime, "%d.%m.%Y")
        end
    end
  end

  def deadline_class(nil), do: "text-base-content/50"

  def deadline_class(datetime) do
    now = DateTime.utc_now()

    case DateTime.compare(datetime, now) do
      :lt -> "text-error"
      _ ->
        days = DateTime.diff(datetime, now, :day)

        cond do
          days <= 1 -> "text-error font-semibold"
          days <= 7 -> "text-warning font-semibold"
          true -> "text-success"
        end
    end
  end

  def truncate(nil, _length), do: ""

  def truncate(string, length) when byte_size(string) <= length, do: string

  def truncate(string, length) do
    String.slice(string, 0, length) <> "..."
  end
end
