defmodule Aoc2 do
  
  def get_data( file ) do
    File.stream!( file ) |> Enum.map( &String.trim/1 )
  end

  
  def group_by_value( what ) do
    map = Enum.reduce( String.to_charlist( what ), %{}, fn( x, accum ) ->
      if Map.has_key?( accum, x ) do
	Map.put( accum, x, Map.get( accum, x ) + 1 )
      else
	Map.put( accum, x, 1 )
      end
    end )
    map
  end


  # returns number of spots by which the strings differ
  def string_difference( string1, string2 ) do

    Enum.zip( String.to_charlist( string1 ), String.to_charlist( string2 ) ) |>
      Enum.reduce( 0, fn( element, accum ) ->
	if( elem( element, 0 ) != elem( element, 1 ) ) do
	  accum + 1 
	else
	  accum
	end
      end )
  end


  
  def part1( file ) do

    #by_values is list of map, ie [ { char1 => count, char2 => count }, {...}  ]
    by_values = Enum.map( Aoc2.get_data( file ), &Aoc2.group_by_value/1 ) 

    checksum = Enum.map( [2,3], fn( x ) ->
      Enum.reduce( by_values, 0, fn( map, accum ) ->
	hasx = Enum.find_value( Map.to_list( map ), fn {_,v} -> v == x; end )
	if hasx do
	  accum + 1
	else
	  accum
	end
      end )
    end
    ) |> Enum.reduce( fn( x, accum ) -> accum * x end )

    checksum
  end

  
  def part2( file ) do

    ids = Aoc2.get_data( file )
    result = Enum.reduce_while( ids, [], fn( id, _ ) ->

      accum = Enum.zip( List.duplicate( id, Enum.count( ids ) ), ids ) |>

	Enum.reduce_while(  [], fn( tuple, _ ) ->
	  difference = Aoc2.string_difference( elem( tuple, 0 ), elem( tuple, 1 ) )
	  if difference == 1, do: { :halt, [ elem( tuple, 0 ), elem( tuple, 1 ) ] }, else: { :cont, [] }
	end )
      
      if Enum.count( accum ) > 0, do: { :halt, accum }, else: { :cont, [] }
      
    end )

    
    # result is a list of length 2, of the 2 ids that differ in only 1 char. now
    # we need to remove the differing char
    Enum.zip(
      String.to_charlist( Enum.at( result, 0 ) ),
      String.to_charlist( Enum.at( result, 1 ) ) ) |>
      Enum.reduce( "", fn( element, accum ) ->
	if( elem( element, 0 ) == elem( element, 1 ) ) do
	  accum <> List.to_string( [ elem( element, 0 ) ] )
	else
	  accum
	end
	
      end )
  end

end

checksum = Aoc2.part1( "2.input" )
IO.puts "checksum #{checksum}"

answer = Aoc2.part2( "2.input" )
IO.puts "answer #{answer}"


