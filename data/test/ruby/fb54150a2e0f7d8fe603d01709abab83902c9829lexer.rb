class Lexer
  KEYWORDS = ["if", "true", "false", "class", "nil"]
  def self.tokenize(code)
    clean_code = code.chomp
    i = 0
    tokens = []

    while i < clean_code.size
      chunk = clean_code[i..-1]

      if identifier = chunk[/^([a-z]\w*)/, 1]
        if KEYWORDS.include?(identifier)
          tokens << [identifier.upcase.to_sym, identifier]
        else
          tokens << [:IDENTIFIER, identifier]
        end
        i += identifier.size
      elsif constant = chunk[/^([A-Z]\w*)/, 1]
        tokens << [:CONSTANT, constant]
        i += constant.size
      elsif number = chunk[/^(\d+)/, 1]
        tokens << [:NUMBER, number.to_i]
        i += number.size
      elsif string = chunk[/^"(.*?)"/, 1]
        tokens << [:STRING, string]
        i += string.size + 2
      end
      i += 1
    end
    return tokens
  end
end
