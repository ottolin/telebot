defmodule Telebot.Mixfile do
  use Mix.Project

  def project do
    [app: :telebot,
     version: "0.1.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     description: "A Telegram bot plugin system for Elixir."
     name: "Telebot"
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
    applications: [:logger, :httpoison],
    mod: {Telebot, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:httpoison, "~>0.7.2"},
      {:poison, "~>1.5"}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ottolin/telebot"},
      contributors: ["Otto Lin"]
    ]
  end
end
