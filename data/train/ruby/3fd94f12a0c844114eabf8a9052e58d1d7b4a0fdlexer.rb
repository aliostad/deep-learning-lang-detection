class Lexer
  KEYWORDS = ['a', 'an', 'can', 'if', 'else', 'while', 'true', 'false', 'nil', 'hockey']

  def tokenize(code)
    code.chomp!
    i = 0
    tokens = []

    while i < code.size
      chunk = code[i..-1]

      if open = chunk[/\A(:\n?)/, 1]
        tokens << ["{", "{"]
        i += open.size

      elsif close = chunk[/\A(eh\?\n?)/, 1]
        tokens << ["}", "}"]
        i += close.size

      elsif sayer = chunk[/\A(say|puts)/, 1]
        tokens << [:IDENTIFIER, "print"]
        i += sayer.size

      elsif identifier = chunk[/\A([a-z]\w*)/, 1]
        if KEYWORDS.include?(identifier)
          tokens << [identifier.upcase.to_sym, identifier]
        else
          tokens << [:IDENTIFIER, identifier]
        end
        i += identifier.size

      # checks for constants
      elsif constant = chunk[/\A([A-Z]\w*)/, 1]
        tokens << [:CONSTANT, constant]
        i += constant.size

      # check for strings
      elsif string = chunk[/\A"(.*?)"/, 1]
        tokens << [:STRING, string]
        i += string.size + 2

      elsif string = chunk[/\A'(.*?)'/, 1]
        tokens << [:STRING, string]
        i += string.size + 2

      # check for numbers
      elsif number = chunk[/\A([0-9]+)/, 1]
        tokens << [:NUMBER, number.to_i]
        i += number.size

      elsif chunk.match(/\A\n+/)
        tokens << [:NEWLINE, "\n"]
        i += 1

      elsif chunk.match(/\A /)
        i += 1

      else
        value = chunk[0,1]
        tokens << [value, value]
        i += 1
      end
    end
    tokens
  end
end
