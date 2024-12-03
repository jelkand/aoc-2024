defmodule AdventOfCode.Day03 do
  def handle_mul(str) do
    [a, b] =
      str
      |> String.slice(4..-2//1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    a * b
  end

  # mode switching
  def solve2("don't()" <> rest, :do_mode, results),
    do: solve2(rest, :dont_mode, results)

  def solve2("do()" <> rest, :dont_mode, results),
    do: solve2(rest, :do_mode, results)

  def solve2("mul(" <> rest, :do_mode, results), do: parse_mul(rest, results)

  def solve2("", _mode, results), do: results
  def solve2(<<_head::size(8), rest::binary>>, mode, results), do: solve2(rest, mode, results)

  def parse_mul(str, results) do
    case Regex.run(~r/^(\d+),(\d+)\)/, str, capture: :all_but_first) do
      nil -> solve2(str, :do_mode, results)
      [a, b] -> solve2(str, :do_mode, results + String.to_integer(a) * String.to_integer(b))
    end
  end

  def part1(args) do
    Regex.scan(~r/mul\(\d+,\d+\)/, args)
    |> List.flatten()
    |> Enum.map(&handle_mul/1)
    |> Enum.sum()
  end

  def part2(args) do
    solve2(args, :do_mode, 0)
  end
end
