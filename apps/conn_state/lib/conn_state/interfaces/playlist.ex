defmodule ConnState.Interfaces.Playlist do
  @moduledoc false

  alias ConnState.Playlist

  defdelegate start_link,           to: Playlist
  defdelegate save_playlists,       to: Playlist
  defdelegate find_playlist(name),  to: Playlist
  defdelegate save_uri(uri),        to: Playlist
  defdelegate get_uri,              to: Playlist
end
