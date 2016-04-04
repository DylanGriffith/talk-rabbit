defmodule TalkRabbitFrontend.WordsChannelTest do
  use ExUnit.Case

  test "#normalize" do
    words = %{
      hello: 100,
      world: 50,
      other: 30,
    }

    assert TalkRabbitFrontend.WordsChannel.normalize(words) == %{
      hello: 1,
      world: 0.5,
      other: 0.3
    }
  end
end
