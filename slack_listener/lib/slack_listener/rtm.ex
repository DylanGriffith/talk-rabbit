defmodule SlackListener.Rtm do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_message(message = %{type: "message", text: text}, slack, state) do
    IO.inspect(text)

    {:ok, state ++ [text]}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end
end
