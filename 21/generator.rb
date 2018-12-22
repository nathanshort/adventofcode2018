#!/usr/bin/ruby

operations_by_name =
  {
    'addr' => Proc.new {|i,a,b,c|"//addr\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] + r[#{b}];\n ip=r[ipbound]+1;\nbreak;"},
    'addi' => Proc.new {|i,a,b,c|"//addi\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] + #{b};\n ip=r[ipbound]+1;\nbreak;"},
    'mulr' => Proc.new {|i,a,b,c|"//mulr\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] * r[#{b}];\n ip=r[ipbound]+1;\nbreak;"},
    'muli' => Proc.new {|i,a,b,c|"//muli\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] * #{b};\n ip=r[ipbound]+1;\nbreak;"},
    'banr' => Proc.new {|i,a,b,c|"//banr\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] & r[#{b}];\n ip=r[ipbound]+1;\nbreak;"},
    'bani' => Proc.new {|i,a,b,c|"//bani\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] & #{b};\n ip=r[ipbound]+1;\nbreak;"},
    'borr' => Proc.new {|i,a,b,c|"//borr\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] | r[#{b}];\n ip=r[ipbound]+1;\nbreak;"},
    'bori' => Proc.new {|i,a,b,c|"//bori\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] | #{b};\n ip=r[ipbound]+1;\nbreak;"},
    'setr' => Proc.new {|i,a,b,c|"//setr\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}];\n ip=r[ipbound]+1;\nbreak;"},
    'seti' => Proc.new {|i,a,b,c|"//seti\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = #{a};\n ip=r[ipbound]+1;\nbreak;"},
    'gtir' => Proc.new {|i,a,b,c|"//gtir\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = #{a} > r[#{b}] ? 1 : 0;\n ip=r[ipbound]+1;\nbreak;"},
    'gtri' => Proc.new {|i,a,b,c|"//gtri\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] > #{b} ? 1 : 0;\n ip=r[ipbound]+1;\nbreak;"},
    'gtrr' => Proc.new {|i,a,b,c|"//gtrr\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] > r[#{b}] ? 1 : 0;\n ip=r[ipbound]+1;\nbreak;"},
    'eqir' => Proc.new {|i,a,b,c|"//eqir\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = #{a} == r[#{b}] ? 1 : 0;\n ip=r[ipbound]+1;\nbreak;"},
    'eqri' => Proc.new {|i,a,b,c|"//eqri\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] == #{b} ? 1 : 0;\n ip=r[ipbound]+1;\nbreak;"},
    'eqrr' => Proc.new {|i,a,b,c|"//eqrr\ncase #{i}:\nr[ipbound]=ip;\n r[#{c}] = r[#{a}] == r[#{b}] ? 1 : 0;\n ip=r[ipbound]+1;\nbreak;"},
  }


f = File.open( "21.input" )
ip_bound = f.readline.scan( /\d+/ ).first.to_i

instructions = []
index = 0
f.each_line do |line|
  ins =  line.scan( /\w+/ )
  ins.each_with_index { |v,i| ins[i] = ins[i].to_i if i > 0 }
  op, a, b, c = ins
  puts operations_by_name[op].call( index, a, b, c )
  puts "\n\n"
  index = index + 1
end


