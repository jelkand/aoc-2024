defmodule AdventOfCode.Day01 do
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

  def transpose(matrix) do
    matrix
    |> Enum.at(0)
    |> Enum.with_index()
    |> Enum.map(fn {_, idx} ->
      Enum.map(matrix, fn row ->
        Enum.at(row, idx)
      end)
    end)
  end

  def part1(args) do
    args
    |> parse_input()
    |> transpose()
    |> Enum.map(&Enum.sort(&1, :asc))
    |> Enum.zip()
    |> Enum.reduce(0, fn {a, b}, acc -> acc + abs(a - b) end)
  end

  def part2(args) do
    [l_list, r_list] =
      args
      |> parse_input()
      |> transpose()

    r_scores =
      r_list
      |> Enum.reduce(%{}, fn key, acc ->
        Map.update(acc, key, 1, fn existing -> existing + 1 end)
      end)

    l_list
    |> Enum.reduce(0, fn key, acc ->
      acc +
        case Map.get(r_scores, key) do
          nil -> 0
          val -> key * val
        end
    end)
  end
end
