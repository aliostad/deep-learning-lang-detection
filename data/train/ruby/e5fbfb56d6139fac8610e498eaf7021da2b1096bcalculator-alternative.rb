def calculate(total)

  total = total
  
  if total == nil
    # prompt for number from user  
    print "Enter a number: "
    total = gets.chomp.to_f
  end

  puts "Select an operation"
  puts "  +  - addition"
  puts "  -  - subtraction"
  puts "  x  - multiplication"
  puts "  /  - division"
  puts "  S  - square"
  puts "  R  - square root"
  puts "---------------------"
  puts "  C  - clear"
  puts "  Q  - quit"
  operation = gets.chomp

# chnage this to an array
  if operation != (('s') || ('r') || ('q') || ('c') || ('+') || ('-') || ('x') || ('/'))
    calculate(total)
  end

  case operation
  when 's'
    square(total)
  when 'r'
    squareroot(total)
  when 'q'
    exit
  when 'c'
    calculate(nil)
  end

  print "Enter another number: "
  num = gets.chomp.to_f

  case operation
  when '+'
    add(total,num)
  when '-'
    subtract(total,num)
  when 'x'
    multiply(total,num)
  when '/'
    divide(total,num)
  end

  # # keep the program looping
  # if total != nil
  #   puts total
  #   puts "inside if loop"
  #   calculate(total)
  # else
  #   calculate(nil)
  # end
end

# and all the calculation happens here
def add(x,y)
  total = x + y
  puts total
  calculate(total)
end

def subtract(x,y)
  total = x - y
  puts total
  calculate(total)
end

def multiply(x,y)
  total = x * y
  puts total
  calculate(total)
end

def divide(x,y)
  total = x / y
  puts total
  calculate(total)
end

def square(x)
  total = x * x
  puts total
  calculate(total)
end

def squareroot(x)
  total = Math.sqrt(x)
  puts total
  calculate(total)
end

total = nil
calculate(total)