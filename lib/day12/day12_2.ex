defmodule Aoc.Day12_2 do
  def part_2(file) do
    instructions =
      file
      |> parse_input()

    {x_pos, y_pos, _facing} =
      {0, 0, "E"}
      |> parse_instructions({10, 1}, instructions)

    abs(x_pos) + abs(y_pos)
  end

  def parse_instructions(ship_position, _waypoint_position, []) do
    ship_position
  end

  def parse_instructions(ship_position, waypoint_position, [{direction, count} | remaining]) do
    {ship_position, waypoint_position} =
      get_new_position(ship_position, waypoint_position, {direction, count})

    parse_instructions(ship_position, waypoint_position, remaining)
  end

  def get_new_position(
        {x, y, facing} = ship_position,
        {w_x, w_y} = waypoint_pos,
        {direction, count}
      ) do
    case direction do
      "N" ->
        {ship_position, {w_x, w_y + count}}

      "S" ->
        {ship_position, {w_x, w_y - count}}

      "E" ->
        {ship_position, {w_x + count, w_y}}

      "W" ->
        {ship_position, {w_x - count, w_y}}

      "L" ->
        {ship_position, waypoint_pos |> move_waypoint(direction, count)}

      "R" ->
        {ship_position, waypoint_pos |> move_waypoint(direction, count)}

      "F" ->
        ship_position = {x + w_x * count, y + w_y * count, facing}

        {ship_position, waypoint_pos}
    end
  end

  def move_waypoint(waypoint_pos, "L", deg) do
    move_waypoint(waypoint_pos, "R", -deg)
  end

  def move_waypoint({x, y}, "R", deg) do
    deg =
      if deg < 0 do
        rem(deg + 360, 360)
      else
        rem(deg, 360)
      end

    case deg do
      90 ->
        {y, -x}

      180 ->
        {-x, -y}

      270 ->
        {-y, x}

      360 ->
        {x, y}
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
