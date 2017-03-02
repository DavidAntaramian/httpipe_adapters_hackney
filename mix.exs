defmodule HTTPipe.Adapters.Hackney.Mixfile do
  use Mix.Project

  @project_description """
  Hackney-based adapter for HTTPipe
  """

  @source_url "https://github.com/davidantaramian/httpipe_adapters_hackney"
  @version "0.10.0"

  def project do
    [
      app: :httpipe_adapters_hackney,
      name: "HTTPipe Hackney Adapter",
      version: @version,
      elixir: "~> 1.3",
      description: @project_description,
      source_url: @source_url,
      homepage_url: @source_url,
      package: package(),
      deps: deps(),
      docs: docs(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
    ]
  end

  def application do
    [
      applications: [:hackney, :httpipe, :logger]
    ]
  end

  defp docs() do
    [
      source_ref: "v#{@version}",
      main: "README",
      extras: [
        "README.md": [title: "README"]
      ]
    ]
  end

  defp package() do
    [
      name: :httpipe_adapters_hackney,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["David Antaramian"],
      licenses: ["ISC"],
      links: %{
        "GitHub" => @source_url,
        "Documentation" => "https://hexdocs.pm/httpipe_adapters_hackney/readme.html"
      }
    ]
  end

  defp deps do
    [
      {:earmark, "~> 1.0", only: [:dev, :docs]},
      {:ex_doc, "~> 0.13", only: [:dev, :docs]},
      {:hackney, "~> 1.7.0"},
      {:httpipe, "~> 0.9.0"},
    ]
  end
end
