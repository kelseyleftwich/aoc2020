defmodule Aoc.Day11 do
  def part_1(file) do
    data =
      file
      |> parse_input()

    row_count = data |> Enum.count()
    col_count = data |> List.first() |> Enum.count()

    dictionary =
      data
      |> get_dictionary()

    dictionary
    |> run_round(row_count, col_count)
    |> print
    |> count_occupied()


  end
  def count_occupied(dictionary) do
    dictionary
    |> Enum.reduce(0, fn {_, row}, acc ->

      row
      |> Stream.filter(fn cell -> cell == "#" end)
      |> Enum.count()
      |> Kernel.+(acc)
    end)
  end

  def run_round(dictionary, row_count, col_count) do
    new_dict =
      0..(row_count - 1)
      |> Enum.reduce(dictionary, fn row_index, d_r ->
        0..(col_count - 1)
        |> Enum.reduce(d_r, fn col_index, d_c ->
          processed_cell =
            dictionary
            |> process_cell({row_index, col_index})

          d_c
          |> update_dictionary_cell({row_index, col_index}, processed_cell)
        end)
      end)


    if dictionary
       |> Map.equal?(new_dict) do
      new_dict
    else
      run_round(new_dict, row_count, col_count)
    end
  end

  def get_dictionary(data) do
    data
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {row, row_index}, dict ->
      dict
      |> Map.put(
        row_index |> to_string |> String.to_atom(),
        row
        |> Stream.map(fn cell ->
          cell
        end)
        |> Enum.to_list()
      )
    end)
  end

  def process_cell(dictionary, {row_index, col_index}) do
    current_cell =
      dictionary
      |> get_cell_from_dict({row_index, col_index})

      case current_cell do
        "L" ->
          if dictionary |> occupied_surrounding_cells?({row_index, col_index}) do
            "L"
          else
            "#"
          end

        "." ->
          "."

        "#" ->
          if dictionary
             |> get_surrounding_cells({row_index, col_index})
             |> Stream.filter(fn cell -> cell == "#" end)
             |> Enum.count()
             |> Kernel.>(3) do
            "L"
          else
            "#"
          end
      end
  end

  def occupied_surrounding_cells?(dictionary, {row_index, col_index}) do
    dictionary
    |> get_surrounding_cells({row_index, col_index})
    |> Stream.filter(fn cell -> cell == "#" end)
    |> Enum.count()
    |> Kernel.>(0)
  end

  def get_surrounding_cells(dictionary, {row_index, col_index}) do
    [
      # UL
      {-1, -1},
      # U
      {-1, 0},
      # UR
      {-1, 1},
      # D
      {1, 0},
      # DL
      {1, -1},
      # DR
      {1, 1},
      # L
      {0, -1},
      # R
      {0, 1}
    ]
    |> Enum.map(fn {row_add, col_add} ->
      dictionary
      |> get_cell_from_dict({row_index + row_add, col_index + col_add})
    end)
  end

  def get_cell_from_dict(_, {row_index, col_index}) when row_index < 0 or col_index < 0 do
    nil
  end

  def get_cell_from_dict(dictionary, {row_index, col_index}) do
    row =
      dictionary
      |> Map.get(row_index |> to_string |> String.to_atom())

    case row do
      nil ->
        nil

      _ ->
        row
        |> Enum.at(col_index)
    end
  end

  def update_dictionary_cell(dictionary, {row_index, col_index}, cell) do
    dictionary
    |> Map.update(row_index |> to_string |> String.to_atom(), [], fn row ->
      row
      |> List.update_at(col_index, fn _ -> cell end)
    end)
  end

  def print(data) do
    data
    |> Stream.map(fn {_, row} ->
      row
      |> Enum.map(fn cell ->
        case cell do
          "L" ->
            (IO.ANSI.green() <> cell) |> IO.write()

          "#" ->
            (IO.ANSI.red() <> cell) |> IO.write()

          "." ->
            (IO.ANSI.light_black() <> cell) |> IO.write()
        end
      end)

      IO.write("\n")
    end)
    |> Enum.to_list()

    data
  end

  def parse_input(file) do
    "lib/day11/#{file}.txt"
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(fn row ->
      row
      |> String.graphemes()
    end)
    |> Enum.to_list()
  end

  def max_col([{_, col_index, _} | rest], counter) do
    if(col_index >= counter) do
      max_col(rest, col_index)
    else
      counter
    end
  end
end
