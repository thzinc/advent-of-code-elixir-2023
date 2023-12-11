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

  test "part2 - first sample" do
    input = """
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    """

    result = part2(input)

    assert result == 4
  end

  test "part2 - second sample" do
    input = """
    ..........
    .S------7.
    .|F----7|.
    .||....||.
    .||....||.
    .|L-7F-J|.
    .|..||..|.
    .L--JL--J.
    ..........
    """

    result = part2(input)

    assert result == 4
  end

  test "part2 - third sample" do
    input = """
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
    """

    result = part2(input)

    assert result == 8
  end
end
