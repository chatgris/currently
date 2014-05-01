defmodule Currently.Mixfile do
  use Mix.Project

  def project do
    [ app: :currently,
      version: "0.0.3",
      elixir: "~> 0.13",
      escript_main_module: Currently,
      escript_embed_elixir: true,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:httpotion]]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      {:httpotion, github: "myfreeweb/httpotion"},
      {:jsex,      github: "talentdeficit/jsex", branch: "develop" },
    ]
  end
end
