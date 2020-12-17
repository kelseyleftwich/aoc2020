defmodule Aoc.Day14 do
  def part_1(file) do
    [initial_mask | instructions] =
      file
      |> parse_input()

    instructions
    |> write_value(%{}, initial_mask)
    |> IO.inspect()
    |> Map.get(26)
    |> List.wrap()
    |> Enum.map(fn  bin_string ->
      bin_string
      |> String.graphemes()
      |> Enum.reverse()
      |> get_possible_values()
    end)
  end

  def get_possible_values(["X" | tail]) do
    [
      [3 |> Integer.to_string() | get_possible_values(tail)],
      [4 |> Integer.to_string() | get_possible_values(tail)]
    ]
  end

  def get_possible_values([head | tail]) do
    [head | get_possible_values(tail)]
  end

  def get_possible_values([]) do
    []
  end

  def write_value([], memory, _) do
    memory
  end

  def write_value([{address, value} | rest], memory, mask) do
    memory =
      memory
      |> Map.put(address, value |> apply_mask(mask))

    write_value(rest, memory, mask)
  end

  def write_value([new_mask | rest], memory, _mask) do
    write_value(rest, memory, new_mask)
  end

  def apply_mask(value, []) do
    value
  end

  def apply_mask(value, [{_index, "0"} | rest]) do
    apply_mask(value, rest)
  end

  def apply_mask(value, [{index, char} | rest]) do
    value
    |> String.graphemes()
    |> List.update_at(35 - index, fn _ -> char end)
    |> Enum.join()
    |> apply_mask(rest)
  end

  def parse_mask(mask) do
    mask
    |> String.split("=")
    |> List.last()
    |> String.trim()
    |> String.graphemes()
    |> Enum.reverse()
    |> Stream.with_index()
    |> Enum.reduce([], fn {elem, index}, acc ->
      [{index, elem} | acc]
    end)
  end

  def parse_input(file) do
    data =
      "lib/day14/#{file}.txt"
      |> File.read!()
      |> String.split("\n")

    data
    |> Stream.map(fn inst ->
      if inst |> String.starts_with?("mask") do
        inst |> parse_mask()
      else
        [address, dec_value] =
          inst
          |> String.split("=")
          |> Enum.map(fn x -> x |> String.trim() end)

        {address, _} =
          address
          |> String.replace("mem[", "")
          |> String.replace("]", "")
          |> Integer.parse()

        bin_value =
          dec_value
          |> Integer.parse()
          |> elem(0)
          |> Integer.to_string(2)
          |> String.pad_leading(36, "0")

        {address, bin_value}
      end
    end)
    |> Enum.to_list()
  end
end
