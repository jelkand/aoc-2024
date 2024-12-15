defmodule AdventOfCode.Day15 do
  alias AdventOfCode.Helpers

  def parse_input(input, expand) do
    [str_map, str_moves] = String.split(input, "\n\n", trim: true)

    map =
      String.split(str_map, "\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> maybe_expand(expand)
      |> Helpers.matrix_to_point_map()

    moves =
      String.split(str_moves, "\n", trim: true) |> Enum.join() |> String.split("", trim: true)

    robot = Enum.find(map, fn {_k, v} -> v == "@" end) |> elem(0)

    {Map.put(map, robot, "."), moves, robot}
  end

  def maybe_expand(matrix, :no_expand), do: matrix

  def maybe_expand(matrix, :expand) do
    Enum.map(matrix, fn row ->
      Enum.flat_map(row, fn val ->
        case val do
          "#" -> ["#", "#"]
          "O" -> ["[", "]"]
          "." -> [".", "."]
          "@" -> ["@", "."]
        end
      end)
    end)
  end

  def process_moves({map, moves, robot}, part \\ :part_1) do
    process_next_move(map, moves, robot, part)
  end

  def process_next_move(map, moves, robot, part \\ :part_1)
  def process_next_move(map, [], _robot, _part), do: map

  def process_next_move(map, [next_move | rest_moves], robot, part) do
    step =
      case next_move do
        "<" -> {0, -1}
        "^" -> {-1, 0}
        ">" -> {0, 1}
        "v" -> {1, 0}
      end

    first_to_check = add_pos(robot, step)
    to_move = collect_moves(map, [first_to_check], step, [], part)

    case to_move do
      :no_moves ->
        process_next_move(map, rest_moves, robot, part)

      [] ->
        process_next_move(map, rest_moves, add_pos(robot, step), part)

      boulder_list ->
        # shuffle every boulder over one. This is a bit inefficient because i could just swap the last one to the end
        # but i want this to just work right now
        Enum.reduce(boulder_list, map, fn pos, acc ->
          current = Map.get(acc, pos)
          new_pos = add_pos(pos, step)

          Map.put(acc, new_pos, current)
          |> Map.put(pos, ".")
        end)
        |> process_next_move(rest_moves, add_pos(robot, step), part)
    end
  end

  def collect_moves(_map, [], _step, acc, _), do: acc

  def collect_moves(map, [to_check | rest_to_check], step, acc, :part_1) do
    case Map.get(map, to_check) do
      "." ->
        acc

      "O" ->
        collect_moves(
          map,
          [add_pos(to_check, step) | rest_to_check],
          step,
          [to_check | acc],
          :part_1
        )

      "#" ->
        :no_moves
    end
  end

  def collect_moves(map, [to_check | rest_to_check], {0, _} = step, acc, :part_2) do
    case Map.get(map, to_check) do
      "." ->
        acc

      "[" ->
        collect_moves(
          map,
          [add_pos(to_check, step) | rest_to_check],
          step,
          [to_check | acc],
          :part_2
        )

      "]" ->
        collect_moves(
          map,
          [add_pos(to_check, step) | rest_to_check],
          step,
          [to_check | acc],
          :part_2
        )

      "#" ->
        :no_moves
    end
  end

  def collect_moves(map, [to_check | rest_to_check], {_, 0} = step, acc, :part_2) do
    next = add_pos(to_check, step)

    case Map.get(map, to_check) do
      "." ->
        collect_moves(map, rest_to_check, step, acc, :part_2)

      "[" ->
        right_pos = add_pos(to_check, {0, 1})
        next_acc = [to_check | acc]
        next_to_check = Enum.uniq([right_pos] ++ rest_to_check ++ [next])

        collect_moves(
          map,
          next_to_check -- next_acc,
          step,
          next_acc,
          :part_2
        )

      "]" ->
        left_pos = add_pos(to_check, {0, -1})
        next_acc = [to_check | acc]
        next_to_check = Enum.uniq([left_pos] ++ rest_to_check ++ [next])

        collect_moves(
          map,
          next_to_check -- next_acc,
          step,
          next_acc,
          :part_2
        )

      "#" ->
        :no_moves
    end
  end

  def add_pos({r, c}, {s_r, s_c}), do: {r + s_r, c + s_c}

  def print_with_robot(map, robot) do
    Helpers.pretty_print_point_map(Map.put(map, robot, "@"))
    map
  end

  def score(map, score_char) do
    Enum.filter(map, fn {_k, v} -> v == score_char end)
    |> Enum.reduce(0, fn {{row, col}, _}, acc -> acc + row * 100 + col end)
  end

  def part1(args) do
    parse_input(args, :no_expand)
    |> process_moves()
    |> score("O")
  end

  def part2(args) do
    parse_input(args, :expand)
    |> process_moves(:part_2)
    |> score("[")
  end
end
