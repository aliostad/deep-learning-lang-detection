puts "Ruby Methods"

def calculate_block(num1, num2, *rest, &block)
  yield num1,num2
end

puts "Calculate block (addition): #{calculate_block(rand(1..100), rand(1..100)) {|mynum1, mynum2| mynum1 + mynum2 } }"
puts "Calculate block (subtraction): #{calculate_block(rand(1..100), rand(1..100)) {|mynum1, mynum2| mynum1 - mynum2 } }"
puts "Calculate block (multiplication): #{calculate_block(rand(1..100), rand(1..100)) {|mynum1, mynum2| mynum1 * mynum2 } }"
puts "Calculate block (division): #{calculate_block(rand(1..100), rand(1..100)) {|mynum1, mynum2| mynum1 / mynum2 } }"
