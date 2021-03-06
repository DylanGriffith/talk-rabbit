footer: github.com/DylanGriffith
slidenumbers: true

# Yo!

---

# So Hot Right Now
- Elixir
- Slack

---

# Audience Participation
Later!

# dylans-demos.slack.com
`elixir.is.cool@gmail.com`
`elixir123`

---

# Also Hot (Right Now?)
- RabbitMQ
- Protocol Buffers

---

# RabbitMQ
- "Robust messaging for applications"
- Open Source
- Many Languages
- Erlang :heart_eyes_cat:

---

# Protocol Buffers
- "extensible mechanism for serializing structured data"
- Fast
- Map Neatly To Elixir Structs

```protobuf
package PB;

message Message {
  required string body = 1;
}
```

---

# Elixir, RabbitMQ, Protocol Buffers
A match made in heaven!

Now made easy with smex! (inspired by smith)

```elixir
{:ok, connection} = Smex.connect("amqp://guest:guest@localhost")
{:ok, channel} = Smex.open(connection)

message = PB.Message{body: "Hello, World!"}
:ok = Smex.publish(channel, message,
  destination: "smex.test.some_test_queue"
)
```

---

# Match Made In Heaven

- Messages must be ack'ed
- Start as many consumers as you want
- Distribute arbitrarily
- Testing Isolated Components

---

# Slack => RabbitMQ

```elixir
defmodule SlackListener.Rtm do
  use Slack

  def handle_connect(slack, state) do
    {:ok, connection} = Smex.connect("amqp://guest:guest@localhost")
    {:ok, channel} = Smex.open(connection)
    {:ok, %{channel: channel}}
  end

  def handle_message(message = %{type: "message", text: text}, slack, state = %{channel: channel}) do
    message = PB.Message.new(body: text)
    :ok = Smex.publish(channel, message, destination: "elixir-rabbitmq-demo.messages")
    {:ok, state}
  end

  def handle_message _message, _slack, state, do: {:ok, state}
end
```

---

# RabbitMQ => RabbitMQ

```elixir
defmodule MessageProcessor.Listener do
  use GenServer
  use Smex.Agent
  def start_link(rabbit_url) do
    GenServer.start_link(__MODULE__, rabbit_url)
  end
  def init(rabbit_url) do
    {:ok, connection} = Smex.connect(rabbit_url)
    {:ok, channel} = Smex.open(connection)
    consumer_tag = Smex.subscribe(channel, queue_name: "elixir-rabbitmq-demo.messages")
    {:ok, %{connection: connection, channel: channel, consumer_tag: consumer_tag}}
  end
  def handle_cast({:smex_message, m = %PB.Message{body: body}, meta}, state = %{channel: channel}) do
    result = %PB.WordCounts{word_counts: MessageProcessor.Count.count(body)}
    :ok = Smex.publish(channel, result, destination: "elixir-rabbitmq-demo.word_counts")
    Smex.ack(channel, meta)
    {:noreply, state}
  end
end
```

---

# RabbitMQ => Phoenix Channels

```elixir
def handle_cast({:smex_message, m = %PB.WordCounts{}, meta}, state = %{channel: chan}) do
  data = transform_to_map(m)

  TalkRabbitFrontend.Endpoint.broadcast("words", "words", data)

  Smex.ack(chan, meta)

  {:noreply, state}
end
```

---

![fit](architecture.png)

---

# Demo

# dylans-demos.slack.com

```elixir
slack_credentials = %{
  email: "elixir.is.cool@gmail.com",
  password: "elixir123"
}
```

---

# Links
- http://gogolok.github.io/cloudfoundry-buildpack-elixir-website/
- https://github.com/DylanGriffith/talk-rabbit
- https://github.com/DylanGriffith/smex
- https://github.com/filterfish/smith2
