defmodule AdventOfCode.Day14 do
  def part1(platform) do
    platform
    |> String.trim()
    |> String.split("\n")
    |> rotate()
    |> Enum.map(&String.graphemes/1)
    |> Enum.flat_map(fn column ->
      empty = {nil, 0}

      column
      |> Enum.with_index(1)
      |> Enum.reduce({empty, []}, fn
        {"#", _load}, {{_max, 0}, _group} = acc -> acc
        {"#", _load}, {last, group} -> {empty, [last | group]}
        {"O", load}, {{_max, count}, group} -> {{load, count + 1}, group}
        {".", load}, {{_max, count}, group} -> {{load, count}, group}
      end)
      |> then(fn
        {{_max, 0}, group} -> group
        {last, group} -> [last | group]
      end)
      |> Enum.flat_map(fn {max, count} -> max..(max - count + 1) end)
    end)
    |> Enum.reduce(0, &+/2)
  end

  def part2(_args) do
  end

  defp rotate(rows) do
    rows
    |> Enum.reduce([], fn
      row, [] ->
        String.graphemes(row)

      row, acc ->
        row
        |> String.graphemes()
        |> Enum.zip(acc)
        |> Enum.map(fn {a, b} -> a <> b end)
    end)
  end
end
