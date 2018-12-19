#!/usr/bin/ruby

operations_by_name =
  {
    'addr' => Proc.new {|r,a,b,c| r[c] = r[a] + r[b] },
    'addi' => Proc.new {|r,a,b,c| r[c] = r[a] + b },
    'mulr' => Proc.new {|r,a,b,c| r[c] = r[a] * r[b] },
    'muli' => Proc.new {|r,a,b,c| r[c] = r[a] * b },
    'banr' => Proc.new {|r,a,b,c| r[c] = r[a] & r[b] },
    'bani' => Proc.new {|r,a,b,c| r[c] = r[a] & b },
    'borr' => Proc.new {|r,a,b,c| r[c] = r[a] | r[b] },
    'bori' => Proc.new {|r,a,b,c| r[c] = r[a] | b },
    'setr' => Proc.new {|r,a,b,c| r[c] = r[a] },
    'seti' => Proc.new {|r,a,b,c| r[c] = a },
    'gtir' => Proc.new {|r,a,b,c| r[c] = a > r[b] ? 1 : 0 },
    'gtri' => Proc.new {|r,a,b,c| r[c] = r[a] > b ? 1 : 0 },
    'gtrr' => Proc.new {|r,a,b,c| r[c] = r[a] > r[b] ? 1 : 0 },
    'eqir' => Proc.new {|r,a,b,c| r[c] = a == r[b] ? 1 : 0 },
    'eqri' => Proc.new {|r,a,b,c| r[c] = r[a] == b ? 1 : 0 },
    'eqrr' => Proc.new {|r,a,b,c| r[c] = r[a] == r[b] ? 1 : 0 },
  }


def sample( data, operations_by_name )

  sum = 0
  could_be = {}
  
  ( 0..operations_by_name.keys.size - 1 ).each do |i|
    could_be[i] = []
    operations_by_name.keys.each do |key|
      could_be[i] << key
    end
  end

  data.each_slice( 3 ) do |slice|
    match_count = 0
    seen = []

    op, a, b, c = slice[1]
    operations_by_name.each do |key, proc|
      rgs = slice[0].dup
      proc.call( rgs, a, b, c )
      if rgs == slice[2]
        seen << key
        match_count += 1
      end
    end

    sum += 1 if match_count >= 3
    could_be[op].each do |v|
      could_be[op].delete(v) if seen.find_index(v) == nil
    end
  end

  [ sum, could_be ]
end



def determine_operations( could_be, known, operations_by_name )
  
  while( known.keys.size != operations_by_name.keys.size )
    
    singles = could_be.each.select{ |k,v| v.size == 1 }
    singles.each{ |v| known[v.first] = v.last.first }
    
    could_be.each do |k,v|
      known.each do |op_code,operator|
        could_be[k].delete( operator )
      end
    end
  end
  
end



def part2( operations_by_name, operations_by_opcode )

  rgs = [0,0,0,0]
  File.open( "16.test" , "r" ) do |f|
    f.each_line do |line|
      line.chomp!
      op, a, b, c = line.scan( /\d+/ ).each.map(&:to_i)
      operations_by_name[ operations_by_opcode[ op ] ].call( rgs, a, b, c )
    end
  end
  rgs
end


data = []
File.open( "16.input" , "r" ) do |f|
  f.each_line do |line|
    line.chomp!
    data << line.scan( /\d+/ ).each.map(&:to_i)
  end
end

sum, could_be = sample( data, operations_by_name )
p "part 1: #{sum}"

operations_by_opcode = {}
determine_operations( could_be, operations_by_opcode, operations_by_name )


registers = part2( operations_by_name, operations_by_opcode )
p "part 2: #{registers[0]}"
