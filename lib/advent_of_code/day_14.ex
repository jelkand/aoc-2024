defmodule AdventOfCode.Day14 do
  alias AdventOfCode.Helpers

  def parse_input(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&parse_robot/1)
  end

  def parse_robot(str) do
    [p_x, p_y, v_x, v_y] =
      Regex.run(~r/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/, str, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    {{p_x, p_y}, {v_x, v_y}}
  end

  def step_times({{p_x, p_y}, {v_x, v_y}}, {x, y}, times) do
    {Integer.mod(p_x + v_x * times, x), Integer.mod(p_y + v_y * times, y)}
  end

  def step_all(bots, size), do: Enum.map(bots, &step(&1, size))

  def step({{p_x, p_y}, {v_x, v_y}}, {x, y}),
    do: {{Integer.mod(p_x + v_x, x), Integer.mod(p_y + v_y, y)}, {v_x, v_y}}

  def quadrantize(list, {x, y}) do
    x_pivot = div(x, 2)
    y_pivot = div(y, 2)

    for x_quad <- [0..(x_pivot - 1), (x_pivot + 1)..(x - 1)],
        y_quad <- [0..(y_pivot - 1), (y_pivot + 1)..(y - 1)] do
      Enum.count(list, fn {p_x, p_y} -> p_x in x_quad and p_y in y_quad end)
    end
  end

  def pretty_print(bots, {x, y}) do
    freqs = Enum.map(bots, &elem(&1, 0)) |> Enum.frequencies()

    Enum.map(0..(y - 1), fn row ->
      out =
        Enum.map(0..(x - 1), fn col ->
          Map.get(freqs, {col, row}, ".")
        end)
        |> Enum.join()

      IO.puts(out)
    end)

    IO.puts("")

    bots
  end

  def iter_til_past_threshold(bots, size, iteration) do
    group_size =
      Enum.map(bots, fn {pos, _} -> {pos, "*"} end)
      |> Map.new()
      |> Helpers.find_all_groups([])
      |> Enum.max_by(&MapSet.size/1)
      |> MapSet.size()

    cond do
      group_size >= div(length(bots), 3) -> {bots, iteration}
      true -> iter_til_past_threshold(step_all(bots, size), size, iteration + 1)
    end
  end

  def part1(args, size) do
    parse_input(args)
    |> Enum.map(&step_times(&1, size, 100))
    |> quadrantize(size)
    |> Enum.reduce(1, &*/2)
  end

  def part2(args, size) do
    {_bots, iteration} =
      parse_input(args)
      |> iter_til_past_threshold(size, 0)

    iteration
  end
end
