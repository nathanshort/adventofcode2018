#!/usr/bin/env ruby

def part1( input, unit_to_skip = nil )

  stack = []
  input.each_char do |c|

    next if unit_to_skip == c.downcase

    if stack[-1] && ( stack[-1] != c ) && ( stack[-1].downcase == c.downcase )
      stack.pop
    else
      stack << c
    end
  end

  stack.size
end


def part2( input )

  # find unique units
  types = input.each_char.reduce( {} ) { | accum, elem | accum[elem.downcase] = 1; accum }

  lengths = []
  types.keys.each do |key|
    lengths << part1( input, key )
  end

  lengths.min
end


data = File.read( "5.input" )

puts "part 1 #{part1( data )}"
puts "part 2 #{part2( data )}"
