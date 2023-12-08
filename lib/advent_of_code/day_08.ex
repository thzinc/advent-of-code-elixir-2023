defmodule AdventOfCode.Day08 do
  def part1(maps) do
    {movement, network} =
      maps
      |> String.split("\n\n")
      |> Enum.reduce({nil, nil}, fn
        movement, {nil, nil} ->
          movement =
            movement
            |> String.split("")
            |> Enum.flat_map(fn
              "R" -> [:right]
              "L" -> [:left]
              _ -> []
            end)
            |> Stream.cycle()

          {movement, nil}

        network, {movement, nil} ->
          network =
            Regex.scan(
              ~r/(?<node>\S+) = \((?<left>\S+), (?<right>\S+)\)/m,
              network,
              capture: :all_names
            )
            |> Enum.reduce(%{}, fn [left, node, right], acc ->
              acc
              |> Map.put(node, %{left: left, right: right})
            end)

          {movement, network}
      end)

    movement
    |> Enum.reduce_while({0, "AAA"}, fn move, {count, node} ->
      next_node =
        network
        |> Map.get(node)
        |> Map.get(move)

      if next_node == "ZZZ" do
        {:halt, count + 1}
      else
        {:cont, {count + 1, next_node}}
      end
    end)
  end

  def part2(_args) do
  end
end
