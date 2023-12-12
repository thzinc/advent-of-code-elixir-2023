defmodule AdventOfCode.Day12 do
  def part1(condition_records) do
    condition_records
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [record, check] ->
      check =
        check
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      record
      |> String.graphemes()
      |> build_records(check)
      |> Enum.count()
    end)
    |> Enum.reduce(0, &+/2)
  end

  defp build_records(suffix, check, prefix \\ "")

  defp build_records([], check, prefix) do
    if count_defects(prefix) == check,
      do: [prefix],
      else: []
  end

  defp build_records([head | tail], check, prefix) do
    case head do
      "?" -> [".", "#"]
      c -> [c]
    end
    |> Enum.map(fn c -> prefix <> c end)
    |> Enum.filter(fn prefix ->
      actual =
        prefix
        |> count_defects()
        |> then(fn a -> Enum.take(a, length(a) - 1) end)

      actual
      |> Enum.zip(check)
      |> Enum.all?(fn {a, e} -> a == e end)
    end)
    |> Enum.flat_map(fn prefix ->
      build_records(tail, check, prefix)
    end)
  end

  defp count_defects(record) do
    Regex.scan(~r/#+/, record)
    |> Enum.map(fn [match] -> String.length(match) end)
  end

  def part2(_args) do
  end
end
