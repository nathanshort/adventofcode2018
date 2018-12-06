defmodule Aoc do
  def part1(string, skip \\ nil) do
    Enum.reduce(String.codepoints(string), [], fn char, accum ->
      if skip != String.capitalize(char) do
        # using a stack with the 1st element as most recent, as list
        # ops are a lot faster pushing + popping at the front
        first = List.first(accum)

        if first != nil && first != char && String.capitalize(char) == String.capitalize(first) do
          elem(List.pop_at(accum, 0), 1)
        else
          [char | accum]
        end
      else
        accum
      end
    end)
    |> Enum.count()
  end

  def part2(string) do
    # find unique units, iterate over them running part 1 for the list with unit removed
    Enum.reduce(String.codepoints(string), %{}, fn char, accum ->
      Map.put(accum, String.capitalize(char), 1)
    end)
    |> Map.keys()
    |> Enum.map(fn key -> Aoc.part1(string, key) end)
    |> Enum.min()
  end
end

string = File.read!("5.input")
IO.puts("part 1: #{Aoc.part1(string)}")
IO.puts("part 2: #{Aoc.part2(string)}")
