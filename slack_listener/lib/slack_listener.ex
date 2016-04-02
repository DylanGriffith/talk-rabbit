defmodule SlackListener do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(CloudfoundryElixir.WebServer, []),
      worker(SlackListener.Rtm, [System.get_env("SLACK_API_TOKEN"), []]),
    ]

    opts = [strategy: :one_for_one, name: SlackListener.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
