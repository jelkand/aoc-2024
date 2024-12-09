defmodule AdventOfCode.Day09 do
  def parse_input(input) do
    String.trim(input)
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_disk_map(list) do
    parse_disk_map_internal(list, [], 0, :file) |> Enum.filter(&(length(&1) > 0))
  end

  def parse_disk_map_internal([], accum, _id, _), do: Enum.reverse(accum)

  def parse_disk_map_internal([size | rest], accum, id, :file) do
    parse_disk_map_internal(rest, [List.duplicate(id, size) | accum], id + 1, :free)
  end

  def parse_disk_map_internal([size | rest], accum, id, :free) do
    parse_disk_map_internal(rest, [List.duplicate(".", size) | accum], id, :file)
  end

  def compress_disk_map_part_1(disk_map) do
    max_length = length(disk_map) - Enum.count(disk_map, fn char -> char == "." end)

    fills = Enum.filter(disk_map, fn c -> c != "." end) |> Enum.reverse()

    compress_disk_map_part_1_internal([], disk_map, fills, 0, max_length)
  end

  def compress_disk_map_part_1_internal(compressed, _, _, count, max) when count == max,
    do: Enum.reverse(compressed)

  def compress_disk_map_part_1_internal(accum, [num | rest], fills, count, max) when num != ".",
    do: compress_disk_map_part_1_internal([num | accum], rest, fills, count + 1, max)

  def compress_disk_map_part_1_internal(accum, [num | rest], [fill | rest_fills], count, max)
      when num == "." and fill != ".",
      do: compress_disk_map_part_1_internal([fill | accum], rest, rest_fills, count + 1, max)

  def compress_disk_map_part_1_internal(accum, [num | rest], [fill | rest_fills], count, max)
      when num == "." and fill == ".",
      do: compress_disk_map_part_1_internal(accum, rest, rest_fills, count, max)

  def calc_checksum(list) do
    Enum.with_index(list)
    |> Enum.reduce(0, fn {val, idx}, acc ->
      case val do
        "." -> acc
        x -> acc + x * idx
      end
    end)
  end

  def compress_disk_map_part_2(disk_map) do
    compress_disk_map_part_2_internal(disk_map, [])
  end

  def compress_disk_map_part_2_internal([], unmoveables), do: unmoveables

  def compress_disk_map_part_2_internal(list, unmoveables) do
    [file | rest] = Enum.reverse(list)

    {next_list, next_unmoveables} =
      case hd(file) do
        "." -> {Enum.reverse(rest), [file | unmoveables]}
        _ -> maybe_move_file(Enum.reverse(rest), file, unmoveables)
      end

    compress_disk_map_part_2_internal(next_list, next_unmoveables)
  end

  # returns a tuple of 
  # 0: new list with the file moved in it, if applicable
  # 1: "locked in" portions 
  def maybe_move_file(list, file, unmoveables) do
    file_size = length(file)

    Enum.split_while(list, fn sublist ->
      !(hd(sublist) == "." and length(sublist) >= file_size)
    end)
    |> case do
      {_, []} ->
        {list, [file | unmoveables]}

      {left, [space | right]} ->
        handle_swap(left, space, file, right, unmoveables)
    end
  end

  def handle_swap(left, space, file, right, unmoveables) do
    size_diff = length(space) - length(file)

    case size_diff do
      0 ->
        {left ++ [file] ++ right, [space | unmoveables]}

      n ->
        {left ++ [file] ++ [List.duplicate(".", n)] ++ right,
         [List.duplicate(".", length(file)) | unmoveables]}
    end
  end

  def part1(args) do
    parse_input(args)
    |> parse_disk_map()
    |> List.flatten()
    |> compress_disk_map_part_1()
    |> calc_checksum()
  end

  def part2(args) do
    parse_input(args)
    |> parse_disk_map()
    |> compress_disk_map_part_2()
    |> List.flatten()
    |> calc_checksum()
  end
end
