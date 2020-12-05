defmodule Aoc.Day5 do
  def part_1 do
    parse_input()
    |> Stream.map(fn pass ->
      {_row, _col, id} = pass |> seat_id
      id
    end)
    |> Enum.max()
  end

  def part_2 do
    parse_input()
    |> Stream.map(fn pass ->
      {_row, _col, id} = pass |> seat_id
      id
    end)
    |> Enum.sort()
    |> find_missing
  end

  def find_missing([a | tail]) do
    [b | [c | _]] = tail

    if a + 1 == b and b + 1 == c do
      find_missing(tail)
    else
      {a, b, c}
    end
  end

  def seat_id(pass) do
    {row_chars, col_chars} = pass |> String.split_at(7)

    row = row_chars |> String.graphemes() |> find_row()
    col = col_chars |> String.graphemes() |> find_column()

    {row, col, row * 8 + col}
  end

  def find_row(pass) do
    find_row(pass, 0..127)
  end

  def find_row([head], rows) do
    keep.._ = rows |> get_correct_half(head, "B", "F")
    keep
  end

  def find_row([head | tail], rows) do
    kept_half = rows |> get_correct_half(head, "B", "F")
    find_row(tail, kept_half)
  end

  def find_column(pass) do
    find_column(pass, 0..7)
  end

  def find_column([head], cols) do
    keep.._ = cols |> get_correct_half(head, "R", "L")
    keep
  end

  def find_column([head | tail], cols) do
    kept_half = cols |> get_correct_half(head, "R", "L")
    find_column(tail, kept_half)
  end

  def get_correct_half(range, pass_char, upper_char, lower_char) do
    {upper_half, lower_half} = range |> get_halves()

    case pass_char do
      ^upper_char ->
        upper_half

      ^lower_char ->
        lower_half
    end
  end

  def get_halves(range) do
    first..last = range
    upper_half_start = ((last - first + 1) / 2) |> round |> Kernel.+(first)
    upper_half = upper_half_start..last
    lower_half = first..(upper_half_start - 1)
    {upper_half, lower_half}
  end

  def parse_input do
    File.read!("lib/day5/input.txt")
    |> String.split("\n")
  end
end
