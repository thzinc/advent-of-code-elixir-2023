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

    starting_nodes |> IO.inspect(label: "starting nodes")

    movement
    |> Enum.reduce_while({0, starting_nodes}, fn move, {count, nodes} ->
      {next_nodes, all_end_nodes} =
        nodes
        |> Enum.reduce({[], true}, fn node, {next_nodes, all_end_nodes} ->
          next_node = get_in(network, [node, move])

          {
            [next_node | next_nodes],
            all_end_nodes and String.ends_with?(next_node, "Z")
          }
        end)

      if rem(count, 10_000_000) == 0 do
        next_nodes |> IO.inspect(label: "count #{count}")
      end

      if all_end_nodes do
        {:halt, count + 1}
      else
        {:cont, {count + 1, next_nodes}}
      end
    end)
  end
end
