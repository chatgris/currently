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

      iex> Currently.CLI.parse_args(["cards", "-key", "key", "-token", "token"])
      {:cards, "key", "token"}

      iex> Currently.CLI.parse_args(["cards", "-k", "key", "-t", "token"])
      {:cards, "key", "token"}

      iex> Currently.CLI.parse_args(["configure", "-key", "trello_key", "-token", "trello_token"])
      {:configure, "trello_key", "trello_token"}

      iex> Currently.CLI.parse_args(["configure", "-k", "trello_key", "-t", "trello_token"])
      {:configure, "trello_key", "trello_token"}

      iex> Currently.CLI.parse_args(["cards"])
      :cards

  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h: :help, k: :key, t: :token]
    )
    case parse do
      {[], ["cards"]}                                      -> :cards
      {[key: key, token: token], [command]}                -> {binary_to_atom(command), key, token}
      _                                                    -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: currently cards
    usage: currently configure -k <key> -t <token>
    usage: currently cards -k <key> -t <token>
    """
    System.halt(0)
  end

  def process(:cards) do
    configuration_file = File.read!(configuration_path)
    [{_, key}, {_, token}] = Jsonex.decode(configuration_file)
    process({:cards, key, token})
  end

  def process({:cards, key, token}) do
    Currently.TrelloCards.fetch(key, token)
      |> decode_response
      |> display_cards(["name", "due", "shortUrl"])
  end

  def process({:configure, key, token}) do
    configuration = Jsonex.encode([key: key, token: token])
    File.write!(configuration_path, configuration)
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

  defp configuration_path do
    "#{Path.expand("~")}/.currently.json"
  end
end
