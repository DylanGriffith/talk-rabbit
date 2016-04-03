defmodule MessageProcessor.Count do
  def count(text) do
    text
    |> String.downcase
    |> split_words
    |> count_words
    |> to_pb
  end

  defp to_pb(word_tuples) do
    word_tuples |> Enum.map fn({word, count}) -> %PB.WordCount{word: word, count: count} end
  end

  defp count_words(word_list) do
    Enum.reduce word_list, %{}, &reducer/2
  end

  defp reducer([word], census) do
    Dict.update census, word, 1, &(&1 + 1)
  end

  defp split_words(text) do
    Regex.scan ~r/(*UTF)[\p{L}0-9-]+/i, text
  end
end
