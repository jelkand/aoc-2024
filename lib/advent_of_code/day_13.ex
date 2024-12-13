defmodule AdventOfCode.Day13 do
  def parse_input(input) do
    String.split(input, "\n\n", trim: true)
    |> Enum.map(&parse_puzzle/1)
  end

  def parse_puzzle(puzzle) do
    String.split(puzzle, "\n", trim: true)
    |> Enum.map(
      &(Regex.run(~r/X[+=](\d+).*Y[+=](\d+)/, &1, capture: :all_but_first)
        |> Enum.map(fn n -> String.to_integer(n) end)
        |> List.to_tuple())
    )
    |> List.to_tuple()
  end

  def solve_puzzle({{a_x, a_y}, {b_x, b_y}, {t_x, t_y}}) do
    raw_count =
      (t_y / b_y - t_x / b_x) / (a_y / b_y - a_x / b_x)

    rounded_count = round(raw_count)

    cond do
      Integer.mod(t_x - a_x * rounded_count, b_x) == 0 and
          Integer.mod(t_y - a_y * rounded_count, b_y) == 0 ->
        b_count = div(t_x - a_x * rounded_count, b_x)

        test_x = a_x * rounded_count + b_x * b_count
        test_y = a_y * rounded_count + b_y * b_count

        case {test_x, test_y} do
          {^t_x, ^t_y} ->
            a_score = 3 * rounded_count
            b_count + a_score

          _ ->
            0
        end

      true ->
        0
    end
  end

  def add_a_bajillion({a, b, {t_x, t_y}}) do
    {a, b, {t_x + 10_000_000_000_000, t_y + 10_000_000_000_000}}
  end

  def part1(args) do
    parse_input(args)
    |> Enum.map(&solve_puzzle/1)
    |> Enum.sum()
  end

  def part2(args) do
    parse_input(args)
    |> Enum.map(&add_a_bajillion/1)
    |> Enum.map(&solve_puzzle/1)
    |> Enum.sum()
  end
end
