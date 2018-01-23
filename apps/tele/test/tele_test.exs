defmodule TeleTest do
  use ExUnit.Case
  doctest Tele

  test "greets the world" do
    assert Tele.hello() == :world
  end
end
