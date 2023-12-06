defmodule AdventOfCode.Day06 do
  def part1(race_sheet) do
    race_sheet
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.reduce({nil, nil}, fn
      ["Time:" | times], {_times, distances} ->
        {times |> Enum.map(&String.to_integer/1), distances}

      ["Distance:" | distances], {times, _distances} ->
        {times, distances |> Enum.map(&String.to_integer/1)}

      _, acc ->
        acc
    end)
    |> then(fn {times, distances} -> Enum.zip(times, distances) end)
    |> Enum.map(fn {time, distance} ->
      rate_to_beat =
        ((time - :math.sqrt(time ** 2 - 4 * distance)) / 2)
        |> Kernel.+(1)
        |> trunc()

      rate_to_beat..time
      |> Enum.count(fn rate -> (time - rate) * rate > distance end)
    end)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  def part2(race_sheet) do
    race_sheet
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.reduce({nil, nil}, fn
      ["Time:" | times], {_times, distances} ->
        {times |> Enum.join() |> String.to_integer(), distances}

      ["Distance:" | distances], {times, _distances} ->
        {times, distances |> Enum.join() |> String.to_integer()}

      _, acc ->
        acc
    end)
    |> then(fn {time, distance} ->
      rate_to_beat =
        ((time - :math.sqrt(time ** 2 - 4 * distance)) / 2)
        |> Kernel.+(1)
        |> trunc()

      time..rate_to_beat
      |> Enum.take_while(fn rate -> (time - rate) * rate <= distance end)
      |> Enum.count()
      |> then(fn high_end_losses -> time - high_end_losses - rate_to_beat + 1 end)
    end)
  end
end
