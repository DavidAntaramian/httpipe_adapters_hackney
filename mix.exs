defmodule HTTPlaster.Adapters.Hackney.Mixfile do
  use Mix.Project

  def project do
    [
      app: :httplaster_adapters_hackney,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:hackney, :logger]
    ]
  end

  defp deps do
    [
      {:hackney, "~> 1.6.0"},
      {:httplaster, git: "git@github.com:DavidAntaramian/httplaster.git"}
    ]
  end
end
