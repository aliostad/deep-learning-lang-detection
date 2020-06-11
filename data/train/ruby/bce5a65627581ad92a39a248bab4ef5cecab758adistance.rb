#  based on the current rate and time, calculate the distance
# d = r * t

def calculate_distance(rate, time)
  rate * time
end


# let's try to find the distance between two points!!

def calculate_distance_between_points(x , y)
#x and y should be arrays ie x = [x1, x2] y = [y1, y2]
x1 = x[0]
x2 = x[1]
y1 = y[0]
y2 = y[1]
#formula = sqrt of (x2-x1)^2 + (y2 - y1)^2
parens_x = (x2 - x1)
parens_y = (y2 - y1)
before_sqrt = parens_x**2 + parens_y**2
answer = Math.sqrt(before_sqrt)
end

# tests calculate_distance_between_points method
# x = [2, 3]
# y = [4, 2]
# puts calculate_distance_between_points(x, y)

puts "Would you like to calculate distance between two points? [y/n]"
ans = gets.chomp.downcase

if ans.to_s == "y"
  puts "Input the FIRST coordinates.
  Please write in the following format:
  x1, x2"
  x = gets.chomp
  x = x.split(", ").map(&:to_f)
  puts "Input the SECOND coordinates. Please write in the following format: \n
  y1, y2"
  y = gets.chomp
  y = y.split(", ").map(&:to_f)
  puts "The distance between #{x} and #{y} is " + calculate_distance_between_points(x, y).to_s
else
  puts "ERROR ERROR TRY AGAIN."
end