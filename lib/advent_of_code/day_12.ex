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
      prefix
      |> count_defects()
      |> case do
        [] ->
          []

        defects ->
          defects
          |> Enum.reverse()
          |> tl()
          |> Enum.reverse()
      end
      |> Enum.zip(check)
      |> Enum.all?(fn {actual, expected} -> actual == expected end)
    end)
    |> Enum.flat_map(fn prefix -> build_records(tail, check, prefix) end)
  end

  defp count_defects(record) do
    record
    |> String.graphemes()
    |> Enum.reduce({0, []}, fn
      ".", {0, defects} -> {0, defects}
      ".", {acc, defects} -> {0, [acc | defects]}
      "#", {acc, defects} -> {acc + 1, defects}
    end)
    |> then(fn
      {0, defects} -> defects
      {acc, defects} -> [acc | defects]
    end)
    |> Enum.reverse()
  end

  def part2(condition_records) do
    condition_records
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [record, check] ->
      check =
        [check, check, check, check, check]
        |> Enum.join(",")
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      [record, record, record, record, record]
      |> Enum.join("?")
      |> String.graphemes()
      |> build_records(check)
      |> Enum.count()
    end)
    |> Enum.reduce(0, &+/2)
  end
end
