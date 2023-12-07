defmodule AdventOfCode.Day07 do
  def part1(bids) do
    bids
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> then(fn [hand, bid] ->
        hand =
          hand
          |> String.split("")
          |> Enum.reject(&(&1 == ""))
          |> Enum.map(fn
            "A" -> 14
            "K" -> 13
            "Q" -> 12
            "J" -> 11
            "T" -> 10
            digit -> String.to_integer(digit)
          end)

        classification = classify(hand)

        bid = String.to_integer(bid)
        {classification, hand, bid}
      end)
    end)
    |> Enum.sort()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, bid}, rank}, sum ->
      sum + bid * rank
    end)
  end

  defp classify(hand) do
    hand
    |> Enum.reduce(%{}, fn card, acc ->
      Map.update(acc, card, 1, fn c -> c + 1 end)
    end)
    |> Map.values()
    |> Enum.sort()
    |> Enum.reverse()
    |> case do
      [5] -> 7
      [4 | _] -> 6
      [3, 2] -> 5
      [3 | _] -> 4
      [2, 2 | _] -> 3
      [2 | _] -> 2
      _ -> 1
    end
  end

  def part2(bids) do
    bids
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> then(fn [hand, bid] ->
        hand =
          hand
          |> String.split("")
          |> Enum.reject(&(&1 == ""))
          |> Enum.map(fn
            "A" -> 14
            "K" -> 13
            "Q" -> 12
            "J" -> 1
            "T" -> 10
            digit -> String.to_integer(digit)
          end)

        classification = classify_with_jokers(hand)

        bid = String.to_integer(bid)

        {classification, hand, bid}
      end)
    end)
    |> Enum.sort()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, bid}, rank}, sum ->
      sum + bid * rank
    end)
  end

  defp classify_with_jokers(hand) do
    hand
    |> Enum.reduce(%{}, fn card, acc ->
      Map.update(acc, card, 1, fn c -> c + 1 end)
    end)
    |> then(fn counts ->
      jokers = Map.get(counts, 1, 0)

      others =
        counts
        |> Map.drop([1])
        |> Map.values()
        |> Enum.sort()
        |> Enum.reverse()

      {jokers, others}
    end)
    |> case do
      {5, []} -> 7
      {j, [c]} when c + j == 5 -> 7
      {j, [c, _]} when c + j == 4 -> 6
      {j, [a, b]} when a + b + j == 5 -> 5
      {j, [c | _]} when c + j == 3 -> 4
      {j, [a, b, _]} when a + b + j == 4 -> 3
      {j, [c | _]} when c + j == 2 -> 2
      {0, [1, 1, 1, 1, 1]} -> 1
    end
  end
end
