defmodule Tele.Dispatcher do
  @moduledoc false

  alias Tele.Bot

  def dispatch(updates),
    do: Enum.each(updates, &Bot.handle_message(&1.message))
end
