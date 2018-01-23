defmodule ConnStateTest do
  use ExUnit.Case
  doctest ConnState

  test "greets the world" do
    assert ConnState.hello() == :world
  end
end
