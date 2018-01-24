defmodule Messenger.Handlers.Convenience do
  @moduledoc false

  alias Spotify.Player

  def get_curr_track_info(conn) do
    {:ok, track} = Player.currently_playing(conn)

    track_name = track["item"]["name"]
    is_playing = track["is_playing"]
    artist = List.first(track["item"]["artists"])["name"]

    {is_playing, track_name, artist}
  end
end
