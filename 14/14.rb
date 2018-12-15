#!/usr/bin/ruby

def scores_and_positions( elf_positions, scores )

  new_scores = [ scores[elf_positions[0]], scores[elf_positions[1]] ]
  score = new_scores.inject(0, :+)
  
  if score >= 10
    scores << 1
    scores << score % 10
  else
    scores << score
  end
  
  elf_positions.each_with_index do |pos,index|
    elf_positions[index] = ( pos + new_scores[index] + 1 ) % scores.size
  end

end


def part1( recipe_target )

  elf_positions = [ 0, 1 ]
  scores = [ 3, 7 ]
  
  iteration_target = recipe_target + 10
  
  loop do
    break if scores.size >= iteration_target
    scores_and_positions( elf_positions, scores )
  end

  scores[ iteration_target - 10 .. iteration_target - 1 ].join("")
end


def part2( recipe_target )

  elf_positions = [ 0, 1 ]
  scores = [ 3, 7 ]

  target_array = recipe_target.chars.map( &:to_i )
  last_offset = 0
  
  loop do
    
    scores_and_positions( elf_positions, scores )

    if ( scores.size + last_offset ) >= target_array.size

      same_up_to = 0
      target_array.each_with_index do |element,index|

        if scores[ last_offset + index ] == element
          same_up_to += 1
        else
          break
        end
      end

      if same_up_to == target_array.size
        return last_offset
      else
        last_offset += same_up_to + 1
      end
    end
    
  end
  
end




p "part1 #{part1( 77201 )}"
p "part 2 #{part2( "077201" )}"
