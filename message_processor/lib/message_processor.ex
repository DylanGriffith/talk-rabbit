defmodule MessageProcessor do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    rabbit_url = CloudfoundryElixir.Credentials.find_by_service_tag("rabbitmq")["uri"] || "amqp://guest:guest@localhost"

    children = [
      worker(CloudfoundryElixir.WebServer, []),
      worker(MessageProcessor.Listener, [rabbit_url]),
    ]

    opts = [strategy: :one_for_one, name: MessageProcessor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
