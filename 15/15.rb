#!/usr/bin/ruby

require 'set'

Creature = Struct.new( :type, :power, :hitpoints ) {}

Point = Struct.new( :x, :y ) do

  # order is important here, as we are rotating in reading order
  def adjacents() 
    [ Point.new( self.x, self.y - 1 ),
      Point.new( self.x - 1, self.y ),
      Point.new( self.x + 1, self.y ),
      Point.new( self.x, self.y + 1 )
    ]
  end

end



def print_map( map, creatures )

  reverse = { :wall => '#', :open => '.' }
  ( 0..10).each do |y|
    line = ""
    creatures_this_line = []
    
    ( 0..10).each do |x|
      point = Point.new( x, y )
      if creatures.key?( point )
        line << creatures[point].type
        creatures_this_line << "#{creatures[point][:type]}(#{creatures[point][:hitpoints]})"
      elsif map.key?( point )
        line << reverse[ map[ point ] ]
      end
    end
    puts "#{line} #{creatures_this_line.join(", ")}"
  end

end



def attack( current_point, current_creature, creatures, die_on_elf_death )

  attack_candidates = []
  current_point.adjacents.each do |adjacent|
    
    if creatures.key?( adjacent ) && creatures[adjacent][:type] != current_creature[:type]
      attack_candidates << { :point => adjacent, :creature => creatures[ adjacent ] }
    end
  end

   # sort attack candidates by
   # 1) hitpoints
   # 2) reading distance
   sorted_attack_candidates = attack_candidates.sort do |a,b|
     bypoints = a[:creature][:hitpoints] <=> b[:creature][:hitpoints]
     if bypoints != 0
       bypoints
     else
       by_y = a[:point].y <=> b[:point].y
       if by_y != 0
         by_y
       else
         a[:point].x <=> b[:point].x
       end
     end
     end

   if sorted_attack_candidates.size != 0
     creatures[ sorted_attack_candidates[0][:point]][:hitpoints] -= current_creature[:power]
     if creatures[ sorted_attack_candidates[0][:point] ][:hitpoints] <= 0

       if die_on_elf_death && creatures[sorted_attack_candidates[0][:point]][:type] == 'E'
         p "not enough hp"
         exit
       end
       creatures.delete( sorted_attack_candidates[0][:point] )
     end
   end

   return sorted_attack_candidates.size != 0
end



def find_closest_point( point, map, creatures, creature_adjacent_points )

  goal = 1_000_000
  queue = []
  queue << { :point => point, :distance => 0, :source => nil }
  already_seen = {}
  candidates = []
  
  while queue.size != 0

    item = queue.shift
    point, distance, source = item[:point], item[:distance], item[:source]
    break if distance > goal

    if ( map[ point ] == :wall ) ||
       ( distance > 0 && ( creatures.key?( point ) ||
                           already_seen.key?( point ) ) )
      next
    end

    already_seen[point] = 1
    
    if distance == 1
      source = point
    end
    if creature_adjacent_points.include?( point )
      goal = distance
      candidates << { :point => point, :distance => distance, :source => source }
    end
    point.adjacents.each do |adj|
      queue << { :point => adj, :distance => distance + 1, :source => source }
    end
    
  end


  # seriously??
  sorted_candidates = candidates.sort do |a,b|
    by_distance = a[:distance] <=> b[:distance]
    if by_distance != 0
      by_distance
    else
      by_target_y = a[:point][:y] <=> b[:point][:y]
      if by_target_y != 0
        by_target_y
      else
        by_target_x = a[:point][:x] <=> b[:point][:x]
        if by_target_x != 0
          by_target_x
        else
          by_source_y = a[:source][:y] <=> b[:source][:y]
          if by_source_y != 0
            by_source_y
          else
            a[:source][:x] <=> b[:source][:x]
          end
        end
      end
    end
  end

  
  if sorted_candidates.size == 0
    return nil
  end

  min = sorted_candidates[0]
  if min[:distance] >= 1
    min[:source]
  else
    nil
  end

end




def read_map( elf_power )

  y = 0
  map = {}
  creatures = {}
  
  File.open( "15.input" , "r" ) do |f|
    f.each_line do |line|

      line.chomp!
      line.chars.each_with_index do |char,x|
        point = Point.new( x, y )

        if char == '#'
          map[ point ] = :wall
        elsif char == "."
          map[ point ] = :open
        elsif char == 'G' 
          map[ point ] = :open
          creatures[ point ] = Creature.new( char, power = 3, hitpoints = 200 )
        elsif char == 'E'
          map[ point ] = :open
          creatures[ point ] = Creature.new( char, elf_power, hitpoints = 200 )
        end
      end
      y += 1
    end
  end

  [ map, creatures ]
end


def summarize_creatures( creatures )

  left = { 'E' => 0, 'G' => 0 }
  hp = 0
  creatures.each do|point,creature|
    hp += creature.hitpoints
    left[creature.type] += 1
  end

  [ left, hp ]
end



def fight( map, creatures, die_on_elf_death )
  
  iteration = 1
  loop do
    
    sorted_creature_points = creatures.keys.sort do |a,b|
      ysort = a.y <=> b.y
      if ysort != 0
        ysort
      else
        a.x <=> b.x
      end
    end

    
    sorted_creature_points.each do | current_creature_point |
      
      # might have been killed off
      next if ! creatures.key?( current_creature_point )
      
      current_creature = creatures[current_creature_point]
      
      if attack( current_creature_point, current_creature, creatures, die_on_elf_death ) 
        
        creatures_left, hp = summarize_creatures( creatures )
        if creatures_left['E'] == 0 || creatures_left['G'] == 0
          return [ iteration - 1, hp ]
        end
        
        # next creature - dont move if we attacked first
        next
      end

      # find all open points next to all creatures
      creature_adjacent_points = Set.new
      creatures.each do |coordinate, vs_creature |
        next if current_creature.type == vs_creature.type
        coordinate.adjacents.each do |adjacent|
          
          if ! creatures.key?( adjacent ) &&
             map.key?( adjacent ) && map[adjacent] == :open 
            creature_adjacent_points.add( adjacent )
          end
        end
      end


      next_point = find_closest_point( current_creature_point, map, creatures, creature_adjacent_points )
      if next_point 
        creatures.delete( current_creature_point )
        creatures[ next_point ] = current_creature

        if attack( next_point, current_creature, creatures, die_on_elf_death )

          creatures_left, hp = summarize_creatures( creatures )
          if creatures_left['E'] == 0 || creatures_left['G'] == 0
            return [ iteration - 1, hp ]
          end
        
        end
      end
    end

    iteration = iteration + 1
  end
end


map, creatures = read_map( elf_power = 3 )
iteration, hp = fight( map, creatures, die_on_elf_death = false )
p "part1: #{iteration * hp}"


# could have looped till we found the spot. instead, i just did a binary search by hand :)
map, creatures = read_map( elf_power = 14 )
iteration, hp = fight( map, creatures, die_on_elf_death = true )
p "part2: #{iteration * hp}"
