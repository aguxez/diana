defmodule Messenger.Interfaces.Inspector do
  @moduledoc false

  alias Messenger.Inspector

  defdelegate analyze(msg),     to: Inspector
end
