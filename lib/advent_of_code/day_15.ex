defmodule AdventOfCode.Day15 do
  alias AdventOfCode.Helpers

  def parse_input(input) do
    [str_map, str_moves] = String.split(input, "\n\n", trim: true)

    map =
      String.split(str_map, "\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Helpers.matrix_to_point_map()

    moves =
      String.split(str_moves, "\n", trim: true) |> Enum.join() |> String.split("", trim: true)

    robot = Enum.find(map, fn {_k, v} -> v == "@" end) |> elem(0)

    {Map.put(map, robot, "."), moves, robot}
  end

  def process_moves({map, moves, robot}) do
    process_next_move(map, moves, robot)
  end

  def process_next_move(map, [], _robot), do: map

  def process_next_move(map, [next_move | rest_moves], robot) do
    step =
      case next_move do
        "<" -> {0, -1}
        "^" -> {-1, 0}
        ">" -> {0, 1}
        "v" -> {1, 0}
      end

    to_move = collect_moves(map, robot, step, [])

    case to_move do
      :no_moves ->
        process_next_move(map, rest_moves, robot)

      [] ->
        process_next_move(map, rest_moves, add_pos(robot, step))

      boulder_list ->
        # shuffle every boulder over one. This is a bit inefficient because i could just swap the last one to the end
        # but i want this to just work right now
        Enum.reduce(boulder_list, map, fn pos, acc ->
          new_pos = add_pos(pos, step)

          Map.put(acc, new_pos, "O")
          |> Map.put(pos, ".")
        end)
        |> process_next_move(rest_moves, add_pos(robot, step))
    end
  end

  def collect_moves(map, pos, step, acc) do
    next = add_pos(pos, step)

    case Map.get(map, next) do
      "." -> acc
      "O" -> collect_moves(map, next, step, [next | acc])
      "#" -> :no_moves
    end
  end

  def add_pos({r, c}, {s_r, s_c}), do: {r + s_r, c + s_c}

  def print_with_robot(map, robot) do
    Helpers.pretty_print_point_map(Map.put(map, robot, "@"))
    map
  end

  def score(map) do
    Enum.filter(map, fn {_k, v} -> v == "O" end)
    |> Enum.reduce(0, fn {{row, col}, _}, acc -> acc + row * 100 + col end)
  end

  # def process_next_move(map, [next_move | rest_moves], robot) do
  #   case move do
  #     "^" -> handle_move(map, )
  #   end
  # end

  def part1(args) do
    parse_input(args)
    |> process_moves()
    |> then(fn r ->
      Helpers.pretty_print_point_map(r)
      r
    end)
    |> score()

    # |> dbg()
  end

  def part2(_args) do
  end
end
