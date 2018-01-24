defmodule Messenger.Handlers.Lyrics do
  @moduledoc false

  alias Genius.Interfaces.GeniusLyrics
  alias Messenger.Handlers.{Convenience}

  def get(conn, user_id) do
    # Genius is another umbrella app just wrapping the lyrics endpoint
    # and scrapping from their website.
    {_, track_name, artist} = Convenience.get_curr_track_info(conn)
    query = URI.encode("#{track_name} #{artist}")

    GeniusLyrics.get(query, user_id)

    # Send function is on GeniusLyrics module.
  end
end
