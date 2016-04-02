defmodule TalkRabbitFrontend.Mixfile do
  use Mix.Project

  def project do
    [app: :talk_rabbit_frontend,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {TalkRabbitFrontend, []},
      applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext, :smex],
      included_applications: [:murmur, :exprotobuf, :cloudfoundry_elixir],
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:phoenix_html, "~> 2.4"},
     {:smex, github: "DylanGriffith/smex"},
     {:cloudfoundry_elixir, git: "https://github.com/pivotal-sydney/cloudfoundry_elixir"},
     {:exrm, "~> 0.19"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"}]
  end
end
