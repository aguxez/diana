defmodule Messenger.Handlers.Actions do
  @moduledoc false

  # TODO: Eye with implementation here, might remove later.

  alias ConnState.Interfaces.{Conn, Playlist}
  alias Messenger.Handlers.{Convenience}
  alias FacebookMessenger.{Sender}
  alias Spotify.Player

  @user "aguxez"

  def start(user_id) do
    Conn.save_id(user_id)

    Sender.send(user_id, "Cuenta iniciada")
  end

  def currently(conn, user_id) do
    msg = do_currently(conn, :send_msg)

    Sender.send(user_id, msg)
  end

  # Defines if Diana should send a message or simply cache the song URI for
  # future use.
  defp do_currently(conn, :send_msg) do
    Playlist.start_link()

    # Convenience is a module to reuse functions
    {is_playing, track_name, artist} = Convenience.get_curr_track_info(conn)

    case is_playing do
      true ->
        "Playing #{track_name} by #{artist}"
      _ ->
        "#{track_name} by #{artist} is not currently playing"
    end
  end

  defp do_currently(conn, :cache) do
    {:ok, track} = Player.currently_playing(conn)

    Playlist.save_uri(track["item"]["uri"])
  end



  def add(conn, playlist, user_id) do
    Playlist.start_link()

    # Cache uri
    do_currently(conn, :cache)

    {name, id} = Playlist.find_playlist(playlist)
    uri = Playlist.get_uri()

    msg =
      case Spotify.Playlist.add_tracks(conn, @user, id, uris: uri) do
        {:ok, _} -> "Song added to playlist - #{name}"
        _       -> "There was an error adding the song to your playlist - #{name}"
      end

    Sender.send(user_id, msg)
  end
end
