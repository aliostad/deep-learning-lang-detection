module Apiary
  module Honey
    class Lexer

      KEYWORDS = %w[eq not gt lt ge le includes sort page_size page in nin like and null]

      def tokenize(input)
        input.chomp!

        i = 0
        tokens = []

        while i < input.size
          chunk = input[i..-1]

          if (decimal = chunk[/\A(\d+\.\d+)/, 1])
            tokens << {:type => :DECIMAL, :value => decimal}
            i += decimal.length
          elsif (field = chunk[/\A(\w+\.\w+)/, 1])
            tokens << {:type => :FIELD, :value => field}
            i += field.length
          elsif (direction = chunk[/\A(asc|desc)/, 1])
            tokens << {:type => :DIRECTION, :value => direction}
            i += direction.length
          elsif (identifier = chunk[/\A([a-z]\w*)/, 1])
            if KEYWORDS.include? identifier
              tokens << {type: identifier.upcase.to_sym, value: identifier}
              i += identifier.length
            else
              tokens << {:type => :IDENTIFIER, :value => identifier}
              i += identifier.length
            end
          elsif (string = chunk[/\A(".*?(?<!\\)")/, 1])
            tokens << {:type => :STRING, :value => string[1..-2].gsub('\\"', '"')}
            i += string.length
          elsif (string = chunk[/\A('.*?(?<!\\)')/, 1])
            tokens << {:type => :STRING, :value => string[1..-2].gsub("\\'", "'")}
            i += string.length
          elsif (integer = chunk[/\A(\d+)/, 1])
            tokens << {:type => :INTEGER, :value => integer}
            i += integer.length
          elsif (comma = chunk[/\A(,)/, 1])
            i += comma.length
          elsif (whitespace = chunk[/\A(\s+)/, 1])
            i += whitespace.length
          else
            raise ParseError, "Unrecognized token at character #{i}: #{chunk[0..255]}"
          end
        end

        tokens
      end

    end
  end
end