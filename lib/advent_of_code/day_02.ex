defmodule AdventOfCode.Day02 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def compute_line(line) do
    line
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  def test_line(line) do
    monotonic_increasing = Enum.all?(line, fn x -> x > 0 end)
    monotonic_decreasing = Enum.all?(line, fn x -> x < 0 end)

    within_bounds = Enum.all?(line, fn x -> abs(x) <= 3 end)

    (monotonic_increasing or monotonic_decreasing) and within_bounds
  end

  def handle_line(line) do
    dir = get_direction(line)

    foo(line, dir, false)
  end

  def get_direction(line) do
    {asc, desc} =
      line
      |> compute_line()
      |> Enum.split_with(fn x -> x > 0 end)
      |> then(fn {asc, desc} -> {length(asc), length(desc)} end)

    cond do
      asc > desc -> :asc
      asc < desc -> :desc
      true -> :unk
    end
  end

  # handle complete

  def foo([], _direction, _has_skipped_one), do: :safe

  def foo([_only], _, _), do: :safe

  def foo(_, :unk, _), do: :unsafe

  # handle zero length steps
  def foo([first | [second | _rest]], _direction, true) when first == second, do: :unsafe

  def foo([first | [second | rest]], direction, false) when first == second,
    do: foo([first | rest], direction, true)

  # handle too large steps

  def foo([first | [second | _rest]], :asc, true) when second - first > 3, do: :unsafe

  def foo([first | [second | rest]], :asc, false) when second - first > 3,
    do: foo([first | rest], :asc, true)

  def foo([first | [second | _rest]], :desc, true) when first - second > 3, do: :unsafe

  def foo([first | [second | rest]], :desc, false) when first - second > 3,
    do: foo([first | rest], :desc, true)

  # handle wrong direction steps

  def foo([first | [second | _rest]], :asc, true) when second < first, do: :unsafe

  def foo([first | [second | rest]], :asc, false) when second < first,
    do: foo([first | rest], :asc, true)

  def foo([first | [second | _rest]], :desc, true) when first < second, do: :unsafe

  def foo([first | [second | rest]], :desc, false) when first < second,
    do: foo([first | rest], :desc, true)

  # normal, proceed
  def foo([first | [second | rest]], :asc, has_skipped_one) when first < second,
    do: foo([second | rest], :asc, has_skipped_one)

  def foo([first | [second | rest]], :desc, has_skipped_one) when first > second,
    do: foo([second | rest], :desc, has_skipped_one)

  # # def foo([first | [second | rest]], :asc, )

  # def foo([first | [second | rest]] = line, direction, has_skipped_one) do
  #   dbg()

  #   cond do
  #     # direction == :asc and first < second ->
  #     #   foo([second | rest], direction, has_skipped_one)

  #     direction == :asc and first >= second and not has_skipped_one ->
  #       IO.puts("skipping #{second}")
  #       foo([first | rest], direction, true)

  #     direction == :asc and first >= second and has_skipped_one ->
  #       false

  #     direction == :desc and first > second ->
  #       foo([second | rest], direction, has_skipped_one)

  #     direction == :desc and first <= second and not has_skipped_one ->
  #       IO.puts("skipping #{second}")
  #       foo([first | rest], direction, true)

  #     direction == :desc and first <= second and has_skipped_one ->
  #       false
  #   end
  # end

  def get_direction(a, b) when a < b, do: :asc
  def get_direction(a, b) when a > b, do: :desc
  def get_direction(a, b) when a == b, do: :unk

  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&compute_line/1)
    |> Enum.map(&test_line/1)
    |> Enum.count(& &1)
  end

  def part2(args) do
    args
    |> parse_input()
    # |> Enum.at(1)
    # |> then(fn x -> [x] end)
    |> Enum.map(&handle_line/1)
    |> Enum.count(fn safety -> safety == :safe end)
    |> dbg()
  end
end
