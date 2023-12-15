defmodule AdventOfCode.Day15 do
  def part1(initialization_sequence) do
    initialization_sequence
    |> String.split([","])
    |> Enum.map(&hash/1)
    |> Enum.reduce(0, &+/2)
  end

  def hash(input) do
    input
    |> to_charlist()
    |> Enum.reduce(0, fn
      10, sum -> sum
      char, sum -> rem((char + sum) * 17, 256)
    end)
  end

  def part2(_args) do
  end
end
