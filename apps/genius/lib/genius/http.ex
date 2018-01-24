defmodule Genius.HTTP do
  @moduledoc false

  @endpoint "https://api.genius.com/"

  def request(song) do
    url = @endpoint <> "search?q=" <> song
    headers = ["Authorization": "Bearer #{get_token()}", "Accept": "application/json"]

    HTTPoison.get(url, headers)
  end

  defp get_token, do: Application.fetch_env!(:genius, :token)
end
