defmodule AdventOfCode.Day09 do
  def part1(report) do
    report
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn values ->
      values
      |> extrapolate_last()
      |> Enum.reduce(0, &Kernel.+/2)
    end)
    |> Enum.reduce(0, &Kernel.+/2)
  end

  def extrapolate_last(seq) do
    Enum.reduce(seq, {nil, nil, []}, fn
      value, {nil, nil, []} ->
        {value, value == 0, []}

      value, {last, end?, acc} ->
        diff = value - last
        end? = end? and value == 0
        {value, end?, [diff | acc]}
    end)
    |> case do
      {last, end?, revered_differences} -> {last, end?, Enum.reverse(revered_differences)}
    end
    |> case do
      {last, true, _differences} -> [last]
      {last, _end?, differences} -> [last | extrapolate_last(differences)]
    end
  end

  def part2(_args) do
  end
end
