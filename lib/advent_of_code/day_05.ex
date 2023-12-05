defmodule AdventOfCode.Day05 do
  def part1(almanac) do
    ["seeds: " <> seeds_set | maps] =
      almanac
      |> String.split("\n\n")

    seeds =
      seeds_set
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    maps =
      maps
      |> Enum.reduce([], fn map, acc ->
        {source, dest, reversed_map} =
          map
          |> String.split("\n")
          |> Enum.map(&String.split/1)
          |> Enum.reduce({nil, nil, []}, fn
            [label, _map] = _line, {_source, _dest, map} = _acc ->
              [source, dest] = String.split(label, "-to-")

              {source, dest, map}

            [dest_index, source_index, length] = _line, {source, dest, map} = _acc ->
              dest_index = String.to_integer(dest_index)
              source_index = String.to_integer(source_index)
              length = String.to_integer(length)

              {source, dest, [{source_index, dest_index, length} | map]}

            _line, acc ->
              acc
          end)

        ordered_map = Enum.reverse(reversed_map)

        [{source, dest, ordered_map} | acc]
      end)

    seeds
    |> Enum.flat_map(fn seed ->
      follow("seed", seed, "location", maps)
      |> Enum.take(1)
    end)
    |> Enum.reduce(nil, fn
      location, nil -> location
      location, acc -> min(location, acc)
    end)
  end

  defp follow(source, value, target, _maps) when source == target,
    do: [value]

  defp follow(source, value, target, maps) do
    maps
    |> Enum.flat_map(fn
      {^source, dest, map} ->
        {source_index, dest_index, _length} =
          Enum.find(map, {value, value, 1}, fn {source_index, _dest_index, length} ->
            source_index <= value and value <= source_index + length - 1
          end)

        dest_value = dest_index + value - source_index

        follow(dest, dest_value, target, maps)

      _ ->
        []
    end)
  end

  def part2(_args) do
  end
end
