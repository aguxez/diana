defmodule Genius.GeniusLyrics do
  @moduledoc false

  alias Genius.HTTP
  alias FacebookMessenger.{Sender}

  def get(song, user_id) do
    {:ok, %HTTPoison.Response{body: body}} = HTTP.request(song)
    {:ok, body} = Poison.decode(body)
    url = List.first(body["response"]["hits"])["result"]["url"]

    scrape_for_lyrics(url, user_id)
  end

  defp scrape_for_lyrics(url, user_id) do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)

    # Most likely the text is going to be longer than 2000 characters which is
    # Facebook's limit on text messages.
    body
    |> Floki.find("div.lyrics")
    |> Floki.text()
    |> split_lyrics(user_id)
  end

  # We'll try to do some kind of 'queue' for this.
  defp split_lyrics(text, user_id) do
    text
    |> Stream.unfold(&String.split_at(&1, 2000))
    |> Enum.take_while(&(&1 != ""))
    |> send_lyrics(user_id)
  end

  # Function to do the recursion
  defp send_lyrics([], _), do: :ok
  defp send_lyrics([head | tail], user_id) do
    :timer.sleep(1000)
    Sender.send(user_id, head)
    send_lyrics(tail, user_id)
  end
end
