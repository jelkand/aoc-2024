defmodule AdventOfCode.Day10 do
  alias AdventOfCode.Helpers

  def parse_input(input) do
    matrix =
      String.split(input, "\n", trim: true)
      |> Enum.map(
        &(String.split(&1, "", trim: true)
          |> Enum.map(fn str -> String.to_integer(str) end))
      )

    {Helpers.matrix_to_point_map(matrix), length(matrix)}
  end

  def find_score_trailheads({point_map, size}) do
    potential_trailheads = Enum.filter(point_map, fn {_k, v} -> v == 0 end)

    Enum.map(potential_trailheads, &score_trailhead(&1, point_map, size))
  end

  def score_trailhead({pt, 9}, _, _), do: [{pt, 9}]

  def score_trailhead({{row, col}, elev}, map, size) do
    for r_diff <- -1..1,
        c_diff <- -1..1,
        abs(r_diff) != abs(c_diff) do
      {row + r_diff, col + c_diff}
    end
    |> Enum.filter(fn {r, c} -> r >= 0 and c >= 0 and r < size and c < size end)
    |> Enum.filter(fn pos -> Map.get(map, pos) - elev == 1 end)
    |> Enum.map(fn pos -> {pos, Map.get(map, pos)} end)
    |> case do
      [] -> []
      neighbors -> Enum.flat_map(neighbors, fn pt -> score_trailhead(pt, map, size) end)
    end
  end

  def part1(args) do
    parse_input(args)
    |> find_score_trailheads()
    |> Enum.map(&MapSet.new/1)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end

  def part2(args) do
    parse_input(args)
    |> find_score_trailheads()
    |> List.flatten()
    |> length()
  end
end
