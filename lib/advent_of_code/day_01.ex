defmodule AdventOfCode.Day01 do
  def part1(calibration_document) do
    calibration_document
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
        (List.first(numbers, 0) * 10 +
           List.last(numbers, 0))
    end)
  end

  def part2(calibration_document) do
    calibration_document
    |> String.split("\n")
    |> Enum.reduce(0, fn line, acc ->
      high =
        Regex.scan(~r/one|two|three|four|five|six|seven|eight|nine|\d/i, line)
        |> Enum.flat_map(& &1)
        |> Enum.map(fn
          "one" -> 1
          "two" -> 2
          "three" -> 3
          "four" -> 4
          "five" -> 5
          "six" -> 6
          "seven" -> 7
          "eight" -> 8
          "nine" -> 9
          digit -> String.to_integer(digit)
        end)
        |> List.first(0)
        |> Kernel.*(10)

      low =
        line
        |> String.reverse()
        |> then(&Regex.scan(~r/eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|\d/i, &1))
        |> Enum.flat_map(& &1)
        |> Enum.map(fn
          "eno" -> 1
          "owt" -> 2
          "eerht" -> 3
          "ruof" -> 4
          "evif" -> 5
          "xis" -> 6
          "neves" -> 7
          "thgie" -> 8
          "enin" -> 9
          digit -> String.to_integer(digit)
        end)
        |> List.first(0)

      acc + high + low
    end)
  end
end
