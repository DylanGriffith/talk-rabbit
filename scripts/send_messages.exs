rabbit_url = System.get_env("RABBITMQ_URL") || "amqp://guest:guest@localhost"
{:ok, connection} = Smex.connect(rabbit_url)
{:ok, channel} = Smex.open(connection)
message = %PB.Message{body: "Climb leg rub face on everything give attitude nap all day for under the bed. Chase mice attack feet but rub face on everything hopped up on goofballs. Ipsum available at Cat ipsum Featuring Tuna ipsum European minnow priapumfish mosshead warbonnet shrimpfish bigscale. Cutlassfish"}
:ok = Smex.publish(channel, message, destination: "elixir-rabbitmq-demo.messages")

message = %PB.Message{body: "Special cloth alert. Always remember in the jungle there's a lot of they in"}
:ok = Smex.publish(channel, message, destination: "elixir-rabbitmq-demo.messages")
