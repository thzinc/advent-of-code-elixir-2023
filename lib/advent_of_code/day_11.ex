defmodule AdventOfCode.Day11 do
  def part1(image) do
    galaxies =
      image
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.flat_map(fn
          {"#", x} -> [{x, y}]
          _ -> []
        end)
      end)
      |> Enum.sort()
      |> expand_coordinates()

    galaxies
    |> get_lines()
    |> Enum.map(&get_distance/1)
    |> Enum.reduce(0, &+/2)
  end

  defp expand_coordinates(coords, scale \\ 2) do
    {xs, ys, {min_x, min_y}, {max_x, max_y}} =
      coords
      |> Enum.reduce({nil, nil, nil, nil}, fn
        {x, y}, {nil, nil, nil, nil} ->
          {
            MapSet.new([x]),
            MapSet.new([y]),
            {x, y},
            {x, y}
          }

        {x, y}, {xs, ys, {min_x, min_y}, {max_x, max_y}} ->
          {
            MapSet.put(xs, x),
            MapSet.put(ys, y),
            {min(x, min_x), min(y, min_y)},
            {max(x, max_x), max(y, max_y)}
          }
      end)

    x_map = build_mapping(min_x, max_x, xs, scale - 1)
    y_map = build_mapping(min_y, max_y, ys, scale - 1)

    coords
    |> Enum.map(fn {x, y} ->
      {Map.get(x_map, x), Map.get(y_map, y)}
    end)
  end

  defp build_mapping(min, max, set, offset_increment) do
    {_, mapping} =
      min..max
      |> Enum.reduce({offset_increment * min, %{}}, fn a, {offset, mapping} ->
        offset =
          offset +
            if MapSet.member?(set, a),
              do: 0,
              else: offset_increment

        b = offset + a

        mapping = Map.put(mapping, a, b)

        {offset, mapping}
      end)

    mapping
  end

  defp get_lines([]), do: []

  defp get_lines([head | tail]) do
    Enum.map(tail, fn t -> {head, t} end) ++
      get_lines(tail)
  end

  defp get_distance({{x1, y1}, {x2, y2}}) do
    cond do
      x1 == x2 ->
        max(y1, y2) - min(y1, y2)

      y1 == y2 ->
        max(x1, x2) - min(x1, x2)

      true ->
        a = max(x1, x2) - min(x1, x2)
        b = max(y1, y2) - min(y1, y2)

        a + b
    end
  end

  def part2(image, scale) do
    galaxies =
      image
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.flat_map(fn
          {"#", x} -> [{x, y}]
          _ -> []
        end)
      end)
      |> Enum.sort()
      |> expand_coordinates(scale)

    galaxies
    |> get_lines()
    |> Enum.map(&get_distance/1)
    |> Enum.reduce(0, &+/2)
  end
end
