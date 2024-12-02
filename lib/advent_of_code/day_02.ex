defmodule AdventOfCode.Day02 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def compute_line(line) do
    line
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> a - b end)
    |> test_line()
  end

  def test_line(line) do
    monotonic = Enum.all?(line, fn x -> x > 0 end) or Enum.all?(line, fn x -> x < 0 end)
    within_bounds = Enum.all?(line, fn x -> abs(x) <= 3 end)
    monotonic and within_bounds
  end

  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&compute_line/1)
    |> Enum.count(& &1)
  end

  def part2(_args) do
  end
end
