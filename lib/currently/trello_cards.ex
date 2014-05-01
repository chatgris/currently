defmodule Currently.TrelloCards do
  alias HTTPotion.Response

  @user_agent ["User-agent": "Trello cards"]

  def fetch(key, token) do
    case HTTPotion.get(issues_url(key, token), @user_agent) do
      %Response{body: body, status_code: status, headers: _headers}
      when status in 200..299 ->
        {:ok, body}
      %Response{body: body, status_code: _status, headers: _headers} ->
        {:error, body}
    end
  end

  def board(id, key, token) do
    case HTTPotion.get(board_url(id, key, token), @user_agent) do
      %Response{body: body, status_code: status, headers: _headers}
      when status in 200..299 ->
        {:ok, body}
      %Response{body: body, status_code: _status, headers: _headers} ->
        {:error, body}
    end
  end

  def issues_url(key, token) do
    "https://api.trello.com/1/members/my/cards?token=#{token}&key=#{key}"
  end

  def board_url(id, key, token) do
    "https://api.trello.com/1/boards/#{id}?token=#{token}&key=#{key}"
  end
end
