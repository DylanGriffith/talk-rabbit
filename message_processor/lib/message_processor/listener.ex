defmodule MessageProcessor.Listener do
  use GenServer
  use Smex.Agent
  require Logger

  @in_queue "elixir-rabbitmq-demo.messages"
  @out_queue "elixir-rabbitmq-demo.word_counts"

  def start_link(rabbit_url) do
    GenServer.start_link(__MODULE__, rabbit_url)
  end

  def init(rabbit_url) do
    Logger.info("Connecting to #{inspect(rabbit_url)}")
    {:ok, connection} = Smex.connect(rabbit_url)
    {:ok, channel} = Smex.open(connection)

    consumer_tag = Smex.subscribe(channel, queue_name: @in_queue)

    {:ok, %{connection: connection, channel: channel, consumer_tag: consumer_tag}}
  end

  def handle_cast({:smex_message, m = %PB.Message{body: body}, meta}, state = %{channel: channel}) do
    Logger.info("Received a PB.Message: #{inspect(m)}")

    result = %PB.WordCounts{word_counts: MessageProcessor.Count.count(body)}

    :ok = Smex.publish(channel, result, destination: @out_queue)

    Smex.ack(channel, meta)

    {:noreply, state}
  end
end
