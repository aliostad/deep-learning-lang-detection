#!/usr/bin/env ruby
load 'process_manager.rb'

p = ProcessManager.new # => Process Init is running
p.create("x", 1) # => Process x is running
p.create("p", 1) # => Process x is running
p.create("q", 1) # => Process x is running
p.create("r", 1) # => Process x is running
p.time_out # => Process p is running
p.request("R2", 1) # => Process p is running
p.time_out # => Process q is running
p.request("R3", 3) # => Process q is running
p.time_out # => Process r is running
p.request("R4", 3) # => Process r is running
p.time_out # => Process x is running
p.time_out # => Process p is running
p.request("R3", 1)  # => Process q is running
p.request("R4", 2)  # => Process r is running
p.request("R2", 2)  # => Process x is running
p.time_out  # => Process x is running
p.destroy("q") #=> Process x is running
# binding.pry
# p.time_out # => TODO: Process p is running
# p.time_out # => TODO: Process x is running
