defmodule Genius.GeniusLyrics do
  @moduledoc false

  alias Genius.HTTP

  def get(song) do
    {:ok, %HTTPoison.Response{body: body}} = HTTP.request(song)
    {:ok, body} = Poison.decode(body)
    url = List.first(body["response"]["hits"])["result"]["url"]

    scrape_for_lyrics(url)
  end

  defp scrape_for_lyrics(url) do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)

    # Most likely the text is going to be longer than 2000 characters which is
    # Facebook's limit on text messages.
    body
    |> Floki.find("div.lyrics")
    |> Floki.text()
  end
end
