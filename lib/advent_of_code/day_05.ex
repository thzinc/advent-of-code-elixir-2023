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

  def part2(almanac) do
    ["seeds: " <> seeds_set | maps] =
      almanac
      |> String.split("\n\n")

    seeds =
      seeds_set
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, length] ->
        Map.new()
        |> Map.put("seed", start)
        |> Map.put("length", length)
      end)

    maps =
      maps
      |> Enum.reduce(%{}, fn map, acc ->
        {source, dest, map} =
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

        acc
        |> Map.put(source, {dest, map})
      end)

    seeds
    |> Enum.flat_map(fn seed ->
      follow_map(seed, "seed", "location", maps)
    end)
    |> then(fn x ->
      x
      |> Enum.sort_by(fn %{"location" => l} -> l end)
      |> Enum.take(10)
      |> IO.inspect(label: "solutions")

      x
    end)
    |> Enum.reduce(nil, fn
      seed, nil ->
        seed

      %{"location" => a} = seed, %{"location" => b} = acc ->
        if a < b,
          do: seed,
          else: acc
    end)
    |> Map.get("location")
  end

  defp follow_map(seed, source, target, maps) when source == target,
    do: [seed]

  defp follow_map(seed, source, target, maps) do
    {dest, map} = Map.get(maps, source)

    split_seed(seed, source, dest, map)
    |> Enum.flat_map(fn seed ->
      follow_map(seed, dest, target, maps)
    end)
  end

  defp split_seed(seed, source, dest, map) do
    source_index = Map.get(seed, source)
    source_length = Map.get(seed, "length")
    source_end = source_index + source_length

    map
    |> Enum.filter(fn {map_index, _dest_index, map_length} ->
      map_index <= source_end and source_index < map_index + map_length
    end)
    |> Enum.sort()
    |> Enum.reduce([], fn {map_index, _dest_index, _map_length} = m, acc ->
      if source_index < map_index do
        prefix = {source_index, source_index, map_index - source_index}
        [prefix | [m | acc]]
      else
        [m | acc]
      end
    end)
    |> then(fn
      [] ->
        [{source_index, source_index, source_length}]

      [head | _] = map ->
        {map_index, _, map_length} = head
        map_end = map_index + map_length

        if map_end < source_end do
          suffix = {map_end, map_end, source_end - map_end}
          [suffix | map]
        else
          map
        end
    end)
    |> Enum.flat_map(fn {map_index, dest_index, map_length} ->
      map_delta = dest_index - map_index
      map_end = map_index + map_length

      prefix =
        if source_index < map_index do
          [
            seed
            |> Map.put(source, source_index)
            |> Map.put(dest, source_index)
            |> Map.put("length", map_index - source_index)
          ]
        else
          []
        end

      overlap_index = max(source_index, map_index)
      overlap_end = min(source_end, map_end)
      overlap_length = overlap_end - overlap_index

      overlap = [
        seed
        |> Map.put(source, overlap_index)
        |> Map.put(dest, overlap_index + map_delta)
        |> Map.put("length", overlap_length)
      ]

      suffix =
        if map_end < source_end do
          [
            seed
            |> Map.put(source, map_end)
            |> Map.put(dest, map_end)
            |> Map.put("length", source_end - map_end)
          ]
        else
          []
        end

      List.flatten([prefix, overlap, suffix])
    end)
  end
end
