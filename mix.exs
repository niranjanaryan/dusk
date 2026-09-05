defmodule Dusk.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/niranjanaryan/dusk"

  def project do
    [
      app: :dusk,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      docs: docs(),
      package: package(),
      description: description(),
      source_url: @source_url,
      homepage_url: "https://hex.pm/packages/dusk",
      name: "Dusk"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Dusk.Application, []}
    ]
  end

  defp deps do
    [
      {:telemetry, "~> 1.0"},
      {:zenohex, "~> 0.10", optional: true},
      {:libcluster, "~> 3.5", optional: true},
      {:ex_doc, "~> 0.38", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Zenoh brokered cluster for Elixir (zenohd). Iroh is ingot; HTTP/3 is gale."
  end

  defp docs do
    [
      main: "Dusk",
      source_url: @source_url,
      extras: ["README.md", "LICENSE", "CHANGELOG.md", "FUNDING.md"]
    ]
  end

  defp aliases do
    [
      test: ["dusk.build", "test"],
      bench: ["dusk.build", "dusk.bench"]
    ]
  end

  defp package do
    [
      name: "dusk",
      maintainers: ["Niranjan Aryan"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Sponsor" => "https://github.com/sponsors/niranjanaryan",
        "Gale" => "https://github.com/niranjanaryan/gale",
        "Ingot" => "https://github.com/niranjanaryan/ingot"
      },
      files:
        ~w(lib native/zig native/rust/src native/rust/Cargo.toml Makefile mix.exs README.md LICENSE CHANGELOG.md FUNDING.md .formatter.exs)
    ]
  end
end
