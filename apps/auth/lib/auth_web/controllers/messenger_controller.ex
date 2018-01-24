defmodule AuthWeb.MessengerController do
  @moduledoc false

  use FacebookMessenger.Phoenix.Controller

  alias Messenger.Interfaces.Inspector

  def message_received(msg), do: Inspector.analyze(msg)

  def challenge_successfull(_), do: :ok
  def challenge_failed(_), do: :ok
end
