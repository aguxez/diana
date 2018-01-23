defmodule ConnState.Playlist do
  @moduledoc false

  use GenServer

  alias ConnState.Interfaces.Conn

  @mod __MODULE__
  @user "aguxez"

  # API
  def start_link do
    GenServer.start_link(@mod, %{pl: [], uri: []}, name: @mod)
  end

  def find_playlist(playlist) do
    GenServer.call(@mod, {:find, playlist})
  end

  def get_uri do
    GenServer.call(@mod, :get_uri)
  end

  def save_playlists do
    GenServer.cast(@mod, :save_playlists)
  end

  def save_uri(uri) do
    GenServer.cast(@mod, {:save_uri, uri})
  end

  # Server
  def init(state) do
    {:ok, state}
  end

  def handle_call({:find, playlist}, _from, state) do
    reply = Enum.find(state.pl, fn{k, _v} -> String.contains?(k, playlist) end)

    {:reply, reply, state}
  end

  def handle_call(:get_uri, _from, state) do
    {:reply, state.uri, state}
  end

  def handle_cast(:save_playlists, state) do
    new_state =
      case Conn.get_conn() do
        %Plug.Conn{} = conn ->
          {:ok, playlist} = Spotify.Playlist.get_users_playlists(conn, @user)

          Enum.map(playlist.items, fn x -> {x.name, x.id} end)
        _ ->
          []
      end


    {:noreply, %{state | pl: new_state}}
  end

  def handle_cast({:save_uri, uri}, state) do
    {:noreply, %{state | uri: uri}}
  end
end
