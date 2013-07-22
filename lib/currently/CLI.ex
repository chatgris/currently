defmodule Currently.CLI do
  @module_doc """

  Display cards currently assigns to the authenticated user.
  """

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a token provided by trello.

  Return a tuple of `{token}`, or `:help` if help was given.

  ## Examples

      iex> Currently.CLI.parse_args(["-h"])
      :help

      iex> Currently.CLI.parse_args(["-help", "token"])
      :help

      iex> Currently.CLI.parse_args(["token"])
      {"token"}

  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h: :help]
    )
    case parse do
      {[help: true], _}   -> :help
      {_, [token]}        -> {token}
      _                   -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: currently <token>
    """
    System.halt(0)
  end

  def process(token) do
    IO.puts token
  end
end
