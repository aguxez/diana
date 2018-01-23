defmodule ConnState.Conn do
  @moduledoc false

  use GenServer

  # API
  def start_link(_) do
    initial = %{id: [], conn: [], access: [], refresh: []}
    GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def save_conn(conn) do
    GenServer.cast(__MODULE__, {:save_conn, conn})
  end

  def save_tokens(access, refresh) do
    GenServer.cast(__MODULE__, {:save_tokens, access, refresh})
  end

  def save_id(id) do
    GenServer.cast(__MODULE__, {:save_id, id})
  end

  def get_conn do
    GenServer.call(__MODULE__, :get_conn)
  end

  def get_id do
    GenServer.call(__MODULE__, :get_id)
  end

  def get_tokens do
    GenServer.call(__MODULE__, :get_tokens)
  end

  # Server
  def init(state) do
    {:ok, state}
  end

  def handle_cast({:save_conn, conn}, state) do
    {:noreply, Map.put(state, :conn, conn)}
  end

  def handle_cast({:save_tokens, access, refresh}, state) do
    tokens = %{access: access, refresh: refresh}

    {:noreply, Map.merge(state, tokens)}
  end

  def handle_cast({:save_id, id}, state) do
    {:noreply, Map.put(state, :id, id)}
  end

  def handle_call(:get_id, _from, state) do
    {:reply, state.id, state}
  end

  def handle_call(:get_conn, _from, state) do
    {:reply, state.conn, state}
  end

  def handle_call(:get_tokens, _from, state) do
    tokens = %{access: state.access, refresh: state.refresh}

    {:reply, tokens, state}
  end
end
