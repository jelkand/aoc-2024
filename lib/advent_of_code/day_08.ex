defmodule AdventOfCode.Day08 do
  alias AdventOfCode.Helpers

  def parse_input(input) do
    matrix =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    max_size = length(matrix) - 1
    IO.inspect({length(matrix), length(hd(matrix))})

    grouped =
      Helpers.matrix_to_point_map(matrix)
      |> Enum.filter(fn {_pos, val} -> val != "." end)
      |> Enum.group_by(fn {_pos, val} -> val end)

    {max_size, grouped}
  end

  def find_all_antinodes({max_size, grouped}) do
    Enum.flat_map(grouped, fn {_val, list} -> find_antinodes_for_val(list, max_size) end)
    |> Enum.uniq()
  end

  def find_antinodes_for_val(list, max_size) do
    # these are symmetric 
    for {first, _} <- list,
        {second, _} <- list,
        first != second do
      get_antinode(first, second)
    end
    |> Enum.filter(fn {row, col} ->
      row >= 0 and col >= 0 and row <= max_size and col <= max_size
    end)
  end

  def get_antinode({first_row, first_col}, {second_row, second_col}),
    do: {second_row + (second_row - first_row), second_col + (second_col - first_col)}

  def part1(args) do
    parse_input(args)
    |> find_all_antinodes()
    |> length()
  end

  def part2(_args) do
  end
end
