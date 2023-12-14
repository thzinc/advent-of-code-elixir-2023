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

  def part2(platform) do
    [first_row | _] =
      rows =
      platform
      |> String.trim()
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {type, x} -> {x, y, type} end)
      end)

    max_x = length(first_row)
    max_y = length(rows)

    %{
      "#" => cubed_rocks,
      "O" => round_rocks
    } =
      rows
      |> Enum.flat_map(& &1)
      |> Enum.group_by(fn {_, _, type} -> type end, fn {x, y, _} -> {x, y} end)
      |> Map.take(["#", "O"])

    cubed_rocks
    |> IO.inspect(label: "cubed")

    round_rocks
    |> IO.inspect(label: "round")
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
