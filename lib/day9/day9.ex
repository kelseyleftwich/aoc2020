defmodule Aoc.Day9 do
  def part_1(file, preamble_length) do
    data = parse_input(file)

    {initial_preamble, rest} =
      data
      |> Enum.split(preamble_length)

    [first | remaining] = data |> Enum.to_list()

    initial_preamble
    |> check_for_sums(rest)
    |> find_contiguous([first], remaining)
    |> get_weakness()
  end

  def get_weakness({smallest, largest}) do
    smallest + largest
  end

  def find_contiguous(target, range, [head | tail] = rest) do
    sum =
      range
      |> Enum.reduce(0, fn x, acc ->
        acc + x
      end)

    with {:gt, false} <- {:gt, sum > target},
         {:lt, false} <- {:lt, sum < target} do
      min = range |> Enum.min()
      max = range |> Enum.max()
      {min, max}
    else
      {:gt, true} ->
        [_ | range] = range

        find_contiguous(target, range, rest)

      {:lt, true} ->
        range =
          range
          |> Enum.reverse()
          |> List.insert_at(0, head)
          |> Enum.reverse()

        find_contiguous(target, range, tail)
    end
  end

  def check_for_sums(preamble, [head | tail]) do
    case preamble |> find_sum(head) do
      nil ->
        head

      _ ->
        [_ | rest] = preamble

        preamble =
          rest
          |> Enum.reverse()
          |> List.insert_at(0, head)
          |> Enum.reverse()

        check_for_sums(preamble, tail)
    end
  end

  def find_sum([_], _target) do
    nil
  end

  def find_sum(arr, target) do
    arr =
      arr
      |> Enum.sort()

    [first | _] = arr
    last = arr |> List.last()

    current_sum = first + last

    with {:gt, false} <- {:gt, current_sum > target},
         {:lt, false} <- {:lt, current_sum < target} do
      {first, last}
    else
      {:gt, true} ->
        arr =
          arr
          |> Enum.reverse()
          |> tl()
          |> Enum.reverse()

        arr
        |> find_sum(target)

      {:lt, true} ->
        [_ | arr] = arr

        arr
        |> find_sum(target)
    end
  end

  def parse_input(file) do
    File.read!("lib/day9/#{file}.txt")
    |> String.split("\n")
    |> Stream.map(fn n ->
      {n, _} = n |> Integer.parse()
      n
    end)
  end
end
