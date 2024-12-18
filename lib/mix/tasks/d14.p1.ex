defmodule Mix.Tasks.D14.P1 do
  use Mix.Task

  import AdventOfCode.Day14

  @shortdoc "Day 14 Part 1"
  def run(args) do
    input = AdventOfCode.Input.get!(14, 2024)
    size = {101, 103}

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1(size) end}),
      else:
        input
        |> part1(size)
        |> IO.inspect(label: "Part 1 Results")
  end
end
