class Intrest
 def initialize(principal,time)
   @principal = principal
   @time = time
   @rate = 10.0

 end

 def calculate_simple
  (@principal * @time * @rate)/100

 end

 def calculate_compunded
 	(@principal * ((1+@rate/100)**@time)) - @principal
 end

 def intrest_difference
   calculate_compunded - calculate_simple
 end

end

puts "Enter principle Amount"
principal = gets.chomp.to_i

puts "Enter time period"
time = gets.chomp.to_i

intrest = Intrest.new(principal,time)
puts intrest.intrest_difference