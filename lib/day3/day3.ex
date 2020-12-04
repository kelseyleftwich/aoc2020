defmodule Aoc.Day3 do
  def part_1 do
    [head | input] = parse_input()

    head
    |> String.split_at(1)
    |> IO.inspect()

    input
    |> trees_encountered_at_slope()
  end

  # Right 1, down 1.
  # Right 3, down 1. (This is the slope you already checked.)
  # Right 5, down 1.
  # Right 7, down 1.
  # Right 1, down 2.
  def part_2 do
    [_ | input] = parse_input()

    [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]
    |> Enum.reduce(1, fn {x_step, y_step}, acc ->
      %{count: count} =
        input
        |> trees_encountered_at_slope(x_step, y_step)

      {count, acc}
      |> IO.inspect()

      count * acc
    end)
  end

  def trees_encountered_at_slope(input, x_step \\ 3, y_step \\ 1) do
    input
    |> Enum.reduce(%{index: x_step, count: 0, y_index: 1}, fn line,
                                                              %{
                                                                index: index,
                                                                count: count,
                                                                y_index: y_index
                                                              } ->
      string_position = rem(index, line |> String.length())

      tree_encountered? = line |> String.at(string_position) == "#"

      {first, second} =
        line
        |> String.split_at(string_position)

      symbol = if tree_encountered?, do: "X", else: "O"

      "#{first}#{symbol}#{String.slice(second, 1, line |> String.length())}"
      |> IO.inspect()

      increment_x? = rem(y_index, y_step) == 0
      new_count = if tree_encountered? and increment_x?, do: count + 1, else: count

      new_index = if increment_x?, do: index + x_step, else: index

      %{index: new_index, count: new_count, y_index: y_index + 1}
    end)
  end

  def parse_input do
    File.read!("lib/day3/input.txt")
    |> String.split("\n")
  end
end
