defmodule TalkRabbitFrontend.WordsChannel do
  use Phoenix.Channel

  def join("words:slack", _message, socket) do
    socket = assign(socket, :words, %{})
    {:ok, socket}
  end

  intercept ["words"]

  def handle_out("words", deltas, socket) do
    words = socket.assigns[:words]
    words = deltas |> Enum.reduce(words, fn({word, num}, acc) ->
      Map.update(acc, word, num, fn(current_val) -> current_val + num end)
    end)

    push socket, "words", %{data: d3_format(words)}
    {:noreply, assign(socket, :words, words)}
  end

  def normalize(words) do
    if Enum.count(words) == 0 do
      max = 1
    else
      {_, max} = Enum.max_by(words, fn({word, count}) -> count end)
    end
    Enum.map(words, fn({word, count}) ->
      {word, count / max}
    end) |> Enum.into(%{})
  end

  defp d3_format(words) do
    words |> normalize |> Enum.map(fn({word, count}) ->
      %{text: word, size: 20 + 90*count}
    end)
  end
end
