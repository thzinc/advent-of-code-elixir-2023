defmodule AdventOfCode.Day10 do
  def part1(map) do
    {start, nodes} =
      map
      |> String.trim()
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {c, x} -> {c, {x, y}} end)
      end)
      |> Enum.reduce({nil, %{}}, fn
        {".", _coord}, acc ->
          acc

        {"S", coord}, {nil = _start, nodes} ->
          {coord, nodes}

        {c, coord}, {start, nodes} ->
          [north, east, south, west] = surrounding_coords(coord)

          targets =
            case c do
              "|" -> [north, south]
              "-" -> [west, east]
              "L" -> [north, east]
              "J" -> [north, west]
              "7" -> [south, west]
              "F" -> [south, east]
            end
            |> MapSet.new()

          {start, Map.put(nodes, coord, targets)}
      end)
      |> then(fn {start, nodes} ->
        targets =
          nodes
          |> Map.take(surrounding_coords(start))
          |> Enum.filter(fn {_coord, targets} ->
            MapSet.member?(targets, start)
          end)
          |> Enum.map(fn {coord, _targets} -> coord end)
          |> MapSet.new()

        {start, Map.put(nodes, start, targets)}
      end)

    [count | _] =
      follow(start, nodes, MapSet.new())
      |> Enum.map(&MapSet.size/1)

    trunc(count / 2)
  end

  def part2(map) do
    {start, nodes} =
      map
      |> String.trim()
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {c, x} -> {c, {x, y}} end)
      end)
      |> Enum.reduce({nil, %{}}, fn
        {".", _coord}, acc ->
          acc

        {"S", coord}, {nil = _start, nodes} ->
          {coord, nodes}

        {c, coord}, {start, nodes} ->
          [north, east, south, west] = surrounding_coords(coord)

          targets =
            case c do
              "|" -> [north, south]
              "-" -> [west, east]
              "L" -> [north, east]
              "J" -> [north, west]
              "7" -> [south, west]
              "F" -> [south, east]
            end
            |> MapSet.new()

          {start, Map.put(nodes, coord, targets)}
      end)
      |> then(fn {start, nodes} ->
        targets =
          nodes
          |> Map.take(surrounding_coords(start))
          |> Enum.filter(fn {_coord, targets} ->
            MapSet.member?(targets, start)
          end)
          |> Enum.map(fn {coord, _targets} -> coord end)
          |> MapSet.new()

        {start, Map.put(nodes, start, targets)}
      end)

    [loop | _] = follow(start, nodes, MapSet.new())

    lines =
      loop
      |> Enum.reduce([], fn {_, y1} = coord, acc ->
        Map.get(nodes, coord)
        |> Enum.filter(fn {_x2, y2} -> y1 == y2 end)
        |> case do
          [_] -> [coord | acc]
          _ -> acc
        end
      end)
      |> Enum.sort()
      |> Enum.reduce(%{}, fn {x, y}, acc ->
        Map.update(acc, y, [x], fn xs -> [x | xs] end)
      end)
      |> Enum.flat_map(fn {y, xs} ->
        xs
        |> Enum.sort()
        |> Enum.uniq()
        |> Enum.chunk_every(2)
        |> Enum.map(fn [x1, x2] -> {{x1, y}, {x2, y}} end)
      end)

    {{x1, y1}, {x2, y2}} = bounding_box(loop)

    enclosed =
      y1..y2
      |> Enum.flat_map(fn y ->
        x1..x2
        |> Enum.map(fn x -> {x, y} end)
        |> Enum.reject(fn coord -> MapSet.member?(loop, coord) end)
        |> Enum.filter(fn {x, y} ->
          lines
          |> Enum.filter(fn {{_x1, y1}, _} -> y1 < y end)
          |> Enum.filter(fn {{x1, _y1}, {x2, _y2}} -> x1 <= x and x < x2 end)
          |> Enum.count()
          |> rem(2) == 1
        end)
      end)
      |> MapSet.new()
      |> MapSet.difference(loop)

    lines
    |> Enum.flat_map(fn {{x1, y1}, {x2, y2}} when y1 == y2 ->
      x1..x2
      |> Enum.map(fn x -> {x, y1} end)
    end)
    |> Enum.map(fn coord -> {coord, "░"} end)
    |> Enum.into(%{})
    |> plot()
    |> IO.puts()

    ((loop
      |> Enum.map(fn coord -> {coord, "░"} end)) ++
       (enclosed
        |> Enum.map(fn coord -> {coord, "▓"} end)))
    |> Enum.into(%{})
    |> plot()
    |> IO.puts()

    MapSet.size(enclosed)
  end

  defp plot(mapped_coords) do
    {{x1, y1}, {x2, y2}} =
      mapped_coords
      |> Map.keys()
      |> bounding_box()

    body =
      y1..y2
      |> Enum.map(fn y ->
        x1..x2
        |> Enum.map(fn x ->
          Map.get(mapped_coords, {x, y}, " ")
        end)
        |> Enum.join("")
      end)

    ["\n\n" | body]
    |> Enum.join("\n")
  end

  defp surrounding_coords({x, y} = _coord) do
    north = {x, y - 1}
    south = {x, y + 1}
    west = {x - 1, y}
    east = {x + 1, y}
    [north, east, south, west]
  end

  defp bounding_box(coords) do
    coords
    |> Enum.reduce(nil, fn
      coord, nil ->
        {coord, coord}

      {x, y}, {{x1, y1}, {x2, y2}} ->
        {{min(x, x1), min(y, y1)}, {max(x, x2), max(y, y2)}}
    end)
  end

  defp follow(coord, nodes, observed) do
    Map.get(nodes, coord)
    |> case do
      nil ->
        []

      targets ->
        observed = MapSet.put(observed, coord)

        new_targets =
          targets
          |> MapSet.difference(observed)

        if MapSet.size(new_targets) == 0 do
          [observed]
        else
          new_targets
          |> Enum.flat_map(fn target ->
            follow(target, nodes, observed)
          end)
        end
    end
  end
end
