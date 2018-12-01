#!/usr/bin/env ruby

def one( file )

  count = 0
  File.open( file , "r" ) do |f|
    f.each_line do |line|
      count += line.to_i
    end
  end
  count
end



def two( file )
  
count = 0
seen = {}

loop do
  
  File.open( file, "r" ) do |f|
    f.each_line do |line|
      count += line.to_i
      if ! seen.key?( count.to_s )
        seen[count.to_s] = 1
      else
        return count
      end
    end
  end
end

end


input = "1.input"
puts "one: #{one( input )}"
puts "two: #{two( input )}"
