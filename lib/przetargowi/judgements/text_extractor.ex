defmodule Przetargowi.Judgements.TextExtractor do
  @moduledoc """
  Extracts key sections from judgement document content.

  The most important section in KIO judgements is the deliberation
  (uzasadnienie), which starts with phrases like:
  - "Krajowa Izba Odwoławcza zważyła, co następuje"
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
    # Parse HTML to plain text
    text =
      case Floki.parse_document(content_html) do
        {:ok, document} -> Floki.text(document)
        _ -> content_html
      end

    # Find deliberation marker
    case find_deliberation_start(text) do
      nil -> nil
      {start_pos, marker_length} ->
        # Extract from marker to end
        text
        |> String.slice((start_pos + marker_length)..-1//1)
        |> String.trim()
        |> clean_deliberation_text()
    end
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

  # Marker patterns for deliberation section
  # Using flexible patterns to handle encoding variations
  @deliberation_markers [
    # Full formal marker
    ~r/krajowa\s+izba\s+odwo[łl]awcza\s+zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje/iu,
    # Shorter variants
    ~r/izba\s+ustali[łl]a\s+i\s+zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje/iu,
    ~r/izba\s+zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje/iu,
    # Even shorter
    ~r/zwa[żz]y[łl]a,?\s+co\s+nast[ęe]puje/iu
  ]

  defp find_deliberation_start(text) do
    text_lower = String.downcase(text)

    Enum.find_value(@deliberation_markers, fn pattern ->
      case Regex.run(pattern, text_lower, return: :index) do
        [{start, length}] -> {start, length}
        _ -> nil
      end
    end)
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
