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

  def part2(maps) do
    {movement, network, starting_nodes} =
      maps
      |> String.split("\n\n")
      |> Enum.reduce({nil, nil, nil}, fn
        movement, {nil, nil, nil} ->
          movement =
            movement
            |> String.split("")
            |> Enum.flat_map(fn
              "R" -> [:right]
              "L" -> [:left]
              _ -> []
            end)
            |> Stream.cycle()

          {movement, nil, nil}

        network, {movement, nil, nil} ->
          {network, starting_nodes} =
            Regex.scan(
              ~r/(?<node>\S+) = \((?<left>\S+), (?<right>\S+)\)/m,
              network,
              capture: :all_names
            )
            |> Enum.reduce({%{}, []}, fn [left, node, right], {network, starting_nodes} ->
              network =
                network
                |> Map.put(node, %{left: left, right: right})

              starting_nodes =
                if String.ends_with?(node, "A"),
                  do: [node | starting_nodes],
                  else: starting_nodes

              {network, starting_nodes}
            end)

          {movement, network, starting_nodes}
      end)

    starting_nodes
    |> Enum.map(fn starting_node ->
      movement
      |> Enum.reduce_while({0, starting_node}, fn move, {count, node} ->
        next_node =
          network
          |> Map.get(node)
          |> Map.get(move)

        if String.ends_with?(next_node, "Z") do
          {:halt, count + 1}
        else
          {:cont, {count + 1, next_node}}
        end
      end)
    end)
    |> Enum.reduce(1, &lcm/2)
    |> trunc()
  end

  defp gcd(a, 0), do: a
  defp gcd(0, b), do: b
  defp gcd(a, b), do: gcd(b, rem(trunc(a), trunc(b)))
  defp lcm(0, 0), do: 0
  defp lcm(a, b), do: a * b / gcd(a, b)
end
