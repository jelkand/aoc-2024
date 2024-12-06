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
end
