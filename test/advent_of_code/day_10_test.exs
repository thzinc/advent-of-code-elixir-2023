defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  test "part1 - first sample" do
    input = """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """

    result = part1(input)

    assert result == 4
  end

  test "part1 - second sample" do
    input = """
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """

    result = part1(input)

    assert result == 8
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
