defmodule Aoc3 do
  # return list of maps - each map describing the claim
  def get_claims(file) do
    File.stream!(file)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce([], fn row, accum ->
      match =
        Regex.named_captures(
          ~r/^#(?<claimnum>\d+) @ (?<xstart>\d+),(?<ystart>\d+): (?<width>\d+)x(?<height>\d+)$/,
          row
        )

      accum ++ [match]
    end)
  end

  def mark_area(claim, accum) do
    xstart = String.to_integer(claim["xstart"])
    ystart = String.to_integer(claim["ystart"])

    Enum.reduce(0..(String.to_integer(claim["width"]) - 1), accum, fn xoffset, accum ->
      x = xstart + xoffset

      Enum.reduce(0..(String.to_integer(claim["height"]) - 1), accum, fn yoffset, accum ->
        y = ystart + yoffset
        key = "#{x},#{y}"

        if Map.has_key?(accum, key),
          do: Map.put(accum, key, Map.get(accum, key) + 1),
          else: Map.put(accum, key, 1)
      end)
    end)
  end

  # this should be consolidated with mark_area
  def count_marks(claim, full) do
    xstart = String.to_integer(claim["xstart"])
    ystart = String.to_integer(claim["ystart"])

    Enum.reduce(0..(String.to_integer(claim["width"]) - 1), 0, fn xoffset, accum ->
      x = xstart + xoffset

      Enum.reduce(0..(String.to_integer(claim["height"]) - 1), accum, fn yoffset, accum ->
        y = ystart + yoffset
        key = "#{x},#{y}"

        if full[key] > 1,
          do: accum + 1,
          else: accum
      end)
    end)
  end

  def part1(full_map) do
    full_map
    |> Enum.reduce(0, fn item, accum -> if elem(item, 1) > 1, do: accum + 1, else: accum end)
  end

  def part2(full_map, claims) do
    Enum.reduce_while(claims, %{}, fn claim, _ ->
      if Aoc3.count_marks(claim, full_map) > 0 do
        {:cont, %{}}
      else
        {:halt, claim}
      end
    end)
  end
end

claims = Aoc3.get_claims("3.input")
full_map = Enum.reduce(claims, %{}, fn claim, accum -> Aoc3.mark_area(claim, accum) end)

IO.puts("part 1: #{Aoc3.part1(full_map)}")
IO.inspect(Aoc3.part2(full_map, claims))
