defmodule TalkRabbitFrontend.Endpoint do
  use Phoenix.Endpoint, otp_app: :talk_rabbit_frontend

  socket "/socket", TalkRabbitFrontend.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :talk_rabbit_frontend, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_talk_rabbit_frontend_key",
    signing_salt: "XAgcIF0t"

  plug TalkRabbitFrontend.Router

  def ws_base_url do
    scheme = Application.get_env(:talk_rabbit_frontend, TalkRabbitFrontend.Endpoint)[:websocket][:scheme]
    port = Application.get_env(:talk_rabbit_frontend, TalkRabbitFrontend.Endpoint)[:websocket][:port]
    host = Application.get_env(:talk_rabbit_frontend, TalkRabbitFrontend.Endpoint)[:url][:host]
    "#{scheme}://#{host}:#{port}"
  end
end
