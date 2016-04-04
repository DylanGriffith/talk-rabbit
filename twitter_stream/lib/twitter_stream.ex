defmodule TwitterStream do
  def run_for(keyword, time) do
    ExTwitter.configure(
    consumer_key: System.get_env("TWITTER_CLIENT_ID"),
    consumer_secret: System.get_env("TWITTER_CLIENT_SECRET"),
    access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
    access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
    )

    {:ok, connection} = Smex.connect(System.get_env("RABBITMQ_URL") || "amqp://guest:guest@localhost")
    {:ok, channel} = Smex.open(connection)

    pid = spawn(fn ->
      stream = ExTwitter.stream_filter(track: keyword)
      for tweet <- stream do
        IO.puts(tweet.text)
        message = %PB.Message{body: tweet.text}
        :ok = Smex.publish(channel, message, destination: "elixir-rabbitmq-demo.messages")
      end
    end)

    :timer.sleep(time)
    ExTwitter.stream_control(pid, :stop)
  end
end
