#!/usr/bin/env ruby
class Factorials

  def calculate_loop(val)
    return 1 if val == 0
    returnValue = val

    val.downto(2) do |i|
      returnValue = returnValue * (i-1)
    end

    return returnValue
  end

  def calculate_recursive(n)
    if n<= 1
      1
    else
      n * calculate_recursive( n - 1 )
    end
  end

  RubyVM::InstructionSequence.compile_option = {
    tailcall_optimization: true,
    trace_instruction: false
  }

  def fact(n, acc=1)
    return acc if n <= 1
    fact(n-1, n*acc)
  end  

end