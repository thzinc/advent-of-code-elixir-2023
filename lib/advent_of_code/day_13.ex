defmodule AdventOfCode.Day13 do
  def part1(notes) do
    patterns =
      notes
      |> String.trim()
      |> String.split("\n\n")
      |> Enum.map(&String.split/1)

    patterns
    |> Enum.map(fn rows ->
      column_count =
        rotate(rows)
        |> find_split()

      if not is_nil(column_count) do
        column_count
      else
        row_count =
          find_split(rows)
          |> case do
            nil -> 0
            count -> count
          end

        row_count * 100
      end
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

  defp find_split(lines) do
    1..(length(lines) - 1)
    |> Enum.flat_map(fn split ->
      fore =
        lines
        |> Enum.slice(0, split)
        |> Enum.reverse()

      aft =
        lines
        |> Enum.slice(split, length(lines) - split)

      mirrored? =
        fore
        |> Enum.zip(aft)
        |> Enum.all?(fn {f, a} -> f == a end)

      if mirrored?,
        do: [split],
        else: []
    end)
    |> List.first()
  end
end
