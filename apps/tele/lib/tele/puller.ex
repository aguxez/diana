defmodule Tele.Puller do
  @moduledoc false

  use GenServer

  alias Tele.Dispatcher

  # API
  def start_link(_),
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def pull_updates(offset \\ -1),
    do: GenServer.cast(__MODULE__, {:pull, offset})

  # Server
  def init(state) do
    pull_updates()
    {:ok, state}
  end

  def handle_cast({:pull, offset}, state) do
    case Nadia.get_updates(offset: offset) do
      {:ok, updates} when length(updates) > 0 ->
        Dispatcher.dispatch(updates)
        :timer.sleep(1000)
        pull_updates(List.last(updates).update_id + 1)
      _ ->
        :timer.sleep(500)
        pull_updates(offset)
    end

    {:noreply, state}
  end
end
