defmodule MessageProcessor.CountTest do
  use ExUnit.Case

  test '#count' do
    result = MessageProcessor.Count.count("hello world and stuff hello")
    expected = [
        %PB.WordCount{word: "hello", count: 2},
        %PB.WordCount{word: "world", count: 1},
        %PB.WordCount{word: "and", count: 1},
        %PB.WordCount{word: "stuff", count: 1},
      ]
    assert Enum.sort(result) == Enum.sort(expected)
  end
end
