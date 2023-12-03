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

          [starting_coordinate | _] =
            all_coordinates =
            start..(start + length - 1)
            |> Enum.map(fn x -> {x, line_number} end)

          unique_part_number_instance = {part_number, starting_coordinate}
          {:part_number, unique_part_number_instance, all_coordinates}

        [{-1, 0}, {start, length} = _symbol_index] ->
          coordinates =
            (start - 1)..(start + length)
            |> Enum.flat_map(fn x ->
              (line_number - 1)..(line_number + 1)
              |> Enum.map(fn y -> {x, y} end)
            end)
            |> MapSet.new()

          {:allowed_coordinates, coordinates}
      end)
    end)
    |> Enum.reduce(%{allowed_coordinates: MapSet.new(), part_numbers_by_coordinate: %{}}, fn
      {:part_number, unique_part_number_instance, coordinates}, acc ->
        coordinates
        |> Enum.reduce(acc, fn coordinate, acc ->
          put_in(
            acc,
            [:part_numbers_by_coordinate, coordinate],
            unique_part_number_instance
          )
        end)

      {:allowed_coordinates, coordinates}, %{allowed_coordinates: allowed_coordinates} = acc ->
        allowed_coordinates =
          allowed_coordinates
          |> MapSet.union(coordinates)

        Map.put(acc, :allowed_coordinates, allowed_coordinates)
    end)
    |> then(fn %{
                 allowed_coordinates: allowed_coordinates,
                 part_numbers_by_coordinate: part_numbers_by_coordinate
               } ->
      part_numbers_by_coordinate
      |> Enum.filter(fn {coordinate, _} -> MapSet.member?(allowed_coordinates, coordinate) end)
      |> Enum.map(fn {_, unique_part_number_instance} ->
        unique_part_number_instance
      end)
      |> Enum.uniq()
      |> Enum.map(fn {part_number, _} -> part_number end)
      |> Enum.reduce(0, &Kernel.+/2)
    end)
  end

  def part2(_args) do
  end
end
