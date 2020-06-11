class Lexer
  
  KEYWORDS = ["def", "class", "if", "true", "false", "null"]
  
  def tokenize(code)
    
    code.chomp!
    tokens= []
    current_indent = 0
    indent_stack = []
    i = 0
    
    while i < code.size
      
      chunk = code[i..-1]
      
      if identifier = chunk[/\A([a-z]\w*)/, 1]
        
        if KEYWORDS.include?(identifier)
          tokens << [identifier.upcase.to_sym, identifier]
          
        else
          tokens << [:IDENTIFIER, identifier]
        end
        i += identifier.size
      
      elsif constant = chunk[/\A([A-Z]\w*)/, 1]
        tokens << [:CONSTANT, constant]
        i += constant.size
      
      elsif number = chunk[/\A([0-9]+)/, 1]
        tokens << [:NUMBER, number.to_i]
        i += number.size
      
      elsif string = chunk[/\A"([^"]*)"/, 1]
        tokens << [:STRING, string]
        i += string.size
      
      elsif operator = chunk[/\A(\|\||&&|==|!=|<=|>=)/, 1]
        tokens << [operator, operator]
        i += operator.size
      
      elsif chunk.match(/\A\n+/)
        tokens << [:NEWLINE, "\n"]
        i += 1
        
      elsif chunk.match(/\A /)
        i += 1
        
      else
        value = chunk[0,1]
        tokens << [value, value]
        
      end  
      
    end
    
    while indent = indent_stack.pop
      tokens << [:DEDENT, indent_stack.first || 0]
    end
    
    tokens
  end
end
