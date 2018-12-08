#!/usr/bin/ruby

def do1( data, accum )
  numchildren, nummeta = data.slice!( 0, 2 )
  
  (1..numchildren).each do |c|
    do1( data, accum )
  end
  accum.concat data.slice!( 0, nummeta )
end



def do2( data )
  numchildren, nummeta = data.slice!( 0, 2 )

  children_values = []
  (1..numchildren).each do |c|
    children_values << do2( data )
  end

  meta = data.slice!( 0, nummeta )
  
  value = 0
  if numchildren == 0
    value = meta.reduce( 0 ) { |accum,elem| accum + elem }
  else
    meta.each do |m|
      if children_values[ m-1 ]
        value = value + children_values[ m-1 ]
      end
    end
  end
  
  value
end


data = File.read( "8.input" ).split( " " ).map(&:to_i)
accum = []
do1( data, accum )
puts "part 1: #{accum.reduce( 0 ) { |accum,elem| accum + elem }}"

data = File.read( "8.input" ).split( " " ).map(&:to_i)
puts "part 2: #{do2( data )}"
