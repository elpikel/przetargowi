defmodule Przetargowi.Watchlist.WatchlistReminderEmail do
  @moduledoc """
  Composes watchlist deadline reminder emails.
  """
  import Swoosh.Email

  @doc """
  Composes reminder email with tenders that have upcoming deadlines.
  reminder_type is either :seven_day or :one_day
  """
  def compose(email, entries, reminder_type) do
    subject_text =
      case reminder_type do
        :seven_day -> "Przypomnienie: terminy przetargów za 7 dni"
        :one_day -> "PILNE: terminy przetargów jutro!"
      end

    new()
    |> to({email, email})
    |> from({"Przetargowi", "noreply@przetargowi.pl"})
    |> subject("#{subject_text} - Przetargowi")
    |> html_body(reminder_email_html(entries, reminder_type))
    |> text_body(reminder_email_text(entries, reminder_type))
  end

  defp reminder_email_html(entries, reminder_type) do
    notices_html = Enum.map_join(entries, "\n", &notice_html/1)

    header_text =
      case reminder_type do
        :seven_day -> "Przypomnienie: zbliżające się terminy"
        :one_day -> "PILNE: terminy jutro!"
      end

    intro_text =
      case reminder_type do
        :seven_day ->
          "Poniższe przetargi z Twojej listy obserwowanych mają termin składania ofert za około <strong>7 dni</strong>:"

        :one_day ->
          "Poniższe przetargi z Twojej listy obserwowanych mają termin składania ofert <strong>jutro</strong>:"
      end

    urgency_color =
      case reminder_type do
        :seven_day -> "#c9a227"
        :one_day -> "#dc2626"
      end

    """
    <!DOCTYPE html>
    <html lang="pl">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #0a1628;
            background-color: #fefcf8;
            margin: 0;
            padding: 0;
          }
          .container {
            max-width: 600px;
            margin: 40px auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(10, 22, 40, 0.08);
            overflow: hidden;
          }
          .header {
            background: linear-gradient(135deg, #{urgency_color}, #0a1628);
            color: #fefcf8;
            padding: 32px 40px;
            text-align: center;
          }
          .header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
          }
          .header p {
            margin: 8px 0 0;
            opacity: 0.9;
            font-size: 14px;
          }
          .content {
            padding: 32px 40px;
          }
          .content > p {
            margin: 0 0 24px;
            color: #4a5568;
          }
          .notice {
            border: 1px solid #f3e4c3;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 16px;
            background: #fefcf8;
          }
          .notice:last-child {
            margin-bottom: 0;
          }
          .notice-title {
            font-weight: 600;
            color: #0a1628;
            margin: 0 0 12px;
            font-size: 15px;
            line-height: 1.4;
          }
          .notice-meta {
            font-size: 13px;
            color: #4a5568;
            margin: 0;
          }
          .notice-meta strong {
            color: #1a3052;
          }
          .notice-deadline {
            display: inline-block;
            margin-top: 12px;
            padding: 6px 12px;
            background: #{urgency_color};
            color: white;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
          }
          .notice-value {
            display: inline-block;
            margin-top: 8px;
            margin-left: 8px;
            padding: 6px 12px;
            background: #e8f5e9;
            color: #2e7d32;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
          }
          .notice-link {
            display: inline-block;
            margin-top: 12px;
            color: #1a3052;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
          }
          .notice-link:hover {
            text-decoration: underline;
          }
          .cta-button {
            display: inline-block;
            margin-top: 24px;
            padding: 12px 24px;
            background: #1a3052;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
          }
          .footer {
            background: #fdf8ed;
            padding: 24px 40px;
            text-align: center;
            font-size: 14px;
            color: #4a5568;
          }
          .footer a {
            color: #1a3052;
            text-decoration: none;
          }
          .unsubscribe {
            margin-top: 16px;
            font-size: 12px;
            color: #6b7280;
          }
          .unsubscribe a {
            color: #6b7280;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>Przetargowi</h1>
            <p>#{header_text}</p>
          </div>
          <div class="content">
            <p>#{intro_text}</p>
            #{notices_html}
            <p style="text-align: center;">
              <a href="https://przetargowi.pl/obserwowane" class="cta-button">Zobacz wszystkie obserwowane</a>
            </p>
          </div>
          <div class="footer">
            <p>
              &copy; #{DateTime.utc_now().year} Przetargowi. Wszelkie prawa zastrzeżone.<br />
              <a href="mailto:kontakt@przetargowi.pl">kontakt@przetargowi.pl</a>
            </p>
            <p class="unsubscribe">
              Aby przestać otrzymywać przypomnienia, usuń przetarg z <a href="https://przetargowi.pl/obserwowane">listy obserwowanych</a>.
            </p>
          </div>
        </div>
      </body>
    </html>
    """
  end

  defp notice_html(entry) do
    notice = entry.tender_notice
    deadline = format_date(notice.submitting_offers_date)

    value_html =
      if notice.estimated_value,
        do: ~s(<span class="notice-value">#{format_value(notice.estimated_value)} PLN</span>),
        else: ""

    tender_link = "https://przetargowi.pl/przetargi/#{notice.slug || notice.object_id}"

    """
    <div class="notice">
      <p class="notice-title">#{truncate(notice.order_object, 200)}</p>
      <p class="notice-meta">
        <strong>#{notice.organization_name}</strong><br />
        #{notice.organization_city}
      </p>
      <span class="notice-deadline">Termin: #{deadline}</span>
      #{value_html}
      <br />
      <a href="#{tender_link}" class="notice-link">Zobacz szczegóły →</a>
    </div>
    """
  end

  defp reminder_email_text(entries, reminder_type) do
    notices_text = Enum.map_join(entries, "\n\n---\n\n", &notice_text/1)

    header_text =
      case reminder_type do
        :seven_day -> "Przypomnienie: zbliżające się terminy (7 dni)"
        :one_day -> "PILNE: terminy jutro!"
      end

    """
    PRZETARGOWI
    #{header_text}

    Poniższe przetargi z Twojej listy obserwowanych mają zbliżające się terminy:

    #{notices_text}

    ---

    Zobacz wszystkie obserwowane: https://przetargowi.pl/obserwowane

    ---
    Przetargowi
    kontakt@przetargowi.pl

    Aby przestać otrzymywać przypomnienia, usuń przetarg z listy obserwowanych.
    """
  end

  defp notice_text(entry) do
    notice = entry.tender_notice
    deadline = format_date(notice.submitting_offers_date)

    value_text =
      if notice.estimated_value,
        do: "Wartość: #{format_value(notice.estimated_value)} PLN\n",
        else: ""

    tender_link = "https://przetargowi.pl/przetargi/#{notice.slug || notice.object_id}"

    """
    #{truncate(notice.order_object, 200)}

    Zamawiający: #{notice.organization_name}
    Miejsce: #{notice.organization_city}
    Termin składania ofert: #{deadline}
    #{value_text}
    Link: #{tender_link}
    """
  end

  defp format_date(nil), do: "Brak daty"

  defp format_date(datetime) do
    Calendar.strftime(datetime, "%d.%m.%Y %H:%M")
  end

  defp format_value(nil), do: "-"

  defp format_value(value) do
    value
    |> Decimal.round(2)
    |> Decimal.to_string()
    |> String.replace(~r/(\d)(?=(\d{3})+(?!\d))/, "\\1 ")
  end

  defp truncate(nil, _length), do: ""
  defp truncate(string, length) when byte_size(string) <= length, do: string

  defp truncate(string, length) do
    String.slice(string, 0, length) <> "..."
  end
end
