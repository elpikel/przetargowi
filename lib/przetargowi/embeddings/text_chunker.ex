defmodule Przetargowi.Embeddings.TextChunker do
  @moduledoc """
  Splits text into chunks of approximately target_words words,
  respecting sentence boundaries.
  """

  @default_target_words 200
  @sentence_endings ~r/[.!?]+\s+/u

  @doc """
  Chunks text into segments of approximately target_words words.
  Each chunk respects sentence boundaries when possible.

  Returns a list of {chunk_text, word_count} tuples.
  """
  def chunk_text(nil), do: []
  def chunk_text(""), do: []

  def chunk_text(text, target_words \\ @default_target_words) do
    text
    |> String.trim()
    |> split_into_sentences()
    |> accumulate_chunks(target_words)
    |> Enum.map(fn chunk ->
      content = String.trim(chunk)
      word_count = count_words(content)
      {content, word_count}
    end)
    |> Enum.reject(fn {content, _} -> content == "" end)
  end

  defp split_into_sentences(text) do
    # Split on sentence endings but keep the punctuation with the sentence
    Regex.split(@sentence_endings, text, include_captures: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn
      [sentence, ending] -> sentence <> String.trim(ending)
      [sentence] -> sentence
    end)
    |> Enum.reject(&(&1 == ""))
  end

  defp accumulate_chunks(sentences, target_words) do
    sentences
    |> Enum.reduce({[], "", 0}, fn sentence, {chunks, current_chunk, current_words} ->
      sentence_words = count_words(sentence)

      cond do
        # Empty current chunk - start new one
        current_words == 0 ->
          {chunks, sentence, sentence_words}

        # Adding this sentence would exceed 1.5x target - finish current chunk
        current_words + sentence_words > target_words * 1.5 and current_words >= target_words * 0.5 ->
          {[current_chunk | chunks], sentence, sentence_words}

        # Adding this sentence keeps us under or close to target - add it
        current_words + sentence_words <= target_words * 1.5 ->
          {chunks, current_chunk <> " " <> sentence, current_words + sentence_words}

        # Sentence itself is very long - split it forcefully
        sentence_words > target_words * 2 ->
          split_chunks = split_long_sentence(sentence, target_words)
          case split_chunks do
            [] ->
              {chunks, current_chunk, current_words}

            [first | rest] ->
              new_chunks = Enum.reverse(rest) ++ [current_chunk <> " " <> first | chunks]
              {new_chunks, "", 0}
          end

        # Default - add to current chunk
        true ->
          {chunks, current_chunk <> " " <> sentence, current_words + sentence_words}
      end
    end)
    |> finalize_chunks()
  end

  defp finalize_chunks({chunks, "", _}), do: Enum.reverse(chunks)
  defp finalize_chunks({chunks, last_chunk, _}), do: Enum.reverse([last_chunk | chunks])

  defp split_long_sentence(sentence, target_words) do
    words = String.split(sentence)

    words
    |> Enum.chunk_every(target_words)
    |> Enum.map(&Enum.join(&1, " "))
  end

  defp count_words(text) do
    text
    |> String.split(~r/\s+/, trim: true)
    |> length()
  end
end
