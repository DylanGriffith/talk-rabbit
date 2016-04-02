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
      Map.update(acc, word, 0, fn(current_val) -> current_val + num end)
    end)

    push socket, "words", %{data: d3_format(words)}
    {:noreply, assign(socket, :words, words)}
  end

  defp d3_format(words) do
    Enum.map words, fn({word, count}) ->
      %{text: word, size: 20 + 10*count}
    end
  end
end
