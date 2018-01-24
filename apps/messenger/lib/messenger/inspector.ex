defmodule Messenger.Inspector do
  @moduledoc false

  alias ConnState.Interfaces.{Conn}
  alias FacebookMessenger.{Response}
  alias Messenger.Handlers.{Actions, Lyrics}

  def analyze(%Response{} = msg) do
    text = Response.message_texts(msg)
    sender = Response.message_senders(msg)

    analyze(text, sender)
  end

  # TODO: Rethink 'sender' param, maybe I can move this to a function inside the
  # module and simply pass the whole message tot he functions.
  def analyze("/start", sender),  do: Actions.start(sender)
  def analyze("/curr", sender),   do: Actions.currently(get_conn(), sender)
  def analyze("/lyrics", sender), do: Lyrics.get(get_conn(), sender)
  def analyze(command, sender),   do: pattern_inspect(get_conn(), command, sender)

  defp get_conn, do: Conn.get_conn()

  defp pattern_inspect(conn, command, sender) do
    case String.split(command, " ") do
      ["/add", playlist] -> Actions.add(conn, playlist, sender)
      _                  -> :ok
    end
  end
end
