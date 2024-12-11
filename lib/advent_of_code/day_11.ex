defmodule AdventOfCode.Day11 do
  def parse_input(input) do
    String.trim(input)
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def get_next_number(0), do: [1]

  def get_next_number(number) do
    digits = Integer.digits(number)

    length = length(digits)

    case Integer.mod(length, 2) do
      0 ->
        {l, r} = Enum.split(digits, div(length, 2))
        [Integer.undigits(l), Integer.undigits(r)]

      _ ->
        [number * 2024]
    end
  end

  def blink(list) do
    blink_internal(list, [])
  end

  def blink_internal([], acc), do: Enum.reverse(acc)

  def blink_internal([first | rest], acc) do
    next = get_next_number(first)
    blink_internal(rest, next ++ acc)
  end

  def blink_times(list, times) do
    Enum.reduce(1..times, list, fn _, acc ->
      blink(acc)
    end)
  end

  def blink_by_bucket_times(map, times) do
    Enum.reduce(1..times, map, fn _, acc ->
      blink_by_bucket(acc)
    end)
  end

  def blink_by_bucket(map) do
    Enum.reduce(map, %{}, fn {e, count}, acc ->
      get_next_number(e)
      |> Enum.reduce(acc, fn num, map ->
        Map.update(map, num, count, fn existing -> existing + count end)
      end)
    end)
  end

  def get_size(map), do: Enum.reduce(map, 0, fn {_k, v}, acc -> acc + v end)

  def part1(args) do
    parse_input(args)
    |> blink_times(25)
    |> length()
  end

  def part2(args) do
    parse_input(args)
    |> Enum.frequencies()
    |> Enum.into(%{})
    |> blink_by_bucket_times(75)
    |> get_size()
  end
end
