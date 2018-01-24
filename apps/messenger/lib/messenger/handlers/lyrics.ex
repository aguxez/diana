defmodule Messenger.Handlers.Lyrics do
  @moduledoc false

  alias Genius.Interfaces.GeniusLyrics
  alias Messenger.Handlers.{Convenience}
  alias FacebookMessenger.{Sender}

  def get(conn, user_id) do
    # Genius is another umbrella app just wrapping the lyrics endpoint
    # and scrapping from their website.
    {_, track_name, artist} = Convenience.get_curr_track_info(conn)
    query = URI.encode("#{track_name} #{artist}")

    query
    |> GeniusLyrics.get()
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
