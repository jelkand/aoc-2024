defmodule AdventOfCode.Day11 do
  def parse_input(input) do
    String.trim(input)
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def blink(list) do
    blink_internal(list, [])
  end

  def blink_internal([], acc), do: Enum.reverse(acc)
  def blink_internal([0 | rest], acc), do: blink_internal(rest, [1 | acc])

  def blink_internal([first | rest], acc) do
    digits = Integer.digits(first)

    length = length(digits)

    # dbg(binding(), charlists: :as_lists)

    case Integer.mod(length, 2) do
      0 ->
        {l, r} = Enum.split(digits, div(length, 2))
        blink_internal(rest, [Integer.undigits(r) | [Integer.undigits(l) | acc]])

      _ ->
        blink_internal(rest, [first * 2024 | acc])
    end
  end

  def blink_times(list, times) do
    Enum.reduce(1..times, list, fn _, acc -> blink(acc) end)
  end

  def part1(args) do
    parse_input(args)
    |> blink_times(25)
    |> length()
  end

  def part2(args) do
    parse_input(args)
    |> blink_times(50)
    |> length()
  end
end
