defmodule AuthWeb.AuthenticationController do
  @moduledoc false

  use AuthWeb, :controller

  alias ConnState.Interfaces.{Conn, Playlist}
  alias Spotify.Authentication

  def authenticate(conn, params) do
    Playlist.start_link()

    {conn, path, flash} =
      case Authentication.authenticate(conn, params) do
        {:ok, conn} ->
          access_token  = conn.cookies["spotify_access_token"]
          refresh_token = conn.cookies["spotify_refresh_token"]
          conn = put_status(conn, 301)

          Conn.save_conn(conn)
          Conn.save_tokens(access_token, refresh_token)

          Playlist.save_playlists()

          {conn, "/", %{type: :info, msg: "Registered, please go back to Diana"}}
        {:error, _, conn} ->

          {conn, "/", %{type: :error, msg: "Could not register your account!"}}
      end

    conn
    |> put_flash(flash.type, flash.msg)
    |> redirect(to: path)
  end
end
