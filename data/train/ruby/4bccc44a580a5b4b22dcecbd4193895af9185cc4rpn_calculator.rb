class RPNCalculator

  def initialize
    @stack = []
  end

  def push(n)
    @stack << n
  end

  def plus
    calculate(:+)
  end

  def minus
    calculate(:-)
  end

  def divide
    calculate(:/)
  end

  def times
    calculate(:*)
  end

  def calculate(sym)
    raise "calculator is empty" if @stack.empty?
    b, a = @stack.pop, @stack.pop
    @value = a.to_f.send(sym, b)
    push @value
  end

  def value
    @value
  end

  def tokens(str)
    syms = ["+", "-", "*", "/"]
    str.split.map { |n| syms.include?(n) ? n.to_sym : n.to_f }
  end

  def evaluate(str)
    token_list = tokens(str)
    token_list.each do |token|
      if token.is_a? Symbol
        calculate(token)
      else
        push(token)
      end
    end
    value
  end

end