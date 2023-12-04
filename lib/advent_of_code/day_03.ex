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

  def part2(engine_schematic) do
    engine_schematic
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, line_number} ->
      Regex.scan(~r/(?<gear>\*)|(?<part_number>\d+)/, line,
        return: :index,
        capture: :all_names
      )
      |> Enum.map(fn
        [{-1, 0}, {start, length} = _part_number_index] ->
          part_number =
            line
            |> String.slice(start, length)
            |> String.to_integer()

          [starting_coordinate | _] =
            coordinates =
            start..(start + length - 1)
            |> Enum.map(fn x -> {x, line_number} end)

          unique_part_number = {part_number, starting_coordinate}
          {:part_number, unique_part_number, coordinates}

        [{start, length} = _gear_index, {-1, 0}] ->
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

          coordinates = vertical ++ sides

          {:gear, coordinates}
      end)
    end)
    |> Enum.reduce(%{gears: [], part_numbers_by_coordinate: %{}}, fn
      {:part_number, unique_part_number, coordinates},
      %{part_numbers_by_coordinate: part_numbers_by_coordinate} = acc ->
        part_numbers_by_coordinate =
          coordinates
          |> Enum.reduce(part_numbers_by_coordinate, fn coordinate, acc ->
            Map.put(acc, coordinate, unique_part_number)
          end)

        Map.put(acc, :part_numbers_by_coordinate, part_numbers_by_coordinate)

      {:gear, gear}, %{gears: gears} = acc ->
        Map.put(acc, :gears, [gear | gears])
    end)
    |> then(fn %{
                 gears: gears,
                 part_numbers_by_coordinate: part_numbers_by_coordinate
               } ->
      gears
      |> Enum.map(fn gear_coordinates ->
        part_numbers_by_coordinate
        |> Map.take(gear_coordinates)
        |> Enum.reduce(MapSet.new(), fn {_, unique_part_number}, acc ->
          MapSet.put(acc, unique_part_number)
        end)
        |> Enum.map(fn {part_number, _} -> part_number end)
        |> then(fn
          [part1, part2] ->
            part1 * part2

          _ ->
            0
        end)
      end)
      |> Enum.reduce(0, &Kernel.+/2)
    end)
  end
end
