defmodule AdventOfCode.Day12 do
  alias AdventOfCode.Helpers

  def parse_input(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Helpers.matrix_to_point_map()
  end

  def find_all_groups(to_check, acc) when to_check == %{}, do: acc

  def find_all_groups(point_map, acc) do
    [check] = Enum.take(point_map, 1)
    {remaining_map, group} = find_group([check], point_map, MapSet.new())
    find_all_groups(remaining_map, [group | acc])
  end

  def find_group([], remaining_map, group), do: {remaining_map, group}

  def find_group([{key, val} | rest_to_check], point_map, acc) do
    next_map = Map.delete(point_map, key)

    neighbors =
      get_neighbors(key)
      |> Enum.filter(&(Map.get(next_map, &1) == val))
      |> Enum.map(&{&1, Map.get(next_map, &1)})

    find_group(neighbors ++ rest_to_check, next_map, MapSet.put(acc, {key, val}))
  end

  def score_groups(groups) do
    Enum.reduce(groups, 0, fn group, acc -> acc + score_group(group) end)
  end

  def score_group(group) do
    map =
      Map.new(group)

    perimeter =
      Enum.reduce(map, 0, fn {k, _v}, acc ->
        sides =
          4 -
            (get_neighbors(k)
             |> Enum.filter(&Map.has_key?(map, &1))
             |> Enum.count())

        acc + sides
      end)

    perimeter * MapSet.size(group)
  end

  def score_with_bulk_discount(groups) do
    Enum.map(groups, fn group -> score_group_with_bulk_discount(group) end)
    |> Enum.sum()
  end

  def score_group_with_bulk_discount(group) do
    map =
      Enum.map(group, fn {pos, _} -> pos end)
      |> MapSet.new()

    perimeter =
      for step <- [-1, 1],
          row_col <- [0, 1] do
        Enum.filter(map, fn pos ->
          !MapSet.member?(map, put_elem(pos, row_col, elem(pos, row_col) + step))
        end)
        |> Enum.group_by(fn pos -> elem(pos, row_col) end)
        |> Enum.map(fn {_k, v} -> Enum.map(v, &elem(&1, abs(1 - row_col))) |> Enum.sort(:desc) end)
        |> Enum.map(fn v -> count_groups(v, 0) end)
        |> Enum.sum()
      end
      |> List.flatten()
      |> Enum.sum()

    perimeter * MapSet.size(map)
  end

  def count_groups([_last], acc), do: acc + 1

  def count_groups([first | [second | rest]], acc) when first - second > 1,
    do: count_groups([second | rest], acc + 1)

  def count_groups([_first | [second | rest]], acc), do: count_groups([second | rest], acc)

  def get_neighbors({row, col}),
    do:
      for(
        r_diff <- -1..1,
        c_diff <- -1..1,
        abs(r_diff) != abs(c_diff),
        do: {row + r_diff, col + c_diff}
      )

  def part1(args) do
    parse_input(args)
    |> find_all_groups([])
    |> score_groups()
  end

  def part2(args) do
    parse_input(args)
    |> find_all_groups([])
    # |> hd()
    |> score_with_bulk_discount()
  end
end
