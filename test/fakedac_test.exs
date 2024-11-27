defmodule FakedacTest do
  use ExUnit.Case
  doctest Fakedac

  test "greets the world" do
    assert Fakedac.hello() == :world
  end
end
