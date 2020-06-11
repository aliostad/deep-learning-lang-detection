# invoking add(4, 5) returns 9
# invoking add(-10, 2, 3) returns -5
# invoking add(0, 0, 0, 0) returns 0
def add(*numbers)
	numbers.inject(0) {|sum, number| sum + number}
end
# invoking subtract(4, 5) returns -1
# invoking subtract(-10, 2, 3) returns -15
# invoking subtract(0, 0, 0, 0, -10) returns 10
def subtract(*numbers)
	numbers.inject {|total, number| total - number}
end


# defaults to addtion when no option is specified
# invoking calculate(4, 5, add: true) returns 9
# invoking calculate(-10, 2, 3, add: true) returns -5
# invoking calculate(0, 0, 0, 0, add: true) returns 0
# invoking calculate(4, 5, subtract: true) returns -1
# invoking calculate(-10, 2, 3, subtract: true) returns -15
# invoking calculate(0, 0, 0, 0, -10, subtract: true) returns 10


def calculate(*arguments)
  # if the last argument is a Hash, extract it 
  # otherwise create an empty Hash
  options = arguments[-1].is_a?(Hash) ? arguments.pop : {}
  options[:add] = true if options.empty?
  return add(*arguments) if options[:add]
  return subtract(*arguments) if options[:subtract]
end

def calculate(*arguments)
	if arguments[-1]is_a?(Hash)
		options = arguments.pop
	else
		options = {}
	end
end