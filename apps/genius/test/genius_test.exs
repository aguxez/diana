defmodule GeniusTest do
  use ExUnit.Case
  doctest Genius

  test "greets the world" do
    assert Genius.hello() == :world
  end
end
