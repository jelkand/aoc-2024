defmodule AdventOfCode.Helpers do
  def transpose(matrix) do
    matrix
    |> Enum.at(0)
    |> Enum.with_index()
    |> Enum.map(fn {_, idx} ->
      Enum.map(matrix, fn row ->
        Enum.at(row, idx)
      end)
    end)
  end

  def matrix_to_point_map(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_idx} ->
      Enum.with_index(row)
      |> Enum.map(fn {value, col_idx} -> {{row_idx, col_idx}, value} end)
    end)
    |> Enum.into(%{})
  end

  def pretty_print_point_map(map) do
    rows = Enum.map(map, &(elem(&1, 0) |> elem(0))) |> Enum.max()
    cols = Enum.map(map, &(elem(&1, 0) |> elem(1))) |> Enum.max()

    IO.puts("\n")

    Enum.map(0..rows, fn row ->
      out =
        Enum.map(0..cols, fn col ->
          Map.get(map, {row, col})
        end)
        |> Enum.join()

      IO.puts(out)
    end)

    IO.puts("\n")
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

  def get_neighbors({row, col}),
    do:
      for(
        r_diff <- -1..1,
        c_diff <- -1..1,
        abs(r_diff) != abs(c_diff),
        do: {row + r_diff, col + c_diff}
      )
end
