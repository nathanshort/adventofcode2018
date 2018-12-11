#!/usr/bin/ruby

Point = Struct.new( :x, :y,:xvel, :yvel ) {}

def print_sky( sky )

  xmin = ymin = xmax = ymax = nil

  # figure out the range of this sky
  sky.each do |k,v|
    x,y = k.split( "," )
    xmin = x.to_i if ( xmin.nil? || x.to_i < xmin )
    xmax = x.to_i if ( xmax.nil? || x.to_i > xmax )
    ymin = y.to_i if ( ymin.nil? || y.to_i < ymin )
    ymax = y.to_i if ( ymax.nil? || y.to_i > ymax )
  end

  (ymin..ymax).each do |y|
    line = ""
    (xmin..xmax).each do |x|
      key = "#{x},#{y}"
      if sky.key?( key )
        line << "#"
      else
        line <<  "."
      end
    end
    puts line
  end
  puts "\n\n";

end


# the algo is to find the tick whereby there are the most rows all at the same column.
# that is our guess that its a word.  cheating a little bit in that
#
#  1) we're passing in an iteration count - should have some programatic stopping point
#  2) we might just be getting lucky that this works.  but hey - thats what a heuristic is..
#
def find_word( file, target_letter_height, iterations )

  points = []
  File.open( file , "r" ) do |f|
    f.each_line do |line|
      matches = /position=<\s*([^\s]+),\s*([^\s]+)> velocity=<\s*([^\s]+),\s*([^\s]+)>/.match( line )
      points << Point.new( matches[1].to_i, matches[2].to_i, matches[3].to_i, matches[4].to_i )
    end
  end

  iter_counter = 0
  candidate_grid = nil
  candidate_iteration = nil
  cols_at_height_current = 0
  
  loop do

    break if iter_counter >= iterations

    allpoints = {}
    xmaxes = Hash.new( 0 )
    
    points.each do |p|
      p.x = p.xvel + p.x 
      p.y = p.yvel + p.y 
      key = "#{p.x},#{p.y}"
      
      # if we have not yet seen this point, then count its x pos
      if ! allpoints.key?( key )
        xmaxes[p.x] = xmaxes[p.x] + 1
      end
      
      allpoints[key] = 1
    end

    # figure out how many columns we have, that are at the same row value
    cols_at_height = 0
    xmaxes.each do |k,v|
      cols_at_height = cols_at_height + 1 if v == target_letter_height
    end

    if cols_at_height > cols_at_height_current
      cols_at_height_current = cols_at_height
      candidate_grid = allpoints.dup
      candidate_iteration = iter_counter
    end
    
    iter_counter += 1
  end

  [ candidate_iteration + 1, candidate_grid ]
end




#candidate_iterations, candidate_grid = find_word( "10.test.input", 8, 5 )
candidate_iterations, candidate_grid = find_word( "10.input", 10, 11000 ) 

print_sky( candidate_grid )
puts "grid was found at iteration: #{candidate_iterations}"


