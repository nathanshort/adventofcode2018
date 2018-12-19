#!/usr/bin/ruby

Point = Struct.new( :x, :y ) do

  def adjacents() 
    [
      Point.new( self.x, self.y - 1 ),
      Point.new( self.x + 1, self.y - 1 ),
      Point.new( self.x + 1, self.y ),
      Point.new( self.x + 1, self.y + 1 ),
      Point.new( self.x, self.y + 1 ),
      Point.new( self.x - 1, self.y + 1 ),
      Point.new( self.x - 1, self.y ),
      Point.new( self.x - 1, self.y - 1 ),
    ]
  end


  def at_least_how_many( map, what, how_many )
    count = 0
    self.adjacents.each do |adj|
      if map.key?( adj ) && map[adj] == what
        count = count + 1
        if count == how_many
          return true 
        end
      end
    end
    false
  end

end



def do_iteration( map, size )

  existing = map.dup
  
  (0..size - 1).each do |y|
    (0..size - 1).each do |x|
      
      point = Point.new( x, y )
      next_value = nil
      
      if map[point] == '.'
        if point.at_least_how_many( existing, '|', 3 )
          next_value = '|'
        else
          next_value = '.'
        end
        
      elsif map[point] == '|'
        if point.at_least_how_many( existing, '#', 3 )
          next_value = '#'
        else
          next_value = '|'
        end
      elsif map[point] == "#"
        
        if point.at_least_how_many( existing, '#', 1 ) &&
           point.at_least_how_many( existing, '|', 1 )
          next_value = "#"
        else
          next_value = "."
        end
        
      end

      map[point] = next_value
    end
  end
end


def score( map )
  wooded = map.values.select { |v| v == '|' }
  lumber_yards = map.values.select { |v| v == '#' }
  wooded.size * lumber_yards.size
end


map = {}
y = 0
File.open( "18.input" ) do |f|
  f.each_line do |line|
    line.chomp!
    line.chars.each_with_index do |char,index|
      point = Point.new( index, y )
      map[ point ] = char
    end
    y += 1
  end
end


size = 50
seen = {}
scores_by_iteration = []
repeat_on = nil
repeat_signature = nil

( 1..1000 ).each do |iteration|

  do_iteration( map, size )
  signature = map.values.join( "" )
  if seen.key?( signature )
    repeat_on = iteration
    repeat_signature = signature
    break
  end
  seen[signature] = iteration
  scores_by_iteration[iteration] = score( map )
end


if repeat_on == nil
  raise "didnt cycle!"
end

repeat_start = seen[repeat_signature]
cycle = repeat_on - repeat_start
iterations_needed = ( ( 1_000_000_000 - repeat_start ) % cycle )

p "part 1: #{scores_by_iteration[10]}"
p "part 2: #{scores_by_iteration[repeat_start + iterations_needed ]}"

