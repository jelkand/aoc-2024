defmodule AdventOfCode.Day05 do
  def parse_input(input) do
    [rules, orders] = String.split(input, "\n\n", trim: true)

    {parse_rules(rules), parse_orders(orders)}
  end

  def parse_rules(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      String.split(str, "|", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.reduce(%{}, fn {val, before}, acc ->
      Map.update(acc, val, MapSet.new([before]), fn set -> MapSet.put(set, before) end)
    end)
  end

  def parse_orders(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def solve_1({rules, orders}) do
    orders
    |> Enum.filter(fn order -> check_order_valid(order, rules) end)
    |> Enum.map(fn list -> Enum.at(list, div(length(list) - 1, 2)) end)
    |> Enum.sum()
  end

  def solve_2({rules, orders}) do
    orders
    |> Enum.filter(fn order -> !check_order_valid(order, rules) end)
    |> Enum.map(
      &Enum.sort(&1, fn a, b ->
        Map.get(rules, a, MapSet.new()) |> MapSet.member?(b) |> Kernel.!()
      end)
    )
    |> Enum.map(fn list -> Enum.at(list, div(length(list) - 1, 2)) end)
    |> Enum.sum()
  end

  def check_order_valid(order, rules) do
    check_order_valid_internal(MapSet.new(), order, rules)
  end

  def check_order_valid_internal(_checked, [], _rules), do: true

  def check_order_valid_internal(checked, [first | rest], rules) do
    rule = Map.get(rules, first, MapSet.new())

    case MapSet.disjoint?(rule, checked) do
      true -> check_order_valid_internal(MapSet.put(checked, first), rest, rules)
      false -> false
    end
  end

  def part1(args) do
    parse_input(args)
    |> solve_1()
  end

  def part2(args) do
    parse_input(args)
    |> solve_2()
  end
end
