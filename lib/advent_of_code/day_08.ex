defmodule AdventOfCode.Day08 do
  alias AdventOfCode.Helpers

  def parse_input(input) do
    matrix =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    max_size = length(matrix) - 1

    grouped =
      Helpers.matrix_to_point_map(matrix)
      |> Enum.filter(fn {_pos, val} -> val != "." end)
      |> Enum.group_by(fn {_pos, val} -> val end)

    {max_size, grouped}
  end

  def find_all_antinodes({max_size, grouped}, part) do
    Enum.flat_map(grouped, fn {_val, list} -> find_antinodes_for_val(list, max_size, part) end)
    |> Enum.uniq()
  end

  def find_antinodes_for_val(list, max_size, part) do
    # these are symmetric 
    for {first, _} <- list,
        {second, _} <- list,
        first != second do
      get_antinode(first, second, max_size, part)
    end
    |> List.flatten()
    |> Enum.filter(fn {row, col} ->
      row >= 0 and col >= 0 and row <= max_size and col <= max_size
    end)
  end

  def get_antinode({first_row, first_col}, {second_row, second_col}, _max_size, :one),
    do: {second_row + (second_row - first_row), second_col + (second_col - first_col)}

  def get_antinode({first_row, first_col}, {second_row, second_col}, max_size, :two) do
    {row_step, col_step} = step = {second_row - first_row, second_col - first_col}

    extend(
      [{second_row, second_col}],
      {second_row + row_step, second_col + col_step},
      step,
      max_size
    )
  end

  def extend(acc, {next_row, next_col}, _, max_size)
      when next_row < 0 or next_col < 0 or next_row > max_size or next_col > max_size,
      do: acc

  def extend(acc, {next_row, next_col} = next, {row_step, col_step} = step, max_size),
    do: extend([next | acc], {next_row + row_step, next_col + col_step}, step, max_size)

  def part1(args) do
    parse_input(args)
    |> find_all_antinodes(:one)
    |> length()
  end

  def part2(args) do
    parse_input(args)
    |> find_all_antinodes(:two)
    |> length()
  end
end
