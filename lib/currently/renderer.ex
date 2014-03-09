defmodule Currently.Renderer do
  def render(cards, key, token) do
    cards
      |> filter_by_boards
      |> get_board_name(key, token)
      |> display_boards
  end

  defp filter_by_boards(cards) do
  Enum.reduce(cards, HashDict.new, fn(card, cards)-> add_card_to_board(card, cards[card["idBoard"]], cards)end)
  end

  defp add_card_to_board(card, nil, cards) do
    HashDict.put(cards, card["idBoard"], [card])
  end

  defp add_card_to_board(card, board, cards) do
    HashDict.put(cards, card["idBoard"], [card | board])
  end

  defp get_board_name(boards, key, token) do
    Parallel.pmap(boards, fn(board) -> rename_board(board, key, token) end)
  end

  defp rename_board(board, key, token) do
    {id, cards} = board
    {:ok, board} = Currently.TrelloCards.board(id, key, token)
    board_name = Jsonex.decode(board)["name"]
    {board_name, cards}
  end

  defp display_boards(boards) do
    Enum.each boards, &display_board(&1)
  end

  defp display_board(board) do
    board
      |> colorize_board
      |> display_cards([{:cyan, "name"}, {:magenta, "due"}, {:white, "shortUrl"}])
  end

  defp display_cards({_board_name, cards}, fields) do
    Enum.each cards, &display_card(&1, fields)
  end

  defp compact(fields) do
    "    " <> Enum.join(fields, ", ")
  end

  defp display_card(card, fields) do
    Enum.map(fields, &colorize(&1, card))
      |> compact
      |> IO.ANSI.escape(true)
      |> IO.puts
  end

  defp colorize({color, field}, card) do
    "%{#{color}}#{card[field]}"
  end

  defp colorize_board({board_name, cards}) do
    "%{green} #{board_name}"
      |> IO.ANSI.escape(true)
      |> IO.puts
    {board_name, cards}
  end
end

defmodule Parallel do
  def pmap(collection, fun) do
    me = self

    collection
      |> Enum.map(fn (elem) -> spawn_link fn -> (send me, { self, fun.(elem)}) end end)
      |> Enum.map(fn (pid) -> receive do { ^pid, result } -> result end end)
  end
end
