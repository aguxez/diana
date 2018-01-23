defmodule ConnState.Interfaces.Conn do
  @moduledoc false

  alias ConnState.Conn

  defdelegate save_conn(conn),    to: Conn
  defdelegate save_id(id),        to: Conn
  defdelegate save_tokens(a, b),  to: Conn
  defdelegate get_conn,           to: Conn
  defdelegate get_id,             to: Conn
  defdelegate get_tokens,         to: Conn
end
