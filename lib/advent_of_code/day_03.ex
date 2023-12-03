defmodule AdventOfCode.Day03 do
  def part1(engine_schematic) do
    engine_schematic
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, line_number} ->
      Regex.scan(~r/(?<part_number>\d+)|(?<symbol>[^\.\d]+)/, line,
        return: :index,
        capture: :all_names
      )
      |> Enum.map(fn
        [{start, length} = _part_number_index, {-1, 0}] ->
          part_number =
            line
            |> String.slice(start, length)
            |> String.to_integer()

          coordinates =
            start..(start + length - 1)
            |> Enum.map(fn x -> {x, line_number} end)

          {:part_number, part_number, coordinates}

        [{-1, 0}, {start, length} = _symbol_index] ->
          left = start - 1
          right = start + length

          vertical =
            left..right
            |> Enum.flat_map(fn x ->
              top = {x, line_number - 1}
              bottom = {x, line_number + 1}
              [top, bottom]
            end)

          sides = [
            {left, line_number},
            {right, line_number}
          ]

          coordinates =
            (vertical ++ sides)
            |> MapSet.new()

          {:allowed_coordinates, coordinates}
      end)
    end)
    |> Enum.reduce(%{allowed_coordinates: MapSet.new(), part_numbers: []}, fn
      {:part_number, part_number, coordinates}, %{part_numbers: part_numbers} = acc ->
        part_number_with_coordinates = {part_number, coordinates}
        Map.put(acc, :part_numbers, [part_number_with_coordinates | part_numbers])

      {:allowed_coordinates, coordinates}, %{allowed_coordinates: allowed_coordinates} = acc ->
        Map.put(acc, :allowed_coordinates, MapSet.union(allowed_coordinates, coordinates))
    end)
    |> then(fn %{
                 allowed_coordinates: allowed_coordinates,
                 part_numbers: part_numbers
               } ->
      part_numbers
      |> Enum.reduce(0, fn {part_number, coordinates}, sum ->
        sum +
          if Enum.any?(coordinates, &MapSet.member?(allowed_coordinates, &1)),
            do: part_number,
            else: 0
      end)
    end)
  end

  def part2(_args) do
  end
end
