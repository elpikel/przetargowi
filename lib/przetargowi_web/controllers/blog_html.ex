defmodule PrzetargowiWeb.BlogHTML do
  @moduledoc """
  This module contains pages rendered by BlogController.
  """
  use PrzetargowiWeb, :html

  embed_templates "blog_html/*"

  @faq_heading ~r/pytani|FAQ/iu

  def format_date(nil), do: ""

  def format_date(%DateTime{} = dt) do
    Calendar.strftime(dt, "%d.%m.%Y")
  end

  @doc """
  Prepares stored article HTML for display.

  Returns a map with:
    * `:html` — the content with an `id` on every `<h2>` so it can be linked
    * `:toc` — `[%{id, title}]` for the table of contents
    * `:faqs` — `[%{question, answer}]` taken from the article's FAQ section
      (an `<h2>` mentioning "pytania"/"FAQ" followed by `<h3>` questions), used
      for FAQPage structured data. Empty when the article has no such section.
  """
  def prepare_content(content) when is_binary(content) do
    case Floki.parse_fragment(content) do
      {:ok, nodes} ->
        {nodes, toc} = add_heading_ids(nodes)
        %{html: Floki.raw_html(nodes), toc: toc, faqs: extract_faqs(nodes)}

      _ ->
        %{html: content, toc: [], faqs: []}
    end
  end

  def prepare_content(_), do: %{html: "", toc: [], faqs: []}

  defp add_heading_ids(nodes) do
    {nodes, {toc, _used}} =
      Enum.map_reduce(nodes, {[], MapSet.new()}, fn
        {"h2", attrs, children} = node, {toc, used} ->
          title = node |> Floki.text() |> String.trim()
          id = unique_id(slugify(title), used)
          attrs = [{"id", id} | List.keydelete(attrs, "id", 0)]
          {{"h2", attrs, children}, {[%{id: id, title: title} | toc], MapSet.put(used, id)}}

        node, acc ->
          {node, acc}
      end)

    {nodes, Enum.reverse(toc)}
  end

  defp unique_id(base, used) do
    if MapSet.member?(used, base), do: unique_id(base <> "-2", used), else: base
  end

  @polish %{
    "ą" => "a",
    "ć" => "c",
    "ę" => "e",
    "ł" => "l",
    "ń" => "n",
    "ó" => "o",
    "ś" => "s",
    "ź" => "z",
    "ż" => "z"
  }

  defp slugify(text) do
    slug =
      text
      |> String.downcase()
      |> String.replace(Map.keys(@polish), &Map.fetch!(@polish, &1))
      |> String.replace(~r/[^a-z0-9]+/, "-")
      |> String.trim("-")

    if slug == "", do: "sekcja", else: slug
  end

  # Walks the top-level nodes: once inside the FAQ section, every <h3> opens a
  # question and the following nodes (up to the next heading) are its answer.
  defp extract_faqs(nodes) do
    {faqs, current, _in_faq?} =
      Enum.reduce(nodes, {[], nil, false}, fn
        {"h2", _, _} = node, {faqs, current, _} ->
          {close(faqs, current), nil, Regex.match?(@faq_heading, Floki.text(node))}

        {"h3", _, _} = node, {faqs, current, true} ->
          {close(faqs, current), %{question: clean(Floki.text(node)), answer: []}, true}

        node, {faqs, %{} = current, true} ->
          {faqs, %{current | answer: [clean(Floki.text(node)) | current.answer]}, true}

        _node, acc ->
          acc
      end)

    faqs |> close(current) |> Enum.reverse()
  end

  defp close(faqs, nil), do: faqs

  defp close(faqs, %{question: question, answer: answer}) do
    text = answer |> Enum.reverse() |> Enum.reject(&(&1 == "")) |> Enum.join(" ")
    if question != "" and text != "", do: [%{question: question, answer: text} | faqs], else: faqs
  end

  defp clean(text), do: text |> String.replace(~r/\s+/u, " ") |> String.trim()
end
