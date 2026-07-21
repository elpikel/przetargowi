defmodule Przetargowi.Judgements.Summary do
  @moduledoc """
  Builds original, unique-per-ruling content for judgement pages and decides
  whether a page carries enough substance to be worth indexing.

  The public UZP ruling text is duplicated across many sites, so verbatim
  `content_html` adds no unique value in Google's eyes. The `narrative/1`
  synthesis composes the structured fields into human-readable Polish prose
  that exists nowhere else, and `indexable?/1` keeps thin/empty pages out of
  the index so they stop dragging the domain's quality signal down.
  """

  @months {
    "stycznia",
    "lutego",
    "marca",
    "kwietnia",
    "maja",
    "czerwca",
    "lipca",
    "sierpnia",
    "września",
    "października",
    "listopada",
    "grudnia"
  }

  @doc """
  Returns true when the page has enough real content to be worth indexing.

  Empty "content not yet fetched" pages and stubs return false so the
  controller can mark them `noindex`.
  """
  def indexable?(judgement) do
    has_text?(judgement.meritum, 80) or
      has_text?(judgement.deliberation, 160) or
      has_text?(judgement.content_html, 400)
  end

  @doc """
  Builds an original Polish-language summary of the ruling from its structured
  fields. Returns `nil` when there is nothing meaningful to say.
  """
  def narrative(judgement) do
    [
      opening_sentence(judgement),
      procedure_sentence(judgement),
      outcome_sentence(judgement),
      issues_sentence(judgement),
      provisions_sentence(judgement)
    ]
    |> Enum.reject(&is_nil/1)
    |> case do
      [] -> nil
      sentences -> Enum.join(sentences, " ")
    end
  end

  defp opening_sentence(%{signature: signature} = judgement) when is_binary(signature) do
    date_clause =
      case format_date(judgement.decision_date) do
        nil -> ""
        date -> " w dniu #{date}"
      end

    "Orzeczenie o sygnaturze #{signature} zostało wydane przez Krajową Izbę Odwoławczą#{date_clause}."
  end

  defp opening_sentence(_), do: nil

  defp procedure_sentence(judgement) do
    authority = present(judgement.contracting_authority)
    location = present(judgement.location)
    procedure = present(judgement.procedure_type)

    cond do
      authority && procedure && location ->
        "Sprawa dotyczyła postępowania prowadzonego przez #{authority} z siedzibą w #{location} " <>
          "w trybie #{procedure}."

      authority && procedure ->
        "Sprawa dotyczyła postępowania prowadzonego przez #{authority} w trybie #{procedure}."

      authority ->
        "Sprawa dotyczyła postępowania prowadzonego przez #{authority}."

      procedure ->
        "Postępowanie prowadzono w trybie #{procedure}."

      true ->
        nil
    end
  end

  defp outcome_sentence(judgement) do
    case present(judgement.resolution_method) do
      nil -> nil
      method -> outcome_phrase(method)
    end
  end

  defp outcome_phrase("oddalone"), do: "Krajowa Izba Odwoławcza oddaliła odwołanie."
  defp outcome_phrase("uwzględnione"), do: "Krajowa Izba Odwoławcza uwzględniła odwołanie."

  defp outcome_phrase("uwzględnione w części"),
    do: "Krajowa Izba Odwoławcza częściowo uwzględniła odwołanie."

  defp outcome_phrase("odrzucone"), do: "Odwołanie zostało odrzucone."
  defp outcome_phrase("zwrócone"), do: "Odwołanie zostało zwrócone."

  defp outcome_phrase("umorzone" <> _), do: "Postępowanie odwoławcze zostało umorzone."

  defp outcome_phrase(other), do: "Sposób rozstrzygnięcia sprawy: #{other}."

  defp issues_sentence(%{thematic_issues: issues}) when is_list(issues) do
    case Enum.reject(issues, &(&1 in [nil, ""])) do
      [] -> nil
      list -> "Rozstrzygnięcie odnosi się do zagadnień: #{Enum.join(list, ", ")}."
    end
  end

  defp issues_sentence(_), do: nil

  defp provisions_sentence(%{key_provisions: provisions}) when is_list(provisions) do
    case Enum.reject(provisions, &(&1 in [nil, ""])) do
      [] -> nil
      list -> "W orzeczeniu powołano się na przepisy ustawy Pzp: #{Enum.join(list, ", ")}."
    end
  end

  defp provisions_sentence(_), do: nil

  @doc """
  Formats a `Date` as Polish long form, e.g. "12 marca 2024 r.". Returns nil
  for nil.
  """
  def format_date(nil), do: nil

  def format_date(%Date{} = date) do
    "#{date.day} #{elem(@months, date.month - 1)} #{date.year} r."
  end

  defp has_text?(value, min) when is_binary(value),
    do: value |> String.trim() |> String.length() >= min

  defp has_text?(_, _), do: false

  defp present(value) when is_binary(value) do
    case String.trim(value) do
      "" -> nil
      trimmed -> trimmed
    end
  end

  defp present(_), do: nil
end
