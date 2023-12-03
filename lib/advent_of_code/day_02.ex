defmodule AdventOfCode.Day02 do
  def part1(games, opts \\ []) do
    Regex.scan(~r/(Game (?<id>\d+): (?<outcomes>.+)$)+/im, games, capture: :all_names)
    |> Enum.reduce(0, fn [id, outcomes], acc ->
      outcomes
      |> String.split(";")
      |> Enum.map(
        &Regex.scan(~r/(?<count>\d+) (?<color>red|green|blue)/i, &1, capture: :all_names)
      )
      |> Enum.flat_map(& &1)
      |> Enum.map(fn [color, count] -> {String.to_atom(color), String.to_integer(count)} end)
      |> Enum.reduce(true, fn
        {color, count}, acc -> if Keyword.get(opts, color, 0) < count, do: false, else: acc
      end)
      |> then(fn
        true -> String.to_integer(id)
        false -> 0
      end)
      |> Kernel.+(acc)
    end)
  end

  def part2(games) do
    Regex.scan(~r/(Game \d+: (?<outcomes>.+)$)+/im, games, capture: :all_names)
    |> Enum.reduce(0, fn [outcomes], acc ->
      outcomes
      |> String.split(";")
      |> Enum.map(
        &Regex.scan(~r/(?<count>\d+) (?<color>red|green|blue)/i, &1, capture: :all_names)
      )
      |> Enum.flat_map(& &1)
      |> Enum.map(fn [color, count] -> {String.to_atom(color), String.to_integer(count)} end)
      |> Enum.reduce([red: 0, green: 0, blue: 0], fn
        {color, count}, acc -> Keyword.put(acc, color, Kernel.max(acc[color], count))
      end)
      |> Enum.reduce(1, fn {_color, count}, acc -> count * acc end)
      |> Kernel.+(acc)
    end)
  end
end
