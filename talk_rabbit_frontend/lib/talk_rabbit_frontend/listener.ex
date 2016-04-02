defmodule TalkRabbitFrontend.Listener do
  use GenServer
  use Smex.Agent
  require Logger

  @queue "elixir-rabbitmq-demo.word_counts"

  def start_link(rabbit_url) do
    GenServer.start_link(__MODULE__, rabbit_url)
  end

  def init(rabbit_url) do
    Logger.info("Connecting to #{inspect(rabbit_url)}")
    {:ok, connection} = Smex.connect(rabbit_url)
    {:ok, channel} = Smex.open(connection)

    consumer_tag = Smex.subscribe(channel, queue_name: "elixir-rabbitmq-demo.word_counts")

    {:ok, %{connection: connection, channel: channel, consumer_tag: consumer_tag}}
  end

  def handle_cast({:smex_message, m = %PB.WordCounts{}, meta}, state = %{channel: chan}) do
    Logger.info("Received a PB.Message: #{inspect(m)}")

    data = m.word_counts |> Enum.map(fn(wc) ->
      {wc.word, wc.count}
    end) |> Enum.into(%{})

    TalkRabbitFrontend.Endpoint.broadcast("words:slack", "words", data)

    Smex.ack(chan, meta)

    {:ok, state}
  end
end
