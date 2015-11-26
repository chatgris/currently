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

      iex> Currently.CLI.parse_args(["cards", "--key", "key", "--token", "token"])
      {:cards, "key", "token"}

      iex> Currently.CLI.parse_args(["cards", "-k", "key", "-t", "token"])
      {:cards, "key", "token"}

      iex> Currently.CLI.parse_args(["configure", "--key", "trello_key", "--token", "trello_token"])
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
      {[key: key, token: token], [command], _}             -> {String.to_atom(command), key, token}
      {_, [command], [key: key, token: token]}             -> {String.to_atom(command), key, token}
      {[], ["cards"], _}                                   -> :cards
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
    {:ok, configuration} = JSEX.decode(configuration_file)
    process({:cards, configuration["key"], configuration["token"]})
  end

  def process({:cards, key, token}) do
    Currently.TrelloCards.fetch(key, token)
      |> decode_response
      |> Currently.Renderer.render(key, token)
  end

  def process({:configure, key, token}) do
    configuration = JSEX.encode([key: key, token: token])
    File.write!(configuration_path, configuration)
  end

  defp decode_response({:ok, body}) do
    {:ok, response} = JSEX.decode(body)
    response
  end

  defp decode_response({:error, msg}) do
    IO.puts "Error fetching from trello: #{msg}"
    System.halt(2)
  end

  defp configuration_path do
    "#{Path.expand("~")}/.currently.json"
  end
end
