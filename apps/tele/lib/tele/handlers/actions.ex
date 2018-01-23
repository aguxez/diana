defmodule Tele.Handlers.Actions do
  @moduledoc false

  # TODO: Add Keyboard functionality to this.
  # TODO: Test initializing 'Playlist' from Supervision tree
  # TODO: See if I can start 'Playlist' only once.

  alias Nadia.Model.{Message, Chat}
  alias ConnState.Interfaces.{Conn, Playlist}
  alias Spotify.Player

  @user "aguxez"

  def start(%Message{chat: %Chat{id: user_id}}) do
    placeholder_url = "http://localhost:4000/authorize"
    Conn.save_id(user_id)

    msg =
      """
      Your account has been initialized, please go to #{placeholder_url} to \
      give Diana access to your Spotify account
      """

    Nadia.send_message(user_id, msg)
  end

  def currently(conn, %Message{chat: %Chat{id: user_id}}) do
    msg = do_currently(conn, :send_msg)

    Nadia.send_message(user_id, msg)
  end

  # Two functions, one is used when sending a message to the chat is needed
  # and the other one when only saving the current song is needed.
  defp do_currently(conn, :send_msg) do
    Playlist.start_link()

    {:ok, track} = Player.currently_playing(conn)
    track_name = track["item"]["name"]
    artist = List.first(track["item"]["artists"])["name"]
    track_id = track["item"]["id"]

    case track["is_playing"] do
      true ->
        """
        #{track_name} by #{artist}\'s ID is #{track_id}
        """
      _ ->
        """
        #{track_name} by #{artist} is not currently playing but here is the ID \
        #{track_id}
        """
    end
  end

  defp do_currently(conn, :cache) do
    {:ok, track} = Player.currently_playing(conn)

    Playlist.save_uri(track["item"]["uri"])
  end

  def add(conn, playlist, %Message{chat: %Chat{id: user_id}}) do
    Playlist.start_link()

    {name, id} = Playlist.find_playlist(playlist)
    uri = Playlist.get_uri()

    msg =
      case Spotify.Playlist.add_tracks(conn, @user, id, uris: uri) do
        {:ok, _} ->
          """
          Song added to playlist - #{name}
          """
        _ ->
          """
          There was an error adding the song to your playlist - #{name}
          """
      end

    Nadia.send_message(user_id, msg)
  end
end
