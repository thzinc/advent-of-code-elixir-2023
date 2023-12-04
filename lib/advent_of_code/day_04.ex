defmodule AdventOfCode.Day04 do
  def part1(scratchcards) do
    scratchcards
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      {needles, haystack} =
        line
        |> String.split()
        |> Enum.drop(2)
        |> Enum.reduce({MapSet.new(), nil}, fn
          "|", {needles, nil} -> {needles, MapSet.new()}
          num, {needles, nil} -> {MapSet.put(needles, num), nil}
          num, {needles, haystack} -> {needles, MapSet.put(haystack, num)}
        end)

      MapSet.intersection(needles, haystack)
      |> MapSet.size()
      |> case do
        0 -> 0
        count -> 2 ** (count - 1)
      end
    end)
    |> Enum.reduce(0, &Kernel.+/2)
  end

  def part2(scratchcards) do
    scratchcards
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      {needles, haystack} =
        line
        |> String.split()
        |> Enum.drop(2)
        |> Enum.reduce({MapSet.new(), nil}, fn
          "|", {needles, nil} -> {needles, MapSet.new()}
          num, {needles, nil} -> {MapSet.put(needles, num), nil}
          num, {needles, haystack} -> {needles, MapSet.put(haystack, num)}
        end)

      MapSet.intersection(needles, haystack)
      |> MapSet.size()
    end)
    |> Enum.reduce({0, []}, fn wins_per_card, {num_cards, extra_copy_buffer} ->
      {extra_copies, extra_copy_buffer} =
        extra_copy_buffer
        |> case do
          [] -> {0, []}
          [extra_copies] -> {extra_copies, []}
          [extra_copies | extra_copy_buffer] -> {extra_copies, extra_copy_buffer}
        end

      total_copies = 1 + extra_copies

      existing_buffer =
        extra_copy_buffer
        |> Enum.with_index()
        |> Enum.map(fn {extra_copies, index} ->
          extra_copies +
            if index < wins_per_card,
              do: total_copies,
              else: 0
        end)

      new_buffer_length = wins_per_card - length(extra_copy_buffer)

      extra_copy_buffer =
        if new_buffer_length > 0,
          do: existing_buffer ++ List.duplicate(total_copies, new_buffer_length),
          else: existing_buffer

      num_cards = num_cards + total_copies

      {num_cards, extra_copy_buffer}
    end)
    |> then(fn {num_cards, _} -> num_cards end)
  end
end
