class Lexer
  def initialize
    @prev_indentation = 0
  end

  def tokenize(code)
    @tokens = []
    code.each_line {|l| tokenize_line(l)}
    @tokens
  end

  def tokenize_line(line)
    tokenize_indentation(line)
    line.split(/ /).each{|chunk| tokenize_chunk(chunk)}
    tokenize_newlines(line)
  end

  def tokenize_newlines(line)
    if /[\n]+/.match(line)
      @tokens << [:NEWLINE, "\n"]
    end
  end

  def tokenize_indentation(line)
    if leading_whitespace = /^([ ]+)/.match(line)
      line_indentation = leading_whitespace.length
    else
      line_indentation = 0
    end

    if line_indentation != @prev_indentation
      @tokens.pop
    end

    @tokens << [:INDENT, line_indentation] if line_indentation > @prev_indentation
    if line_indentation < @prev_indentation
      @tokens << [:DEDENT, line_indentation]
      @tokens << [:NEWLINE, "\n"]
    end
    @prev_indentation = line_indentation
  end

  def tokenize_chunk(chunk)
    if /if/.match(chunk)
      @tokens << [:IF, "if"]
    elsif /[0-9]+/.match(chunk)
      @tokens << [:NUMBER, chunk.to_i]
    elsif string = /\"(.*)\"/.match(chunk)
      @tokens << [:STRING, string[1]]
    elsif /[a-z]+/.match(chunk)
      @tokens << [:IDENTIFIER, chunk]
    end
  end
end