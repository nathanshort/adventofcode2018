#!/usr/bin/ruby

depth = 9465
target = [13,704]

geo_index = nil
erosion = {}
region = {}
risk_level = 0

# additional offset of 10 was determined via trial and error
( 0..(target.last + 10)).each do |y|

  ( 0..(target.first + 10)).each do |x|

    if ( y == 0 && x == 0 ) || ( y == target.last && x == target.first )
      geo_index = 0
    elsif y == 0
      geo_index = x * 16807
    elsif x == 0
      geo_index = y * 48271
    else
      geo_index = erosion[[x-1,y]] * erosion[[x,y-1]]
    end
    
    erosion[[x,y]] = ( geo_index + depth ) % 20183

    if erosion[[x,y]] % 3 == 0
      region[[x,y]] = :rocky
    elsif erosion[[x,y]] % 3 == 1
      region[[x,y]] = :wet
      risk_level += 1 if x <= target.first && y <= target.last
    elsif erosion[[x,y]] % 3 == 2
      region[[x,y]] = :narrow
      risk_level += 2 if x <= target.first && y <= target.last
    else
      raise "invalid erosion"
    end
  end
end



# created so that we can use a tuple of ( x, y, tool ) as a hash key
class Point 

  attr_accessor :x, :y, :tool
  
  def initialize( x, y, tool )
    @x = x
    @y = y
    @tool = tool
  end

  def location()
    [ @x, @y ]
  end
  
  def ==(other)
    self.class === other and
      other.x == @x and
      other.y == @y and
      other.tool == @tool
  end
  
  alias eql? ==
        
  def hash
    @x.hash ^ @y.hash ^ @tool.hash
  end  
end


# lookup table describing what can move from key => value => via tool
moves =
  {
    :rocky => { :rocky => :dont_care, :wet => :climbing, :narrow => :torch },
    :wet => { :wet => :dont_care, :rocky => :climbing, :narrow => :neither  },
    :narrow => { :narrow => :dont_care, :rocky => :torch, :wet => :neither  },
  }

# lookup table describing what can switch from key => values
switches =
  {
    :rocky => [ :torch, :climbing ],
    :wet => [ :climbing, :neither ],
    :narrow => [ :torch, :neither ],
  }

start = Point.new( x = 0, y = 0, tool = :torch)
                                                        
unvisited = {}
unvisited[start] = 1

distances = {}
distances[start] = 0

visited = {}

target_node = Point.new( target.first, target.last, :torch )

# find the shortest path...
while unvisited.size() != 0

  # poor man's priority queue...ish.  still really just an array of unvisited, but
  # with a hash for storing the values - so that we can do quick deletion. 
  # next node will be unvisited with the smallest distance
  smallest_distance = 1_000_000
  next_node = nil

  unvisited.each do | node, _ |
    distance = distances[node]
    if distance < smallest_distance
      smallest_distance = distance
      next_node = node
    end
  end

  current_node = next_node
  break if current_node == target_node

  unvisited.delete( current_node )
  visited[current_node] = 1
  unvisited.delete( current_node )
  current_region = region[ current_node.location() ]
  
  # first evaluate what tools we could switch to, at this point. treat that as an
  # adjacent node with cost of 7
  [ :torch, :neither, :climbing ].each do | tool |

    next if tool == current_node.tool || switches[current_region].find( tool ) == nil
    different_tool = Point.new( current_node.x, current_node.y, tool )
    next if visited.key?( different_tool ) 

    cost = 7
    if ! distances.key?( different_tool ) ||
       distances[different_tool] > ( distances[current_node] + cost )
      distances[different_tool] = distances[current_node] + cost
    end

    unvisited[different_tool] = 1
  end

  # now evaluate neighbors that we can move to
  [ [1,0], [0,1], [-1,0], [0,-1] ].each do | offset |
    
    neighbor_node = Point.new( current_node.x + offset.first,
                               current_node.y + offset.last, current_node.tool )
    neighbor_region = region[ neighbor_node.location() ]
    next if visited.key?( neighbor_node ) ||
            ! region.key?( [neighbor_node.x, neighbor_node.y ] ) ||
            ( moves[current_region][neighbor_region] != :dont_care &&
              moves[current_region][neighbor_region] != current_node.tool )
    
    cost = 1
    if ! distances.key?( neighbor_node ) ||
       distances[neighbor_node] > ( distances[current_node] + cost )
      distances[neighbor_node] = distances[current_node] + cost
    end

    unvisited[neighbor_node] = 1
  end

end

p "part 1: #{risk_level}"
p "part 2: #{distances[ Point.new( target.first, target.last, :torch )]}"
