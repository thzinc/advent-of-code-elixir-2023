defmodule AdventOfCode.Day04 do
  def part1(scratchcards) do
    scratchcards
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      {needles, haystack} =
        line
        |> String.split()
        |> Enum.drop(2)
        |> Enum.reduce({MapSet.new(), nil}, fn
          "|", {needles, nil} -> {needles, MapSet.new()}
          num, {needles, nil} -> {MapSet.put(needles, num), nil}
          num, {needles, haystack} -> {needles, MapSet.put(haystack, num)}
        end)

      MapSet.intersection(needles, haystack)
      |> Enum.count()
      |> case do
        0 -> 0
        count -> 2 ** (count - 1)
      end
    end)
    |> Enum.reduce(0, &Kernel.+/2)
  end

  def part2(_args) do
  end
end
