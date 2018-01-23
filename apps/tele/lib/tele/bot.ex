defmodule Tele.Bot do
  @moduledoc false

  alias Nadia.Model.{Message}
  alias Tele.Handlers.{Commands}

  def handle_message(%Message{text: text} = msg) do
    Commands.inspect(text, msg)
  end

  def handle_message(_), do: :ok
end
