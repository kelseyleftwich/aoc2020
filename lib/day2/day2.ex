defmodule Aoc.Day2 do
  def part_1 do
    parse_input()
    |> Enum.reduce([], fn [[min, max], char, password], acc ->
      char_count = password |> String.graphemes() |> Enum.count(&(&1 == char))

      if char_count >= min and char_count <= max do
        [password | acc]
      else
        acc
      end
    end)
    |> Enum.count()
  end

  def part_2 do
    parse_input()
    |> Enum.reduce([], fn [[first_index, second_index], char, password], acc ->
      first_index = first_index - 1
      second_index = second_index - 1

      chars = password |> String.graphemes()

      checked =
        [Enum.at(chars, first_index) == char, Enum.at(chars, second_index) == char]
        |> Enum.count(fn x -> x end)

      with true <- checked == 1 do
        [password | acc]
      else
        false ->
          acc
      end
    end)
    |> Enum.count()
  end

  def parse_input do
    File.read!("lib/day2/input.txt")
    |> String.split("\n")
    |> Stream.map(fn x -> String.split(x, " ") end)
    |> Stream.map(fn [range, char, password] ->
      [
        range |> String.split("-") |> parse_ints,
        char |> String.replace(":", ""),
        password
      ]
    end)
  end

  def parse_ints([a, b]) do
    {a, _} = Integer.parse(a)
    {b, _} = Integer.parse(b)
    [a, b]
  end
end
