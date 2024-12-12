defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @input """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  test "part1" do
    result = part1(@input)

    assert result == 1930
  end

  test "part2" do
    result = part2(@input)

    assert result == 1206
  end
end
