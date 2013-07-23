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

      iex> Currently.CLI.parse_args(["key", "token"])
      {"key", "token"}

  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h: :help]
    )
    case parse do
      {[help: true], _}   -> :help
      {_, [key, token]}   -> {key, token}
      _                   -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: currently <key> <token>
    """
    System.halt(0)
  end

  def process(key, token) do
    Currently.TrelloCards.fetch(key, token)
      |> decode_response
      |> display_cards(["name", "due", "shortUrl"])
  end

  def decode_response({:ok, body}) do
    Jsonex.decode(body)
  end

  def decode_response({:error, msg}) do
    IO.puts "Error fetching from trello: #{msg}"
    System.halt(2)
  end

  def display_cards(cards, fields) do
    Enum.each cards, display_card(&1, fields)
  end

  def display_card(card, fields) do
    IO.puts Enum.map(fields, fn field -> card[field] end)
      |> Enum.join " ,"
  end
end
