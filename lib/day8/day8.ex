defmodule Aoc.Day8 do
  def part_1(file) do
    parse_input(file)
    |> run_program({0, 0, []})
  end

  def part_2(file) do
    instructions = parse_input(file)

    instructions
    |> Stream.with_index()
    |> Stream.filter(fn {[instruction_type, _], _index} ->
      if instruction_type in ["nop", "jmp"] do
        true
      else
        false
      end
    end)
    |> Stream.map(fn {_instruction, index} ->
      index
    end)
    |> Stream.map(fn line_number ->
      [instruction_type, count] =
        instructions
        |> Enum.at(line_number)

      replacement_line =
        case instruction_type do
          "jmp" ->
            ["nop", count]

          "nop" ->
            ["jmp", count]
        end

      instructions
      |> List.replace_at(line_number, replacement_line)
      |> run_program({0, 0, []})
    end)
    |> Stream.filter(fn x -> not is_nil(x) end)
    |> Enum.map(fn x ->
      x |> IO.inspect()
    end)

    "Done"
  end

  def run_program(instructions, {current_line, accumulator, visited_lines}) do
    if current_line >= instructions |> Enum.count() do
      accumulator
    else
      if current_line not in visited_lines do
        new_visited_lines = [current_line | visited_lines]

        instruction = instructions |> Enum.at(current_line)

        {new_line, new_accumulator} =
          instruction
          |> process_instruction(
            current_line,
            accumulator
          )

        run_program(instructions, {new_line, new_accumulator, new_visited_lines})
      else
        nil
      end
    end
  end

  def process_instruction(["nop", _], current_line, accumulator) do
    {current_line + 1, accumulator}
  end

  def process_instruction(["acc", count], current_line, accumulator) do
    {current_line + 1, accumulator + count}
  end

  def process_instruction(["jmp", count], current_line, accumulator) do
    {current_line + count, accumulator}
  end

  def parse_input(file) do
    File.read!("lib/day8/#{file}.txt")
    |> String.split("\n")
    |> Enum.map(fn line ->
      [instruction_type, count] = line |> String.split(" ")

      {count, _} = count |> Integer.parse()

      [instruction_type, count]
    end)
  end
end
