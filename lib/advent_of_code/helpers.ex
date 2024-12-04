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
end
