#!/usr/bin/env ruby
load 'process_manager.rb'

p = ProcessManager.new # => Process Init is running
p.create("x", 2) # => Process x is running
p.create("y", 1) # => Process x is running
p.time_out # => Process x is running
p.create("z", 2) # => Process x is running
p.time_out # => Process z is running
p.request("R1", 1) # => Process z is running
p.time_out # => Process x is running
p.request("R1", 1) # => Process z is running
p.destroy("z") # => Process z is running
p.release("R1", 1) # => Process x is running
p.destroy("x") # => Process Init is running
