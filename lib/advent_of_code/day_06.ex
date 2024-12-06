defmodule AdventOfCode.Day06 do
  alias AdventOfCode.Helpers

  def parse_input(input) do
    matrix =
      String.split(input, "\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    max_size =
      length(matrix)

    point_map =
      Helpers.matrix_to_point_map(matrix)

    robot_start =
      Enum.find(point_map, fn {_, symbol} -> symbol == "^" end)
      |> elem(0)

    obstacles =
      Enum.filter(point_map, fn {_, symbol} -> symbol == "#" end)
      |> Enum.map(&elem(&1, 0))
      |> MapSet.new()

    {obstacles, robot_start, max_size}
  end

  def get_next_pos_and_dir(pos, dir, obstacles) do
    potential_next_pos = get_next_pos(pos, dir)
    potential_next_dir = get_next_dir(dir)

    case MapSet.member?(obstacles, potential_next_pos) do
      true -> {pos, potential_next_dir}
      false -> {potential_next_pos, dir}
    end
  end

  def traverse({obstacles, start, size}) do
    check_cycle(start, MapSet.new(), obstacles, size, :up)
  end

  def check_cycle({row, col}, visited, _obstacles, size, _dir)
      when row < 0 or row >= size or col < 0 or col >= size do
    visited
  end

  def check_cycle(pos, visited, obstacles, size, dir) do
    {next_pos, next_dir} =
      get_next_pos_and_dir(pos, dir, obstacles)

    case MapSet.member?(visited, {next_pos, next_dir}) do
      true ->
        :cycle

      false ->
        check_cycle(
          next_pos,
          MapSet.put(visited, {pos, dir}),
          obstacles,
          size,
          next_dir
        )
    end
  end

  def get_next_pos({row, col}, dir) do
    case dir do
      :up -> {row - 1, col}
      :down -> {row + 1, col}
      :left -> {row, col - 1}
      :right -> {row, col + 1}
    end
  end

  def get_next_dir(dir) do
    case dir do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end

  def part1(args) do
    parse_input(args)
    |> traverse()
    |> case do
      :cycle -> []
      visited -> Enum.map(visited, &elem(&1, 0))
    end
    |> MapSet.new()
    |> MapSet.size()
  end

  def part2(args) do
    {obstacles, robot_start, max_size} =
      inputs =
      parse_input(args)

    traverse(inputs)
    |> Enum.reverse()
    |> tl()
    |> Enum.uniq()
    |> Enum.map(fn {obstacle, _dir} ->
      Task.async(fn ->
        traverse({MapSet.put(obstacles, obstacle), robot_start, max_size})
        |> case do
          :cycle -> {obstacle, :cycle}
          _ -> {obstacle, :no_cycle}
        end
      end)
    end)
    |> Task.await_many(:infinity)
    |> Enum.uniq()
    |> Enum.filter(&(elem(&1, 1) == :cycle))
    |> length()
  end
end
