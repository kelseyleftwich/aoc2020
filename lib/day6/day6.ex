defmodule Aoc.Day6 do
  def part_1(file) do
    File.read!("lib/day6/#{file}.txt")
    |> String.split("\n\n")
    |> Stream.map(fn x ->
      x
      |> String.replace("\n", "")
      |> String.graphemes()
      |> Stream.uniq()
      |> Enum.to_list()
    end)
    |> Enum.reduce(0, fn x, acc ->
      x
      |> length()
      |> Kernel.+(acc)
    end)
  end

  def part_2(file) do
    File.read!("lib/day6/#{file}.txt")
    |> String.split("\n\n")
    |> Stream.map(fn x ->
      individuals =
        x
        |> String.split("\n")

      chars =
        x
        |> String.replace("\n", "")
        |> String.graphemes()
        |> Enum.uniq()

      chars
      |> Enum.reduce(0, fn char, char_acc ->
        all_have_char? =
          individuals
          |> Enum.reduce(true, fn answers, answers_acc ->
            answers_acc and answers |> String.contains?(char)
          end)

        if(all_have_char?) do
          char_acc + 1
        else
          char_acc
        end
      end)
    end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)

  end
end
