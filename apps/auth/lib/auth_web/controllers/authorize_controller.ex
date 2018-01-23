defmodule AuthWeb.AuthorizeController do
  @moduledoc false

  use AuthWeb, :controller

  alias Spotify.Authorization

  def authorize(conn, _params) do
    redirect conn, external: Authorization.url()
  end
end
