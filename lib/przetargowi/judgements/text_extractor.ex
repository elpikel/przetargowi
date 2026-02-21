defmodule Przetargowi.Judgements.TextExtractor do
  @moduledoc """
  Extracts key sections from judgement document content.

  The most important section in KIO judgements is the deliberation
  (uzasadnienie), which starts with phrases like:
  - "Krajowa Izba Odwoławcza zważyła, co następuje"
  - "Krajowa Izba Odwoławcza ustaliła i zważyła"
  - "Izba ustaliła i zważyła, co następuje"
  - "Izba zważyła, co następuje"
  """

  @doc """
  Extracts the deliberation section from HTML content.

  Returns the text from the deliberation marker to the end of document,
  or nil if marker is not found.
  """
  def extract_deliberation(nil), do: nil

  def extract_deliberation(content_html) when is_binary(content_html) do
    # Parse HTML to plain text, preserving spacing between elements
    text = html_to_text(content_html)

    # Find deliberation marker and extract everything after it
    case find_and_split_at_marker(text) do
      nil -> nil
      deliberation ->
        deliberation
        |> String.trim()
        |> clean_deliberation_text()
    end
  end

  defp html_to_text(html) do
    # Replace br tags with spaces
    html
    |> String.replace(~r/<br\s*\/?>/i, " ")
    |> then(fn h ->
      case Floki.parse_document(h) do
        {:ok, document} -> Floki.text(document, sep: " ")
        _ -> html
      end
    end)
  end

  @doc """
  Extracts a summary (first ~500 chars) from the deliberation.
  """
  def extract_deliberation_summary(nil), do: nil

  def extract_deliberation_summary(deliberation) when is_binary(deliberation) do
    deliberation
    |> String.slice(0, 500)
    |> String.trim()
    |> then(fn text ->
      if String.length(deliberation) > 500 do
        # Try to end at a sentence boundary
        case Regex.run(~r/^(.{300,500}[.!?])\s/, text) do
          [_, sentence] -> sentence <> "..."
          _ -> text <> "..."
        end
      else
        text
      end
    end)
  end

  # Primary marker patterns for deliberation section (specific KIO phrases)
  @primary_markers [
    # Full formal markers with "co następuje"
    ~r/krajowa\s+izba\s+odwo[łl]awcza\s+zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje[:\.]?\s*/iu,
    ~r/izba\s+ustali[łl]a\s+i\s+zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje[:\.]?\s*/iu,
    ~r/izba\s+zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje[:\.]?\s*/iu,
    # Variants with optional "co następuje" (feminine form: ustaliła/zważyła)
    ~r/krajowa\s+izba\s+odwo[łl]awcza\s+ustali[łl]a\s+i\s+zwa[żz]y[łl]a,?\s*(co\s+nast[ęe]puje)?[:\.]?\s*/iu,
    ~r/izba\s+ustali[łl]a\s+i\s+zwa[żz]y[łl]a,?\s*(co\s+nast[ęe]puje)?[:\.]?\s*/iu,
    # "ustaliła, co następuje" without "i zważyła"
    ~r/krajowa\s+izba\s+odwo[łl]awcza\s+ustali[łl]a,?\s+co\s+nast[ęe]puje[:\.]?\s*/iu,
    ~r/izba\s+odwo[łl]awcza\s+ustali[łl]a,?\s+co\s+nast[ęe]puje[:\.]?\s*/iu,
    # Masculine form: ustalił/zważył (e.g. "skład orzekający Izby ustalił i zważył")
    ~r/ustali[łl]\s+i\s+zwa[żz]y[łl],?\s+co\s+nast[ęe]puje[:\.]?\s*/iu,
    # Standalone "ustaliła i zważyła" (without Izba prefix)
    ~r/ustali[łl]a\s+i\s+zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje[:\.]?\s*/iu,
    # "Odwoławcza zważyła" (without "Izba" prefix)
    ~r/odwo[łl]awcza\s+zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje[:\.]?\s*/iu,
    # Standalone "zważyła, co następuje" (when preceded by long preamble)
    ~r/zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje[:\.]?\s*/iu,
    # "Rozważania" variant
    ~r/rozwa[żz]ania\s+krajowej\s+izby\s+odwo[łl]awczej\s*\(?\s*KIO\s*\)?[:\.]?\s*/iu,
    # "Stanowisko Izby" header
    ~r/stanowisko\s+izby[:\.]?\s*/iu
  ]

  # Fallback pattern - only used if primary markers not found
  # Must appear after first 20% of document to avoid matching headers
  @fallback_marker ~r/uzasadnienie[:\.]?\s*/iu

  defp find_and_split_at_marker(text) do
    # First try primary markers
    case find_earliest_match(text, @primary_markers) do
      nil ->
        # Fallback to "Uzasadnienie" but only if it appears after first 20% of text
        try_fallback_marker(text)

      result ->
        result
    end
  end

  defp find_earliest_match(text, patterns) do
    results =
      patterns
      |> Enum.flat_map(fn pattern ->
        case Regex.split(pattern, text, parts: 2) do
          [before, rest] -> [{String.length(before), rest}]
          _ -> []
        end
      end)

    case Enum.min_by(results, fn {pos, _} -> pos end, fn -> nil end) do
      nil -> nil
      {_pos, rest} -> rest
    end
  end

  defp try_fallback_marker(text) do
    min_position = div(String.length(text), 10)  # Must be after first 10%

    case Regex.split(@fallback_marker, text, parts: 2) do
      [before, rest] when byte_size(before) > 0 ->
        if String.length(before) >= min_position do
          rest
        else
          nil
        end

      _ ->
        nil
    end
  end

  defp clean_deliberation_text(text) do
    text
    # Remove excessive whitespace
    |> String.replace(~r/\s+/, " ")
    # Remove common footer patterns
    |> remove_footer_section()
    |> String.trim()
  end

  # Remove signature/footer section if present
  defp remove_footer_section(text) do
    # Common footer markers
    footer_patterns = [
      ~r/przewodnicz[aą]cy:?\s*$/iu,
      ~r/podpis\s+elektroniczny/iu
    ]

    Enum.reduce(footer_patterns, text, fn pattern, acc ->
      half_length = div(String.length(acc), 2)

      case Regex.run(pattern, acc, return: :index) do
        [{pos, _}] when pos > half_length ->
          String.slice(acc, 0, pos)

        _ ->
          acc
      end
    end)
  end
end
