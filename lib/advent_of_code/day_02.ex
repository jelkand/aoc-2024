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
    |> Enum.map(fn [a, b] -> b - a end)
  end

  def test_line(line) do
    monotonic_increasing = Enum.all?(line, fn x -> x > 0 end)
    monotonic_decreasing = Enum.all?(line, fn x -> x < 0 end)

    within_bounds = Enum.all?(line, fn x -> abs(x) <= 3 end)

    {(monotonic_increasing or monotonic_decreasing) and within_bounds, count_errors(line)}
  end

  def count_errors(line) do
    jump_too_large_errors = Enum.count(line, fn x -> abs(x) > 3 end)

    # zeros are neither increasing nor decreasing so need to be handled separately
    zero_errors = Enum.count(line, &(&1 == 0))

    line = Enum.reject(line, &(&1 == 0))
    {ascending, descending} = Enum.split_with(line, fn x -> x > 0 end)

    y = jump_too_large_errors + zero_errors + min(length(ascending), length(descending))

    dbg()
    y
  end

  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&compute_line/1)
    |> Enum.map(&test_line/1)
    |> Enum.count(&elem(&1, 0))
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.map(&compute_line/1)
    |> Enum.map(&test_line/1)
    |> Enum.count(fn line -> elem(line, 1) <= 1 end)
    |> dbg()
  end
end
