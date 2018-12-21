#!/usr/bin/ruby

operations_by_name =
  {
    'addr' => Proc.new {|r,a,b,c| r[c] = r[a] + r[b]},
    'addi' => Proc.new {|r,a,b,c| r[c] = r[a] + b},
    'mulr' => Proc.new {|r,a,b,c| r[c] = r[a] * r[b]},
    'muli' => Proc.new {|r,a,b,c| r[c] = r[a] * b},
    'banr' => Proc.new {|r,a,b,c| r[c] = r[a] & r[b]},
    'bani' => Proc.new {|r,a,b,c| r[c] = r[a] & b},
    'borr' => Proc.new {|r,a,b,c| r[c] = r[a] | r[b]},
    'bori' => Proc.new {|r,a,b,c| r[c] = r[a] | b},
    'setr' => Proc.new {|r,a,b,c| r[c] = r[a]},
    'seti' => Proc.new {|r,a,b,c| r[c] = a},
    'gtir' => Proc.new {|r,a,b,c| r[c] = a > r[b] ? 1 : 0},
    'gtri' => Proc.new {|r,a,b,c| r[c] = r[a] > b ? 1 : 0},
    'gtrr' => Proc.new {|r,a,b,c| r[c] = r[a] > r[b] ? 1 : 0},
    'eqir' => Proc.new {|r,a,b,c| r[c] = a == r[b] ? 1 : 0},
    'eqri' => Proc.new {|r,a,b,c| r[c] = r[a] == b ? 1 : 0},
    'eqrr' => Proc.new {|r,a,b,c| r[c] = r[a] == r[b] ? 1 : 0},
  }


def hardway( instructions, ip_bound, operations_by_name, rgs )

  ip = 0
  while ( ip >=0 && ip < instructions.size )
#    p rgs
    rgs[ip_bound] = ip
    operation, a, b, c = instructions[ip]
    operations_by_name[operation].call( rgs, a, b, c )
    ip = rgs[ip_bound] + 1
  end
  rgs[0]
end


def divisors( target )

  divisors = []
  ( 1..Math.sqrt( target ) ).each do |num|

    if target % num == 0
      divisors << num
      if target / num != num
        divisors << target / num
      end
    end
  end
  divisors
end


f = File.open( "19.input" )
ip_bound = f.readline.scan( /\d+/ ).first.to_i

instructions = []
f.each_line do |line|
  ins =  line.scan( /\w+/ )
  ins.each_with_index { |v,i| ins[i] = ins[i].to_i if i > 0 }
  instructions << ins
end

p hardway( instructions, ip_bound, operations_by_name, [ 0,0,0,0,0,0] )

# target number looks like 10551348 when the below settles down
#hardway( instructions, ip_bound, operations_by_name, [ 1,0,0,0,0,0] )

p divisors( 10551348 ).reduce(0) { |item,accum| accum += item }

