#!/usr/bin/ruby

Cart = Struct.new( :current_direction, :intersections ) {}

map = {}
carts = {}
cart_chars = { '<' => :left, '>' => :right, '^' => :up, 'v' => :down }
rcart_chars = { '<' => '-', '>'  => '-', '^' => '|', 'v' => '|' }
turn_options = [ :left, nil, :right ]

y = 0
File.open( "13.input" ).each_line do |line|
  line.chomp!
  line.chars.each_with_index do |char,x|
    if cart_chars.key?( char )
      carts[[x,y]] = Cart.new( cart_chars[char], turn_options.dup )
      map[[x,y]] = rcart_chars[ char ]
    else
      map[[x,y]] = char if char != " "
    end
  end
  y += 1
end


# [ current direction, turn ] => next direction
turns =
  {
    [ :right, "\\"] => :down,  [ :right, "/"] => :up,
    [ :left, "\\" ] => :up,    [ :left, "/" ] => :down,   
    [ :up, "\\" ] => :left,    [ :up, "/" ] => :right,
    [ :down, "\\" ] => :right, [ :down, "/" ] => :left,  
  }


# [current dir, current intersection => intersection dirction
intersections =
  {
    [ :down, :left ] => :right,  [ :down, nil ] => :down,   [ :down, :right ] => :left,
    [ :up, :left ] => :left,     [ :up, nil ] => :up,       [ :up, :right ] => :right,
    [ :left, :left ] => :down,   [ :left, nil ] => :left,   [ :left, :right ] => :up,
    [ :right, :left ] => :up,    [ :right, nil ] => :right, [ :right, :right ] => :down,
  }


loop do

  sorted_keys = carts.keys.sort do |a,b|
    ysort = a.last <=> b.last
    if ysort != 0
      ysort
    else
      a.first <=> b.first
    end
  end

  sorted_keys.each do |key|

    # we may have deleted it after a crash
    next if ! carts.key?( key )

    current_cart = carts[key]
    carts.delete key
    current_direction = current_cart.current_direction
    x,y = key

    if current_direction == :right
      next_coord = [x+1,y]  
    elsif current_direction == :left
      next_coord = [x-1,y]
    elsif current_direction == :down
      next_coord = [x,y+1]
    elsif current_direction == :up
      next_coord = [x,y-1]
    else
      raise "unknown direction #{current_direction}"
    end

    next_spot = map[next_coord]
    if next_spot.nil?
      raise "unknown next spot"
    end
      
    if carts.key?( next_coord )
      carts.delete next_coord
      p "crash at #{next_coord} #{carts.keys.count}"
    else
      
      if next_spot == "+"
        next_direction = intersections[[current_direction, current_cart.intersections.first]]
        current_cart.intersections.rotate!
        
      # change direction due to turn
      elsif turns.key?( [ current_direction, next_spot ] )
        next_direction = turns[ [ current_direction, next_spot ] ]
        
      else
        next_direction = current_direction
      end
      
      current_cart.current_direction = next_direction
      carts[next_coord] = current_cart
    end
    
  end

  if carts.keys.count ==  1
    p carts.keys
    exit
  end
  
end


