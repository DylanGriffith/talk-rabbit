defmodule MessageProcessor.Mixfile do
  use Mix.Project

  def project do
    [app: :message_processor,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :smex],
     included_applications: [:murmur, :plug, :cowboy, :exprotobuf, :cloudfoundry_elixir, :poison],
     mod: {MessageProcessor, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cloudfoundry_elixir, git: "https://github.com/pivotal-sydney/cloudfoundry_elixir"},
      {:exrm, "~> 0.19"},
      {:smex, github: "DylanGriffith/smex"},
    ]
  end
end
