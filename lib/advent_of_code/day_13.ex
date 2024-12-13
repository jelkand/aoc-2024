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

  # def solve_puzzles(puzzles)
  #   Enum.map()
  # end
  # {{a_x, a_y}, {b_x, b_y}, {t_x, t_y}}
  # 

  def solve_puzzle({{a_x, a_y}, _, {t_x, t_y}}, count, solutions)
      when a_x * count > t_x or a_y * count > t_y,
      do: solutions

  def solve_puzzle({{a_x, a_y}, {b_x, b_y}, {t_x, t_y}} = puzzle, count, solutions) do
    mult_a_x = a_x * count
    mult_a_y = a_y * count

    remainder_x = t_x - mult_a_x
    remainder_y = t_y - mult_a_y

    cond do
      Integer.mod(remainder_x, b_x) == 0 and Integer.mod(remainder_y, b_y) == 0 and
          div(remainder_x, b_x) == div(remainder_y, b_y) ->
        solve_puzzle(puzzle, count + 1, [{count, div(remainder_x, b_x)} | solutions])

      true ->
        solve_puzzle(puzzle, count + 1, solutions)
    end
  end

  def score_solutions([]), do: 0

  def score_solutions(list) do
    Enum.map(list, fn {a, b} -> 3 * a + b end)
    |> Enum.min()
  end

  def part1(args) do
    parse_input(args)
    |> Enum.map(&solve_puzzle(&1, 1, []))
    |> Enum.map(&score_solutions/1)
    |> Enum.sum()
  end

  def part2(_args) do
  end
end
