#!/usr/bin/ruby

def doit( coords ) 
  
  xbounds = coords.map { |x| x.first }.minmax
  ybounds = coords.map { |y| y.last }.minmax
  
  areas = Array.new( coords.size, 0 )
  in_distance = 0

  (xbounds[0]..xbounds[1]).each do |x|
    (ybounds[0]..ybounds[1]).each do |y|

      # distance from this point to every input coordinate
      distances = coords.map do |coord|
        ( coord.first - x ).abs + ( coord.last - y ).abs
      end

      # part 2 - count if distance < 10k
      total_distance = distances.reduce( 0 ) { | accum, elem |  accum + elem  }
      if total_distance < 10000
        in_distance = in_distance + 1
      end

      # part 1
      # Find min distance between this point and all coordinates.
      # If there is only one input coordinate
      # with said distance, increment that coordinate's area
      min = distances.min
      accum = distances.each_with_index.reduce( [] ) do | accum, elem |
        accum << elem.last if elem.first == min
        accum
      end

      # if more than one input coordinate had same distance, then
      # noone gets more area
      if accum.size == 1
        areas[accum.first] = areas[accum.first] + 1
      end
      
    end
  end

  p areas.max
  p in_distance
end


coords = []
File.open( "6.input" ).each_line do |line|
  coords << line.split( ", " ).map{ |x| x.to_i }
end

doit( coords )

