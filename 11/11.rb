#!/usr/bin/ruby


#Find the fuel cell's rack ID, which is its X coordinate plus 10.
#Begin with a power level of the rack ID times the Y coordinate.
#Increase the power level by the value of the grid serial number (your puzzle input).
#Set the power level to itself multiplied by the rack ID.
#Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0).
#Subtract 5 from the power level.


#1 2 3 4 5
#1 2 3 4 5
#1 2 3 4 5


# sum 0, 0, 1, powers, cache
def sum( x, y, size, powers, cache )

  previous_key = "#{x},#{y},#{size-1}"
  sum = cache[previous_key] || 0

  if size > 1
    
  ( x..( x + size - 1 ) ).each do |xrange|
    key = "#{xrange},#{y+size-1}"
#    p "xxx #{x} #{y} #{key}"
    sum += powers[key]
  end

  ( y..( y + size - 2 ) ).each do |yrange|
    key = "#{x+size-1},#{yrange}"
 #   p "yyy #{x} #{y} #{key}"
    sum += powers[key]
  end
  end
  
#  p "done"
  key = "#{x},#{y},#{size}"
  cache[key] = sum
  sum
end


serial = 7803


powers = {}

( 1..300 ).each do |y|
  ( 1..300 ).each do |x|
    
    rack_id = x + 10
    power = rack_id * y
    power += serial
    power *= rack_id
    digit = nil
    if( power < 100 )
      digit = 0
    else
      digit = power.to_s[-3]
      if digit.nil?
        digit = 0
      else
        digit = digit.to_i
      end
    end

    power = digit
    power -= 5
    powers["#{x},#{y}"] = power
  end
end


max_sum = 0
coord = nil
cache = {}

( 1..300).each do |size|
  p "SIZE #{size}"
  ( 1..300).each do |xrange|
    break if ( xrange + size > 300 )
    
    ( 1..300).each do |yrange|
      break if ( yrange + size > 300 )
      
      sum = sum( xrange, yrange, size, powers, cache )

      if sum > max_sum
        max_sum = sum
        coord = "#{xrange},#{yrange},#{size}"
      end

#      p "cache #{cache}"

    end
  end
end


p coord
