defmodule Aoc4 do
  def get_ranges(row, accum) do
    # accum is tuple of { current guard, last time minutes, all_data }
    guard = elem(accum, 0)
    data = elem(accum, 2)

    if wake_match =
         Regex.named_captures(
           ~r/:(?<mm>\d{2})\] wakes/,
           row
         ) do
      last_time = elem(accum, 1)
      range = String.to_integer(last_time)..(String.to_integer(wake_match["mm"]) - 1)

      if Map.has_key?(data, guard) do
        {guard, nil, Map.put(data, guard, [range | Map.get(data, guard)])}
      else
        {guard, nil, Map.put(data, guard, [range])}
      end
    else
      if begin_match =
           Regex.named_captures(
             ~r/Guard #(?<guard>.*) begins/,
             row
           ) do
        {begin_match["guard"], nil, data}
      else
        sleep_match =
          Regex.named_captures(
            ~r/:(?<mm>\d{2})\] falls/,
            row
          )
        {guard, sleep_match["mm"], data}
      end
    end
  end

  # returns a map of guard => [ list of ranges that the guard is asleep ].  ie:
  # %{
  #  "1021" => [55..57, 23..47, 16..47, 56..58, 51..52, 24..38, 20..30, 47..55,
  #  36..43, 4..33, 6..57, 38..39, 46..56, 4..5, 5..39, 19..54],
  def get_ranges(file) do
    times =
      File.stream!(file)
      |> Enum.map(&String.trim/1)
      |> Enum.sort()
      |> Enum.reduce({nil, %{}, %{}}, fn row, accum -> Aoc4.get_ranges(row, accum) end)

    elem(times, 2)
  end

  def part1(file) do
    times = Aoc4.get_ranges(file)

    sleepiest =
      Enum.reduce(times, %{}, fn {guard, ranges}, accum ->
        minutes = Enum.reduce(ranges, 0, fn range, accum -> accum + Enum.count(range) end)
        Map.put(accum, minutes, guard)
      end)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(1)

    # we only have the guard - now we need to find the time they sleep the most
    guard = elem(List.first(sleepiest), 1)

    map_by_minute =
      Enum.reduce(Map.get(times, guard), %{}, fn range, accum ->
        Enum.reduce(range, accum, fn elem, accum ->
	  Map.update( accum, elem, 1, &( &1 + 1 ) )
        end)
      end)

    max_min =
      Enum.reduce(map_by_minute, {0, nil}, fn {k, v}, accum ->
        if v > elem(accum, 0), do: {v, k}, else: accum
      end)

    max_mins = elem(max_min, 1)
    IO.puts("#{String.to_integer(guard) * max_mins}")
  end

  
  def max_min_per_guard(ranges) do
    Enum.reduce(ranges, %{}, fn range, accum ->
      Enum.reduce(range, accum, fn elem, accum ->
	Map.update( accum, elem, 1, &( &1 + 1 ) )	
      end)
    end)
    |> Enum.reduce({0, nil}, fn {k, v}, accum ->
      if v > elem(accum, 0), do: {v, k}, else: accum
    end)
  end

  
  def part2(file) do
    times = Aoc4.get_ranges(file)

    result =
      Enum.reduce(times, %{}, fn {guard, ranges}, accum ->
        Map.put(accum, guard, Aoc4.max_min_per_guard(ranges))
      end)

      # { max, atminute, guard }
      |> Enum.reduce({0, nil, nil}, fn {k, v}, accum ->
        if elem(v, 0) > elem(accum, 0) do
          {elem(v, 0), elem(v, 1), k}
        else
          accum
        end
      end)

    IO.puts("#{String.to_integer(elem(result, 2)) * elem(result, 1)}")
  end
end

# this whole day4 is a disaster. need better functionality for map create or update by key
# and, i should have just stored mins slept by guard[min], instead of storing as ranges from the beginning

Aoc4.part1("4.input")
Aoc4.part2("4.input")
