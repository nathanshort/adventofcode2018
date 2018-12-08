#!/usr/bin/ruby


def next_availables( stepsdone, rules, times_dependent )

  no_dependencies = rules.keys.find_all { |k| ! times_dependent.key?( k ) }
  next_avail = Hash[ no_dependencies.map {|v| [v, nil]} ]

  stepsdone.reduce( next_avail ) do | accum, step |
    if rules.key?( step )
      rules[step].each do |r|
        accum[r] = step
      end
    end
    accum
  end

  # delete elements that are ready because of 1 prerequisite met, but
  # not ALL prerequisites met
  next_avail.keys.each do |n|
    if( times_dependent.key?( n ) && times_dependent[n] >= 1 )
      next_avail.delete( n )
    elsif( stepsdone.index( n ) != nil )
      next_avail.delete( n )
    end
  end
  
  next_avail
  end



def doit( rules, parallelization, times_dependent, weight )

  durations = Hash.new( 0 )
  ('A'..'Z').each_with_index { |l,index| durations[l] = ( weight == nil ) ? 1 : weight + index + 1 }
  
  # rules will look like:
  # {"C"=>["A", "F"], "A"=>["B", "D"], "B"=>["E"], "D"=>["E"], "F"=>["E"]}
  rules.each { |k,v| rules[k] = v.sort }

  steps_completed = []
  ticks = 0
  in_progress = {}

  # loop, 1 second per iteration
  loop do

    # grab all available - filtering out the ones we are already working on,
    # then take what we need and start working
    need = parallelization - in_progress.keys.size
    avail = next_availables( steps_completed, rules, times_dependent )

    possible = avail.keys.sort.find_all { |k| ! in_progress.key?( k ) }
    possible.take( parallelization - in_progress.keys.size ).each do |a|
      in_progress[a] = avail[a]
    end

    break if in_progress.size == 0
    
    in_progress.each do |step,prereq|
      
      durations[step] = durations[step] - 1
      if durations[step] <= 0
        
        in_progress.delete( step )
        steps_completed << step        
        
        if( rules.key?( step ) )
          rules[step].each do |s|
            times_dependent[s] = times_dependent[s] - 1
          end
        end
        
        if ( prereq != nil )  && ( rules.key?( prereq ) )
          rules[ prereq ].shift 
          if rules[prereq].size == 0
            rules.delete( prereq )
          end
        end
      end
    end
    
    ticks = ticks + 1
    
  end
  [ steps_completed, ticks ]
end



def get_rules( rules, times_dependent )

  File.open( "7.input" ).each_line do |line|
    matches = /Step (.*) must be finished before step (.*) can begin/.match( line )
    prereq, step = matches[1], matches[2]
    rules[prereq] = [] if ! rules.key?( prereq )
    rules[prereq] << step
    times_dependent[step] = times_dependent[step] + 1
  end
end

# part 1
rules = {}
times_dependent = Hash.new( 0 )
get_rules( rules, times_dependent )
completed, ticks = doit( rules, parallelization = 1, times_dependent, weight = nil )
p "part 1: #{completed.join( "" )} in #{ticks} ticks"

# part 2
rules = {}
times_dependent = Hash.new( 0 )
get_rules( rules, times_dependent )
completed, ticks = doit( rules, parallelization = 5, times_dependent, weight = 60 )
p "part 2: #{completed.join( "" )} in #{ticks} ticks"
