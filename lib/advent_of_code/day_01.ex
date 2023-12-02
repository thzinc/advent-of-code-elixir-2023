defmodule AdventOfCode.Day01 do
  def part1(calibration_document) do
    calibration_document
    |> String.trim()
    |> String.split()
    |> Enum.reduce(0, fn line, acc ->
      numbers =
        line
        |> String.split("")
        |> Enum.flat_map(fn
          "1" -> [1]
          "2" -> [2]
          "3" -> [3]
          "4" -> [4]
          "5" -> [5]
          "6" -> [6]
          "7" -> [7]
          "8" -> [8]
          "9" -> [9]
          _ -> []
        end)

      acc +
        (List.first(numbers) * 10 +
           List.last(numbers))
    end)
  end

  def part2(calibration_document) do
    calibration_document
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(0, fn line, acc ->
      high =
        Regex.run(~r/one|two|three|four|five|six|seven|eight|nine|\d/i, line)
        |> hd()
        |> then(&to_integer/1)

      low =
        line
        |> String.reverse()
        |> then(&Regex.run(~r/eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|\d/i, &1))
        |> hd()
        |> then(&to_integer/1)

      acc + high * 10 + low
    end)
  end

  defp to_integer("one"), do: 1
  defp to_integer("eno"), do: 1
  defp to_integer("two"), do: 2
  defp to_integer("owt"), do: 2
  defp to_integer("three"), do: 3
  defp to_integer("eerht"), do: 3
  defp to_integer("four"), do: 4
  defp to_integer("ruof"), do: 4
  defp to_integer("five"), do: 5
  defp to_integer("evif"), do: 5
  defp to_integer("six"), do: 6
  defp to_integer("xis"), do: 6
  defp to_integer("seven"), do: 7
  defp to_integer("neves"), do: 7
  defp to_integer("eight"), do: 8
  defp to_integer("thgie"), do: 8
  defp to_integer("nine"), do: 9
  defp to_integer("enin"), do: 9
  defp to_integer(digit), do: String.to_integer(digit)
end
