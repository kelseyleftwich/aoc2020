defmodule Aoc.Day10 do
  def part_1(file) do
    %{"1" => one_jolt_diffs, "3" => three_jolt_diffs} =
      file
      |> one_three_diffs()

    one_jolt_diffs * (three_jolt_diffs + 1)
  end

  def part_2(file) do
    :tbd
  end


  def chain_adapter([], _current_jolts) do
    []
  end

  def chain_adapter([next | rest], current_jolts) do
    diff = next - current_jolts

    [diff | chain_adapter(rest, next)]
  end

  def two_diffs([_last], count) do
    count
  end

  def two_diffs([next, next_1], count) do
    if next_1 - next == 2 do
      count + 1
    else
      count
    end
  end

  def two_diffs([next | rest], count) do
    [next_1 | [next_2 | _]] = rest

    if next_1 - next == 2 or next_2 - next == 2 do
      two_diffs(rest, count + 1)
    else
      two_diffs(rest, count)
    end
  end

  def one_three_diffs(file) do
    file
    |> parse_input()
    |> Enum.sort()
    |> chain_adapter(0)
    |> IO.inspect()
    |> Enum.reduce(%{}, fn diff, acc ->
      {_, updated} =
        acc
        |> Map.get_and_update(diff |> Integer.to_string(), fn current_value ->
          current_value =
            case current_value do
              nil ->
                0

              _ ->
                current_value
            end

          {nil, current_value + 1}
        end)

      updated
    end)
  end

  def parse_input(file) do
    File.read!("lib/day10/#{file}.txt")
    |> String.split("\n")
    |> Stream.map(fn x ->
      {x, _} = x |> Integer.parse()
      x
    end)
  end
end
