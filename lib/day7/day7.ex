defmodule Aoc.Day7 do
  def part_1(file) do
    ["shiny_gold", ancestors] =
      build_tree(file)
      |> get_parents("shiny_gold")

    ancestors
    |> flatten
    |> Enum.uniq()
    |> Enum.count()
  end

  def part_2(file) do
    build_tree(file)
    |> get_children("shiny_gold")
    |> count()
  end

  def count([first, last]) when is_number(first) and is_number(last) do
    first * last
  end

  def count([first, second]) when is_number(first) do
    return =
      second
      |> count
      |> Kernel.*(first)
      |> Kernel.+(first)

    return
  end

  def count([first, second]) do
    first =
      first
      |> count

    second =
      second
      |> count

    first + second
  end

  def count([first]) do
    first
    |> count
  end

  def count([first | rest]) do
    first =
      first
      |> count

    rest =
      rest
      |> count

    first + rest
  end

  def get_children(tree, parent) do
    children =
      tree
      |> Enum.filter(fn {_child, parents} ->
        parents =
          parents
          |> Enum.filter(fn %{color: color, pattern: pattern} ->
            parent == "#{pattern}_#{color}"
          end)

        case parents do
          [] ->
            false

          _ ->
            true
        end
      end)

    case children |> Enum.count() do
      0 ->
        1

      _ ->
        children
        |> Enum.map(fn {child, parents} ->
          %{count: count} =
            parents
            |> Enum.filter(fn %{color: color, pattern: pattern} ->
              "#{pattern}_#{color}" == parent
            end)
            |> List.first()

          [count, get_children(tree, child)]
        end)
    end
  end

  def get_parents(tree, child) do
    fetched =
      tree
      |> Map.fetch(child)

    fetched =
      case fetched do
        {:ok, parents} ->
          parents
          |> Enum.map(fn %{color: color, pattern: pattern} ->
            get_parents(tree, "#{pattern}_#{color}")
          end)

        _ ->
          child
      end

    [child, fetched]
  end

  def build_tree(file) do
    File.read!("lib/day7/#{file}.txt")
    |> String.split("\n")
    |> Stream.filter(fn x -> x |> String.length() > 0 end)
    |> Enum.reduce(%{}, fn line, tree ->
      [container, contained] =
        line
        |> String.split("contain")

      [pattern, color, _bags] =
        container
        |> String.trim()
        |> String.split(" ")

      tree =
        contained
        |> String.split(",")
        |> Enum.reduce([], fn c, acc ->
          components =
            c
            |> String.split()
            |> Enum.map(fn x -> x |> String.trim() end)

          case components do
            ["no", "other", _bags] ->
              acc

            [count, comp_pattern, comp_color, _bags] ->
              {count, _} = count |> Integer.parse()
              [[comp_pattern, comp_color, count] | acc]
          end
        end)
        |> Enum.reduce(tree, fn [child_pattern, child_color, count], acc ->
          acc
          |> Map.update(
            "#{child_pattern}_#{child_color}",
            [%{pattern: pattern, color: color, count: count}],
            fn existing ->
              [%{pattern: pattern, color: color, count: count} | existing]
            end
          )
        end)

      tree
    end)
  end

  def flatten([head | tail]), do: flatten(head) ++ flatten(tail)
  def flatten([]), do: []
  def flatten(element), do: [element]
end
