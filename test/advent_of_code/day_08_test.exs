defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  import AdventOfCode.Day08

  @input """
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  """

  test "part1" do
    result = part1(@input)

    assert result == 14
  end

  test "part2" do
    result = part2(@input)

    assert result == 34
  end
end
