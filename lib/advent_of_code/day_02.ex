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

    (monotonic_increasing or monotonic_decreasing) and within_bounds
  end

  def can_make_safe({line, _safety}) do
    Enum.map(0..(length(line) - 1), fn idx ->
      List.delete_at(line, idx)
      |> compute_line()
      |> test_line()
    end)
    # any true
    |> Enum.any?(& &1)
  end

  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&compute_line/1)
    |> Enum.map(&test_line/1)
    |> Enum.count(& &1)
  end

  def part2(args) do
    {safe, unsafe} =
      args
      |> parse_input()
      |> Enum.map(fn line -> {line, compute_line(line) |> test_line} end)
      |> Enum.split_with(fn {_line, safe} -> safe end)

    can_make_safe = unsafe |> Enum.map(&can_make_safe/1) |> Enum.filter(& &1)

    length(safe) + length(can_make_safe)
  end
end
