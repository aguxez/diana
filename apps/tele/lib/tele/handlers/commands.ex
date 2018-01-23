defmodule Tele.Handlers.Commands do
  @moduledoc false

  alias ConnState.Interfaces.Conn
  alias Tele.Handlers.{Actions}

  def inspect("/start", msg), do: Actions.start(msg)
  def inspect("/curr", msg),  do: Actions.currently(get_conn(), msg)
  def inspect(command, msg),  do: pattern_inspect(get_conn(), command, msg)

  defp get_conn,
    do: Conn.get_conn()

  defp pattern_inspect(conn, command, msg) do
    case String.split(command, " ") do
      ["/add", playlist] -> Actions.add(conn, playlist, msg)
      _                  -> :ok
    end
  end
end
