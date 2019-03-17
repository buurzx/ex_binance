defmodule ExBinance.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_binance,
      version: "0.0.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ExBinance.Supervisor, []},
      applications: [:exconstructor, :poison, :httpoison],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 4.0.0"},
      {:exconstructor, "~> 1.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:mock, "~> 0.3.3", only: :test},
      {:exvcr, "~> 0.10.1", only: :test}
    ]
  end

  defp description, do: "Binance API Client for Elixir"

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-capital/ex_binance"}
    ]
  end
end