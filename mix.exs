Code.ensure_loaded?(Hex) and Hex.start

defmodule Currently.Mixfile do
  use Mix.Project

  def project do
    [ app: :currently,
      version: "0.0.3",
      elixir: "~> 0.13",
      escript_main_module: Currently,
      escript_embed_elixir: true,
      description: description,
      package: package,
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

  defp description do
    """
    Currently is a tool to display cards currently assigns on Trello
    """
  end

  defp package do
    [ contributors: ["chatgris"],
      licenses: ["MIT"],
      links: [ { "Github", "https://github.com/chatgris/currently" }]]
  end
end
