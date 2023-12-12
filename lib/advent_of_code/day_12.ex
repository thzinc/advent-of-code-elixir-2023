defmodule AdventOfCode.Day12 do
  def part1(condition_records) do
    condition_records
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [record, check] ->
      expected =
        check
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      records =
        record
        |> String.graphemes()
        |> build_records()

      records
      |> Enum.map(&count_defects/1)
      |> Enum.count(fn actual -> actual == expected end)
    end)
    |> Enum.reduce(0, &+/2)
  end

  defp build_records(suffix, prefix \\ "")

  defp build_records([], prefix), do: [prefix]

  defp build_records([head | tail], prefix) do
    case head do
      "?" -> [".", "#"]
      c -> [c]
    end
    |> Enum.map(fn c -> prefix <> c end)
    |> Enum.flat_map(fn prefix ->
      build_records(tail, prefix)
    end)
  end

  defp count_defects(record) do
    Regex.scan(~r/#+/, record)
    |> Enum.map(fn [match] -> String.length(match) end)
  end

  def part2(_args) do
  end
end
