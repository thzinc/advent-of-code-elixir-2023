defmodule AdventOfCode.Day16 do
  @north {0, -1}
  @south {0, 1}
  @west {-1, 0}
  @east {1, 0}

  def part1(map, opts \\ [show_plot: false]) do
    actions_by_coord =
      map
      |> String.trim()
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        row
        |> String.graphemes()
        |> Enum.map(fn
          "." -> &pass_through/1
          "/" -> &reflect_ne_sw/1
          "\\" -> &reflect_se_nw/1
          "|" -> &split_horizontal/1
          "-" -> &split_vertical/1
        end)
        |> Enum.with_index()
        |> Enum.map(fn {fun, x} -> {{x, y}, fun} end)
      end)
      |> Enum.into(%{})

    vectors = walk({{0, 0}, @east}, actions_by_coord)

    coords =
      vectors
      |> Enum.map(fn {coord, _} -> coord end)
      |> Enum.uniq()

    if Keyword.get(opts, :show_plot, false) do
      extents =
        actions_by_coord
        |> Map.keys()
        |> get_extents()

      plot(coords, extents)
    end

    coords
    |> Enum.count()
  end

  defp get_extents(coords) do
    coords
    |> Enum.reduce({0, 0}, fn {x1, y1}, {x2, y2} ->
      {max(x1, x2), max(y1, y2)}
    end)
  end

  defp plot(coords, {max_x, max_y}) do
    set = MapSet.new(coords)

    0..max_y
    |> Enum.map(fn y ->
      0..max_x
      |> Enum.map(fn x ->
        if MapSet.member?(set, {x, y}),
          do: "▓",
          else: "░"
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  defp walk({coord, _} = vector, actions_by_coord, observed \\ MapSet.new()) do
    if MapSet.member?(observed, vector) do
      observed
    else
      Map.get(actions_by_coord, coord)
      |> case do
        nil ->
          observed

        action ->
          action.(vector)
          |> Enum.reduce(MapSet.put(observed, vector), fn next_vector, next_observed ->
            walk(next_vector, actions_by_coord, next_observed)
          end)
      end
    end
  end

  defp apply_vector({{cx, cy}, {tx, ty} = transform}) do
    coord = {cx + tx, cy + ty}
    {coord, transform}
  end

  defp pass_through(vector) do
    [apply_vector(vector)]
  end

  defp reflect_ne_sw({coord, transform}) do
    vector =
      case transform do
        @north -> @east
        @east -> @north
        @south -> @west
        @west -> @south
      end
      |> then(fn transform -> {coord, transform} end)

    [apply_vector(vector)]
  end

  defp reflect_se_nw({coord, transform}) do
    vector =
      case transform do
        @south -> @east
        @east -> @south
        @north -> @west
        @west -> @north
      end
      |> then(fn transform -> {coord, transform} end)

    [apply_vector(vector)]
  end

  defp split_horizontal({coord, transform} = vector) do
    if transform in [@west, @east] do
      [
        apply_vector({coord, @north}),
        apply_vector({coord, @south})
      ]
    else
      pass_through(vector)
    end
  end

  defp split_vertical({coord, transform} = vector) do
    if transform in [@north, @south] do
      [
        apply_vector({coord, @west}),
        apply_vector({coord, @east})
      ]
    else
      pass_through(vector)
    end
  end

  def part2(_args) do
  end
end
