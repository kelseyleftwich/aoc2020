defmodule Aoc.Day13 do
  def part_1(file) do
    {earliest_depature, buses_stream} =
      file
      |> parse_input()

    buses_stream
    |> Stream.map(fn id ->
      {id, id - rem(earliest_depature, id)}
    end)
    |> Enum.sort(fn {_, minutes_to_next_a}, {_, minutes_to_next_b} ->
      minutes_to_next_a < minutes_to_next_b
    end)
    |> List.first()
    |> Tuple.to_list()
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  def part_2(file) do
    buses =
      file
      |> parse_input_2()

    {starters, rest} = buses |> Enum.split(2)

    0 |> run_round(starters, rest, 1)
  end

  def run_round(t, starters, rest, incrementer) do
    t_works =
      starters
      |> Enum.map(fn {bus_id, index} ->
        rem(t + index, bus_id) == 0
      end)
      |> Enum.reduce(true, fn elem, acc ->
        acc and elem
      end)

    if t_works do
      case rest do
        [] ->
          t

        _ ->
          incrementer = starters |> multiply_all()

          [next | rest] = rest

          starters = [next | starters]

          run_round(t + incrementer, starters, rest, incrementer)
      end
    else
      run_round(t + incrementer, starters, rest, incrementer)
    end
  end

  def multiply_all(buses) do
    buses
    |> Enum.reduce(1, fn {bus_id, _}, acc ->
      acc * bus_id
    end)
  end

  def parse_input(file) do
    [earliest_departure, buses] =
      "lib/day13/#{file}.txt"
      |> File.read!()
      |> String.split("\n")

    {earliest_departure, _} =
      earliest_departure
      |> Integer.parse()

    buses_stream =
      buses
      |> String.split(",")
      |> Stream.filter(fn x -> x != "x" end)
      |> Stream.map(fn x ->
        {x, _} = Integer.parse(x)
        x
      end)

    {earliest_departure, buses_stream}
  end

  def parse_input_2(file) do
    [_, buses] =
      "lib/day13/#{file}.txt"
      |> File.read!()
      |> String.split("\n")

    buses
    |> String.split(",")
    |> Stream.with_index()
    |> Stream.filter(fn {elem, _index} ->
      elem != "x"
    end)
    |> Stream.map(fn {x, index} ->
      {x, _} = Integer.parse(x)
      {x, index}
    end)
    |> Enum.to_list()
  end
end
