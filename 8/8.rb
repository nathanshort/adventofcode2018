#!/usr/bin/ruby

def do1( data, accum )
  numchildren, nummeta = data.slice!( 0, 2 )
  
  numchildren.times.each do |c|
    do1( data, accum )
  end
  accum.concat data.slice!( 0, nummeta )
end



def do2( data )
  numchildren, nummeta = data.slice!( 0, 2 )

  children_values = []
  numchildren.times.each do |c|
    children_values << do2( data )
  end

  meta = data.slice!( 0, nummeta )
  
  if numchildren == 0
    meta.reduce( 0 ) { |accum,elem| accum + elem }
  else
    meta.reduce( 0 ) do |accum,elem|
      if children_values[ elem-1 ]
        accum += children_values[ elem-1 ]
      end
      accum
    end
  end
end


data = File.read( "8.input" ).split( " " ).map(&:to_i)

accum = []
do1( data.dup, accum )
puts "part 1: #{accum.reduce( 0 ) { |accum,elem| accum + elem }}"
puts "part 2: #{do2( data.dup )}"
