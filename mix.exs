defmodule JorelMix.Mixfile do
  use Mix.Project

  def project do
    [app: :jorel_mix,
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
    [applications: [:logger]]
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
      {:erlydtl, ~r/.*/, git: "https://github.com/erlydtl/erlydtl.git", branch: "master", manager: :make, override: true, compile: "make"},
      {:jorel, ~r/.*/, git: "https://github.com/emedia-project/jorel.git", branch: "master"}
    ]
  end
end
