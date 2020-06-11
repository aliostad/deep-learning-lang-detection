#!/usr/local/rvm/rubies/ruby-1.9.3-p547/bin/ruby
=begin
	Author: Ramkumar Kuppuchamy
	At    : 19/08/2014
=end
class Gear

     attr_reader :cog, :chainring, :rim, :tire
     def initialize(chainring,cog,rim,tire)
	@chainring = chainring
	@cog = cog
	@rim = rim
	@tire = tire
     end

     def calculate_ratio
	chainring / cog.to_f
     end
     
     def calculate_gear_inches
	calculate_ratio * (rim * (tire * 2))
     end
end
#puts "Big Gear ::: #{Gear.new(52,12).calculate_ratio}"
#puts "Small Gear ::: #{Gear.new(42,32).calculate_ratio}"
puts "Big Gear ::: #{Gear.new(42,32,26,1.5).calculate_gear_inches}"
puts "Small Gear ::: #{Gear.new(42,32,24,1.25).calculate_gear_inches}"
