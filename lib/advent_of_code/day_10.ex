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

  def part2(_args) do
  end

  defp surrounding_coords({x, y} = _coord) do
    north = {x, y - 1}
    south = {x, y + 1}
    west = {x - 1, y}
    east = {x + 1, y}
    [north, east, south, west]
  end
end
