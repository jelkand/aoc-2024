defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @input """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  test "part1" do
    result = part1(@input)

    assert result == 11
  end

  test "part2" do
    result = part2(@input)

    assert result == 31
  end
end
