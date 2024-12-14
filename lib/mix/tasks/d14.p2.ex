defmodule Mix.Tasks.D14.P2 do
  use Mix.Task

  import AdventOfCode.Day14

  @shortdoc "Day 14 Part 2"
  def run(args) do
    input = AdventOfCode.Input.get!(14, 2024)
    size = {101, 103}

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2(size) end}),
      else:
        input
        |> part2(size)
        |> IO.inspect(label: "Part 2 Results")
  end
end
