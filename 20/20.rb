#!/usr/bin/ruby

stack = []
pos = [ 0, 0 ]
map = {}
map[pos] = 'X'

File.open( "20.input" ).readline.each_char do |c|

  if c == 'E'
    map[[pos.first+1,pos.last]] = '|'
    pos = [pos.first+2,pos.last]
    map[pos] = '.'
  elsif c == 'S'
    map[[pos.first,pos.last+1]] = '-'
    pos = [pos.first,pos.last+2]
    map[pos] = '.'
  elsif c == 'W'
    map[[pos.first-1,pos.last]] = '|'
    pos = [pos.first-2,pos.last]
    map[pos] = '.'
  elsif c == 'N'
    map[[pos.first,pos.last-1]] = '-'
    pos = [pos.first,pos.last-2]
    map[pos]  = '.'
  elsif c == '('
    stack.push pos
  elsif c == '|'
    pos = stack.last
  elsif c == ')'
    pos = stack.pop
  end
end

# find all rooms on the map
rooms = map.each.reduce( [] ) { |accum,(k,v)| accum << k if v == '.'; accum }

distances = {}
current = [0,0]
distances[current] = 0
visited = {}

# pure shortest path between start and each room
while visited.size != rooms.size 
  
  [ { :neighbor => [2,0], :adj => [ 1,0] },
    { :neighbor => [0,2], :adj => [ 0,1] },
    { :neighbor => [-2,0], :adj => [ -1,0]},
    { :neighbor => [0,-2], :adj => [ 0,-1] }
  ].each do | offset |
    
    neighbor = [ current.first + offset[:neighbor].first,
                 current.last + offset[:neighbor].last ]
    adj = [ current.first + offset[:adj].first,
            current.last + offset[:adj].last ]
    
    next if ! map.key?( neighbor ) || map[neighbor] != "." || ( map[adj] != "|" && map[adj] != "-" )

    if ! distances.key?( neighbor ) || distances[neighbor] > ( distances[current] + 1 )
      distances[neighbor] = distances[current] + 1
    end

  end

  visited[current] = 1
  
  # next node will be unvisited with the smallest distance
  smallest_distance = 1_000_000
  next_node = nil

  # priority queue would be a lot nicer here
  distances.each do | room,distance |
    if ! visited.key?( room ) && distance < smallest_distance
      smallest_distance = distance
      next_node = room
    end
  end
    
  current = next_node
end


onek = distances.values.select { |v| v >= 1000 }
p distances.values.max
p onek.size
