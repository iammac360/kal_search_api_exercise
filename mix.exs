defmodule SearchApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :search_api,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy, :plug, :httpoison, :cachex],
      mod: {SearchApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0", override: true},
      {:poison, "~> 3.1"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:cachex, "~> 2.1"},
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false},
      {:exvcr, git: "https://github.com/parroty/exvcr.git", tag: "v0.10.0", only: :test}
    ]
  end
end
