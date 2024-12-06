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

  def solve_1({obstacles, start, size}) do
    solve_1_internal(start, [], obstacles, size, :up)
  end

  def solve_1_internal({row, col}, visited, _obstacles, size, _dir)
      when row < 0 or row >= size or col < 0 or col >= size,
      do: visited

  def solve_1_internal(pos, visited, obstacles, size, dir) do
    {next_pos, next_dir} =
      get_next_pos_and_dir(pos, dir, obstacles)

    solve_1_internal(next_pos, [pos | visited], obstacles, size, next_dir)
  end

  def solve_2({obstacles, start, size}) do
    solve_2_internal(start, MapSet.new(), MapSet.new(), obstacles, size, :up)
  end

  def solve_2_internal({row, col}, _visited, potential_obstacles, _obstacles, size, _dir)
      when row < 0 or row >= size or col < 0 or col >= size,
      do: potential_obstacles

  def solve_2_internal(pos, visited, potential_obstacles, obstacles, size, dir) do
    potential_next_pos = get_next_pos(pos, dir)
    potential_next_dir = get_next_dir(dir)

    next_is_obstacle = MapSet.member?(obstacles, potential_next_pos)

    obstacle_could_start_cycle =
      !next_is_obstacle and
        check_cycle(pos, visited, MapSet.put(obstacles, potential_next_pos), size, dir)

    next_potential_obstacles =
      case obstacle_could_start_cycle do
        true -> MapSet.put(potential_obstacles, potential_next_pos)
        false -> potential_obstacles
      end

    {next_pos, next_dir} =
      case MapSet.member?(obstacles, potential_next_pos) do
        true -> {get_next_pos(pos, potential_next_dir), potential_next_dir}
        false -> {potential_next_pos, dir}
      end

    solve_2_internal(
      next_pos,
      MapSet.put(visited, {pos, dir}),
      next_potential_obstacles,
      obstacles,
      size,
      next_dir
    )
  end

  def check_cycle({row, col}, _visited, _obstacles, size, _dir)
      when row < 0 or row >= size or col < 0 or col >= size do
    false
  end

  def check_cycle(pos, visited, obstacles, size, dir) do
    {next_pos, next_dir} =
      get_next_pos_and_dir(pos, dir, obstacles)

    case MapSet.member?(visited, {next_pos, next_dir}) do
      true ->
        true

      false ->
        check_cycle(
          next_pos,
          MapSet.put(visited, {next_pos, next_dir}),
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
    |> solve_1()
    |> MapSet.new()
    |> MapSet.size()
  end

  def part2(args) do
    {obstacles, robot_start, max_size} =
      inputs =
      parse_input(args)

    # attempt1 = solve_2(inputs) |> IO.inspect()

    attempt2 =
      solve_1(inputs)
      |> Enum.reverse()
      # drop robot start
      |> tl()
      |> Enum.uniq()
      |> Enum.filter(fn spot ->
        check_cycle(robot_start, MapSet.new(), MapSet.put(obstacles, spot), max_size, :up)
      end)
      # |> dbg()
      |> length()

    # |> MapSet.new()

    # |> IO.inspect(label: "new obstacles")
    # |> length()

    # |> MapSet.new()

    # diff = MapSet.difference(attempt1, attempt2) |> dbg() |> MapSet.size()

    # |> length()

    # |> MapSet.size()
    # 
    # greater than 1650, less than 1747
  end
end
