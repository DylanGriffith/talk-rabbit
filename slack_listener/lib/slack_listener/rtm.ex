defmodule SlackListener.Rtm do
  require Logger
  use Slack
  @queue "elixir-rabbitmq-demo.messages"

  def handle_connect(slack, state) do
    Logger.info("Connected as #{slack.me.name}")

    stuff = Smex.connect(CloudfoundryElixir.Credentials.find_by_service_tag("rabbitmq")["uri"] || "amqp://guest:guest@localhost")
    {:ok, connection} = stuff
    {:ok, channel} = Smex.open(connection)

    {:ok, %{channel: channel}}
  end

  def handle_message(message = %{type: "message", text: text}, slack, state = %{channel: channel}) do
    Logger.info("Received message: #{text}")

    message = PB.Message.new(body: text)
    :ok = Smex.publish(channel, message, destination: @queue)

    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end
end
