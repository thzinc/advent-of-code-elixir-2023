defmodule AdventOfCode.Day15 do
  def part1(initialization_sequence) do
    initialization_sequence
    |> String.split([","])
    |> Enum.map(&hash/1)
    |> Enum.reduce(0, &+/2)
  end

  def hash(input) do
    input
    |> to_charlist()
    |> Enum.reduce(0, fn
      10, sum -> sum
      char, sum -> rem((char + sum) * 17, 256)
    end)
  end

  def part2(initialization_sequence) do
    initialization_sequence
    |> String.trim()
    |> String.split([","])
    |> Enum.reduce(%{}, fn step, map ->
      parse(step)
      |> case do
        %{
          hash: hash,
          operation: :pop,
          label: label_to_remove
        } ->
          Map.update(map, hash, [], fn ordered ->
            ordered
            |> Enum.reject(fn {label, _} -> label == label_to_remove end)
          end)

        %{
          hash: hash,
          operation: :push,
          label: label_to_add,
          focal_length: focal_length
        } ->
          Map.update(map, hash, [{label_to_add, focal_length}], fn ordered ->
            ordered
            |> Enum.reduce({[], false}, fn {label, _} = lens, {acc, found?} ->
              {lens, found?} =
                if label == label_to_add do
                  lens = {label, focal_length}
                  {lens, true}
                else
                  {lens, found?}
                end

              {[lens | acc], found?}
            end)
            |> case do
              {acc, false} -> [{label_to_add, focal_length} | acc]
              {acc, true} -> acc
            end
            |> Enum.reverse()
          end)
      end
    end)
    |> Enum.flat_map(fn {hash, lenses} ->
      box = hash + 1

      lenses
      |> Enum.with_index(1)
      |> Enum.map(fn {{_label, focal_length}, slot} -> box * slot * focal_length end)
    end)
    |> Enum.reduce(0, &+/2)
  end

  def parse(step) do
    step
    |> String.graphemes()
    |> Enum.reduce(nil, fn
      grapheme, nil -> grapheme
      "-", label -> {label, :pop}
      "=", label -> {label, :push, ""}
      grapheme, {label, :push, focal_length} -> {label, :push, focal_length <> grapheme}
      grapheme, label -> label <> grapheme
    end)
    |> then(fn
      {label, operation, focal_length} ->
        %{
          hash: hash(label),
          label: label,
          operation: operation,
          focal_length: String.to_integer(focal_length)
        }

      {label, operation} ->
        %{
          hash: hash(label),
          label: label,
          operation: operation
        }
    end)
  end
end
