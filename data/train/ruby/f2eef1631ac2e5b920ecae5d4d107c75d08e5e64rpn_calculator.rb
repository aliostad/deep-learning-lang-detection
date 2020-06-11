class RPNCalculator
  attr_reader :stack

  def initialize
    @stack = []
  end

  def push(number)
    stack << number
  end

  def value
    stack[-1]
  end

  def plus
    calculate(:+)
  end

  def minus
    calculate(:-)
  end

  def times
    calculate(:*)
  end

  def divide
    calculate(:/)
  end

  def tokens(str)
    str.split.map { |word| word =~ /\d/ ? word.to_i : word.to_sym }
  end

  def calculate(operation)
    raise "calculator is empty" if stack.size < 2

    stack << case
             when operation == :+
               stack.pop + stack.pop
             when operation == :-
               stack.pop - stack.pop
             when operation == :*
               stack.pop * stack.pop
             when operation == :/
               stack.pop / stack.pop.to_f
             end
  end

  def evaluate(str)
    array = tokens(str)
    array.each { |token| token.kind_of?(Symbol) ? calculate(token) :  push(token)}

    value
  end
end
