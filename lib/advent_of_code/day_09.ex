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

  def part2(report) do
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
      |> extrapolate_first()
      |> Enum.reverse()
      |> Enum.reduce(&Kernel.-/2)
    end)
    |> Enum.reduce(&Kernel.+/2)
  end

  def extrapolate_first(seq) do
    Enum.reduce(seq, {nil, nil, nil, []}, fn
      value, {nil, nil, nil, []} ->
        {value, value, value == 0, []}

      value, {first, last, end?, acc} ->
        diff = value - last
        end? = end? and value == 0
        {first, value, end?, [diff | acc]}
    end)
    |> case do
      {first, _last, end?, revered_differences} ->
        {first, end?, Enum.reverse(revered_differences)}
    end
    |> case do
      {first, true, _differences} -> [first]
      {first, _end?, differences} -> [first | extrapolate_first(differences)]
    end
  end
end
