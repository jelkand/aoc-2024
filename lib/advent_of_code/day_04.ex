defmodule AdventOfCode.Day04 do
  alias AdventOfCode.Helpers

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def solve1(original) do
    reversed = Enum.map(original, &Enum.reverse/1)
    transposed = Helpers.transpose(original)
    transposed_reversed = Enum.map(transposed, &Enum.reverse/1)

    original_diag = rotate45(original)
    reversed_diag = rotate45(reversed)
    flipped_diag = rotate45(Enum.reverse(original))
    flipped_reversed_diag = rotate45(Enum.reverse(original) |> Enum.map(&Enum.reverse/1))

    [
      original,
      reversed,
      transposed,
      transposed_reversed,
      original_diag,
      reversed_diag,
      flipped_diag,
      flipped_reversed_diag
    ]
    |> Enum.map(&count_version/1)
    |> Enum.sum()
  end

  def count_version(matrix) do
    Enum.map(matrix, &Enum.join/1)
    |> Enum.map(&count_xmas/1)
    |> Enum.sum()
  end

  def count_xmas(str) do
    Regex.scan(~r/XMAS/, str)
    |> List.flatten()
    |> length()
  end

  def rotate45(matrix) do
    size = length(matrix) - 1

    # get all diagonals from top rows
    first =
      Enum.map(0..size, fn col -> {0, col} end)
      |> Enum.map(&extend_diagonal(&1, [], size))
      |> Enum.reverse()

    # start from 1 as 0, 0 is accounted for
    second =
      Enum.map(1..size, fn row -> {row, 0} end)
      |> Enum.map(&extend_diagonal(&1, [], size))

    combined = first ++ second

    # I don't like list access like this in elixir but this is what I've got now...
    Enum.map(combined, fn row ->
      Enum.map(row, fn {row, col} ->
        matrix |> Enum.at(row) |> Enum.at(col)
      end)
    end)
  end

  def extend_diagonal({row, col}, acc, max) when row > max or col > max, do: Enum.reverse(acc)

  def extend_diagonal({row, col}, acc, max),
    do: extend_diagonal({row + 1, col + 1}, [{row, col} | acc], max)

  def trim_array(array), do: Enum.drop(array, 1) |> Enum.drop(-1)

  def find_a_positions(matrix) do
    indexed_matrix =
      Enum.with_index(matrix)
      |> Enum.map(fn {row, row_idx} ->
        Enum.with_index(row)
        |> Enum.map(fn {elem, col_idx} ->
          {elem, {row_idx, col_idx}}
        end)
      end)

    trim_array(indexed_matrix)
    |> Enum.map(&trim_array/1)
    |> List.flatten()
    |> Enum.reduce(0, &check_element(&1, &2, matrix))
  end

  def check_element({"A", {row, col}}, acc, matrix) do
    tl = Enum.at(matrix, row - 1) |> Enum.at(col - 1)
    tr = Enum.at(matrix, row - 1) |> Enum.at(col + 1)
    bl = Enum.at(matrix, row + 1) |> Enum.at(col - 1)
    br = Enum.at(matrix, row + 1) |> Enum.at(col + 1)

    case [tl, tr, br, bl] do
      ["M", "M", "S", "S"] -> acc + 1
      ["S", "M", "M", "S"] -> acc + 1
      ["S", "S", "M", "M"] -> acc + 1
      ["M", "S", "S", "M"] -> acc + 1
      _ -> acc
    end
  end

  def check_element(_, acc, _matrix), do: acc

  def part1(args) do
    args
    |> parse_input()
    |> solve1()
  end

  def part2(args) do
    args
    |> parse_input()
    |> find_a_positions()
  end
end
