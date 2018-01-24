defmodule Genius.Interfaces.GeniusLyrics do
  @moduledoc false

  alias Genius.GeniusLyrics

  defdelegate get(query, user),     to: GeniusLyrics
end
