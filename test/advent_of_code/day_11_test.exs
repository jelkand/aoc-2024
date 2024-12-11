defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "part1" do
    input = "125 17"
    result = part1(input)

    assert result == 55312
  end

  test "part2" do
    input = "125 17"
    result = part2(input)

    assert result == 65_601_038_650_482
  end
end
