defmodule AdventOfCode.Day07 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [test_value, inputs] = String.split(line, ":", trim: true)

      inputs = inputs |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      {String.to_integer(test_value), inputs}
    end)
  end

  def test_line(target, [], result), do: result == target

  def test_line(target, [next | rest], result),
    do: test_line(target, rest, result + next) or test_line(target, rest, result * next)

  def test_line_2(target, _rest, result) when result > target, do: false
  def test_line_2(target, [], result), do: result == target

  def test_line_2(target, [next | rest], result),
    do:
      test_line_2(target, rest, result + next) or test_line_2(target, rest, result * next) or
        test_line_2(target, rest, String.to_integer("#{result}#{next}"))

  def part1(args) do
    parse_input(args)
    |> Enum.filter(fn {target, [first | inputs]} -> test_line(target, inputs, first) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part2(args) do
    parse_input(args)
    |> Enum.filter(fn {target, [first | inputs]} -> test_line_2(target, inputs, first) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end
end
