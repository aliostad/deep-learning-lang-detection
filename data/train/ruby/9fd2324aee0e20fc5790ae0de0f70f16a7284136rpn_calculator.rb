class RPNCalculator

  def evaluate(input)
    elements = input.split
    calculate(elements)
  end

  def calculate(elements)
    if (elements.length > 1)
      for i in 0..(elements.length - 1)
        if (elements[i] == '+' || elements[i] == '-' || elements[i] == '/' || elements[i] == '*')
          result = eval(elements[i-2].to_s + elements[i].to_s + elements[i-1].to_s)         
          (elements[i-2] = result) && elements.delete_at(i-1) && elements.delete_at(i-1)
          calculate(elements)
        end       
      end
    end
    return elements[0].to_i
  end

end
