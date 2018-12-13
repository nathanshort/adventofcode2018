#!/usr/bin/ruby

def calc_powers( serial )

  powers = {}
  sat = {}
  length = 300
  
  ( 1..length ).each do |y|
    ( 1..length ).each do |x|
      
      rack_id = x + 10
      power = rack_id * y
      power += serial
      power *= rack_id
      digit = nil
      if( power < 100 )
        digit = 0
      else
        digit = power.to_s[-3].to_i
      end
      
      power = digit
      power -= 5
      powers[[x,y]] = power
    end
  end

  # https://en.wikipedia.org/wiki/Summed-area_table
  sat = {}
  ( 1..length ).each do |y|
    ( 1..length ).each do |x|
      sat[[x,y]] =
        powers[[x,y]] +
        ( sat[[x,y-1]]  || 0 ) +
        ( sat[[x-1,y]] || 0 ) -
        ( sat[[x-1,y-1]] || 0 )
    end
  end

  [ powers, sat ]
end



def find_max_area( powers, sat, size_min, size_max )

  max_sum = 0
  coord = nil
  length = 300
  
  (size_min..size_max).each do |size| 
    offset = size - 1
    ( 1..( length - offset ) ).each do |y|
      ( 1..( length - offset )).each do |x|
        
        sum =
          ( sat[[x +size -1,y+size -1]] || 0 ) + ( sat[[x-1,y-1]] || 0 ) - ( sat[[x+size-1,y-1]] || 0 ) - ( sat[[x-1,y+size-1]] || 0 )
        
        if sum > max_sum
          max_sum = sum
          coord = "#{x},#{y},#{size}"
        end
      end
    end
  end

  coord
end

powers, sat = calc_powers( serial = 7803 )

p find_max_area( powers, sat, size_min = 3, size_max = 3 )
p find_max_area( powers, sat, size_min = 1, size_max = 300 )

