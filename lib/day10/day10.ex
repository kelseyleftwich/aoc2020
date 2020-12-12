defmodule Aoc.Day10 do
  def part_1(file) do
    %{"1" => one_jolt_diffs, "3" => three_jolt_diffs} =
      file
      |> one_three_diffs()

    one_jolt_diffs * (three_jolt_diffs + 1)
  end

  def part_2(file) do
    adapters =
      file
      |> parse_input()
      |> Enum.sort()
      |> List.insert_at(0, 0)

    adapters
    |> chain_adapter(0)
    |> Stream.with_index()
    |> Stream.filter(fn {diff, _i} -> diff == 3 end)
    |> Stream.map(fn {_diff, i} -> i end)
    |> Enum.reverse()
    |> Enum.reduce([adapters, []], fn index, acc ->
      [head | tail] = acc

      {a, b} =
        head
        |> Enum.split(index)

      [a, b] ++ tail
    end)
    |> Enum.map(fn arr -> possible_routes(arr) end)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  def possible_routes([_]) do
    1
  end

  def possible_routes([]) do
    1
  end

  def possible_routes(arr) do
    arr
    |> Enum.count()
    |> tribonnaci()
  end

  def tribonnaci(0) do
    0
  end

  def tribonnaci(index) do
    if index < 3 do
      1
    else
      tribonnaci(index - 3) + tribonnaci(index - 2) + tribonnaci(index - 1)
    end
  end

  def chain_adapter([], _current_jolts) do
    []
  end

  def chain_adapter([next | rest], current_jolts) do
    diff = next - current_jolts

    [diff | chain_adapter(rest, next)]
  end

  def one_three_diffs(file) do
    file
    |> parse_input()
    |> Enum.sort()
    |> chain_adapter(0)
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
