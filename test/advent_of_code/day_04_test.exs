defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  @input """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """
  test "part1" do
    result = part1(@input)

    assert result == 18
  end

  test "part2" do
    result = part2(@input)

    assert result == 9
  end
end
