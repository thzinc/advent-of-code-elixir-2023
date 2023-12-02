defmodule AdventOfCode.Day01 do
  def part1(calibration_document) do
    calibration_document
    |> String.split("\n")
    |> Enum.reduce(0, fn line, acc ->
      numbers =
        line
        |> String.split("")
        |> Enum.flat_map(fn str ->
          str
          |> Integer.parse()
          |> case do
            {num, _} -> [num]
            _ -> []
          end
        end)

      acc +
        (List.first(numbers, 0) * 10 +
           List.last(numbers, 0))
    end)
  end

  def part2(_args) do
  end
end
