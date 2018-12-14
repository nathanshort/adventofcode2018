#!/usr/bin/ruby

initial = "#.#.#...#..##..###.##.#...#.##.#....#..#.#....##.#.##...###.#...#######.....##.###.####.#....#.#..##"


patterns = {
  "#...#" => "#", "....#" => ".", "##..#" => "#",
  ".#.##" => "#", "##.##" => ".", "###.#" => "#",
  "....." => ".", "...#." => ".", ".#.#." => "#",
  "#.##." => "#", "..#.#" => "#", ".#..." => "#",
  "#.#.." => ".", "##.#." => ".", ".##.." => "#",
  "#..#." => ".", ".###." => ".", "..#.." => ".",
  "#.###" => ".", "..##." => ".", ".#..#" => "#",
  ".##.#" => ".", ".####" => ".", "...##" => "#",
  "#.#.#" => "#", "..###" => ".", "#..##" => ".",
  "####." => "#", "#####" => ".", "###.." => "#",
  "##..." => "#", "#...." => "." }


def augment( pots )

  first_index = pots.first[0]
  last_index = pots.last[0]

  if ! pots.slice( 0, 3 ).all? { |x| x.last == '.' }
    ( 1 .. 3 ).each do |x|
      pots.unshift( [ first_index - x, '.' ] )
    end
  end

  if ! pots.slice( pots.size - 4, 3 ).all? { |x| x.last == '.' }
    ( 1 .. 3 ).each do |x|
      pots.push( [last_index + x, '.' ] )
    end
  end
end


# pots will keep track of the index of the char.  for example
# [[0, "#"], [1, "."], [2, "#"],... ]
pots = []
initial.chars.each_with_index { |char,index| pots << [ index, char ] }

(1..20).each do |iteration|

  result = []

  augment( pots )

  ( 0..( pots.size - 5  ) ).each do |iter|

    slice = pots.slice( iter, 5 )
    value = slice.reduce( "" ) { | accum, obj | accum << obj.last }

    match_made = false
    patterns.each do |pattern,outcome|
      if value == pattern
        match_made = true
        result << [ slice[2][0], outcome ]
        break
      end
    end

    if match_made == false
      raise "didnt match match #{value}"
    end
    
  end

  visual = result.reduce( "" ) { |accum, obj | accum << obj.last }
  pots = result
  score =  pots.reduce( 0 ) { |accum,obj| accum = accum + obj.first if obj.last == "#"; accum }
  p "#{iteration} #{score} #{visual}"
end



# visually inspecting the results, an infinite repeating sequence of 3 starts at iteration 100. ie
# 100 -> some set of pots 1
# 101 -> some set of pots 2
# 102 -> some set of pots 3
# 103 -> back to some set of pots 1
# ...

# At iteration 100, the first element in the set of pots is at position 50.  Therefore, when we are at iteration 50B, that same
# set of pots that is at 100, will be at 50B - with a starting position of 50B - 50

startpos = 50_000_000_000 - 50
fiftybil = ".....#..##..#..#..##..#..#..##..#..#..##..#..#..##..#..#..##..#..#..##..#..#..##..#..#..##..#..#..##..#..#..##..##....#..##..##..##..#..#..##....#..##..."
sum = 0 
fiftybil.chars.each_with_index { |char,index| sum = sum + startpos + index if char == "#" }
p "50B sum: #{sum}"

