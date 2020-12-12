defmodule Aoc.Day12 do
  def part_1(file) do
    instructions =
      file
      |> parse_input()

    {x_pos, y_pos, _facing} =
      {0, 0, "E"}
      |> parse_instructions(instructions)

    abs(x_pos) + abs(y_pos)
  end

  def parse_instructions(position, []) do
    position
  end

  def parse_instructions(position, [{direction, count} | remaining]) do
    position = get_new_position(position, {direction, count})

    parse_instructions(position, remaining)
  end

  def get_new_position({x, y, facing}, {direction, count}) do
    case direction do
      "N" ->
        {x, y + count, facing}

      "S" ->
        {x, y - count, facing}

      "E" ->
        {x + count, y, facing}

      "W" ->
        {x - count, y, facing}

      "L" ->
        {x, y, facing |> get_new_orientation(count, "L")}

      "R" ->
        {x, y, facing |> get_new_orientation(count, "R")}

      "F" ->
        get_new_position({x, y, facing}, {facing, count})
    end
  end

  def get_new_orientation(facing, deg, "L") do
    facing
    |> get_degrees_for_facing()
    |> Kernel.-(deg)
    |> rem(360)
    |> get_facing_for_degrees()
  end

  def get_new_orientation(facing, deg, "R") do
    facing
    |> get_degrees_for_facing()
    |> Kernel.+(deg)
    |> rem(360)
    |> get_facing_for_degrees()
  end

  def get_degrees_for_facing(facing) do
    %{"N" => 0, "E" => 90, "S" => 180, "W" => 270}
    |> Map.get(facing)
  end

  def get_facing_for_degrees(deg) do
    deg =
      if deg < 0 do
        deg + 360
      else
        deg
      end

    case deg do
      0 ->
        "N"

      90 ->
        "E"

      180 ->
        "S"

      270 ->
        "W"
    end
  end

  def parse_input(file) do
    "lib/day12/#{file}.txt"
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(fn instruction ->
      {direction, count} =
        instruction
        |> String.split_at(1)

      {count, _} = count |> Integer.parse()

      {direction, count}
    end)
    |> Enum.to_list()
  end
end
