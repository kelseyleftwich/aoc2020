defmodule Aoc.Day1 do
  def part_1 do
    input = parse_input()

    input
    |> Enum.map(fn x -> find_match(x, input) end)
    |> Enum.filter(fn x -> not is_nil(x) end)
    |> Enum.reduce(1, fn {x, _}, acc -> x * acc end)
  end

  def part_2 do
    input = parse_input()

    input
    |> Enum.map(fn {i_val, i_index} = current ->
      filtered_input = input |> Enum.filter(fn {_, index} -> index != i_index end)

      pairs =
        filtered_input
        |> Enum.map(fn x -> find_match(x, filtered_input, 2020 - i_val) end)
        |> Enum.filter(fn x -> not is_nil(x) end)

      [current | pairs]
    end)
    |> Enum.filter(fn x -> length(x) > 1 end)
    |> List.first()
    |> Enum.reduce(1, fn {val, _}, acc -> acc * val end)
  end

  def find_match({current_val, current_index}, input, target \\ 2020) do
    input
    |> Enum.find(fn {val, index} -> val + current_val == target and index != current_index end)
  end

  def parse_input do
    File.read!("lib/day1/input.txt")
    |> String.split("\n")
    |> Enum.map(fn x ->
      {num, _} = Integer.parse(x)
      num
    end)
    |> Enum.with_index()
  end
end
