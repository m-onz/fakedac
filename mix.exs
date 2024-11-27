defmodule Fakedac.MixProject do
  use Mix.Project

  def project do
    [
      app: :fakedac,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Fakedac.Application, []}
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.12"},
      {:bandit, "~> 1.0"},
      {:earmark, "~> 1.4"}
    ]
  end

  defp aliases do
    [
      release: ["phx.digest", "release"]
    ]
  end

end
