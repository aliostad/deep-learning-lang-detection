class String
  # process-syntax check to calculate.
  # @return [Boolean] condition
  # @example
  #  '(1+2)*3'.calculate? # => true
  #  '2/0'.calculate? #=> true (but calculate raise ZeroDivisionError)
  #  '2.0/0'.calculate? #=> true (but calculate method return Float::INFINITY)
  #  '2(1+2)'.calculate? # => false
  def calculate?
    Calculate.new(self).correct?
  end

  # process to calculate.
  # @param [Symbol] safety If it set :danger, not check syntax eval will be exposed.
  # @return [Obhject] Nil or Integer or Float
  # @example
  #  '3*(1+2)'.calculate # => 9
  #  '1+2*3'.calculate # => 7
  #  '2/0'.calculate #=> raise ZeroDivisionError
  #  '2.0/0'.calculate #=> Float::INFINITY
  #  '2(1+2)'.calculate # => nil
  #  '1 + [2,3].shift + 4'.calculate # => nil
  #  '1 + [2,3].shift + 4'.calculate(:danger) # => 7
  def calculate(safety = :safe)
    Calculate.new(self).calculate(safety)
  end

  # String::Calculate
  class Calculate
    ARITHMETIC_OP = %r{[\+\-\/\*]}
    OP_MISSING_BRACKETS = %r{[^\+\-\/\*]\(|\)[^\+\-\/\*]}
    BRACKETS_OP = /\(([^\(\)]+)\)/

    def initialize(syntax)
      syntax.gsub!(/\s/, '')
      @syntax = "#{syntax}"
    end

    # Process.
    # @param [Symbol] safety check syntax before calculate when safety has :danger
    # @return [Object] eval result. or nil
    def calculate(safety)
      permit = case safety
               when :safe
                 self.correct?
               when :danger
                 true
               else
                 fail ArgumentError
               end
      return nil unless permit
      eval(@syntax)
    end

    # Syntax check.
    # @return [Boolean] condition
    def correct?
      syntax = @syntax.dup
      # need operator before-( or after-).
      return false if syntax =~ OP_MISSING_BRACKETS
      _result = catch(:fail) do
        while syntax =~ BRACKETS_OP
          syntax.gsub!(BRACKETS_OP) do
            syntax_without_brackets?(Regexp.last_match[1]) ? 1 : throw(:fail, false)
          end
        end
        syntax_without_brackets?(syntax)
      end
    end

    private

    def syntax_without_brackets?(syntax)
      until (v1, op, v2 = syntax.partition(ARITHMETIC_OP)).last.empty?
        v1 = 0 if v1.empty? && (op == '+' || op == '-')
        [Float(v1), Float(1)].inject(op)
        syntax = v2
      end
      # chack last value.
      [Float(syntax), Float(1)].inject('*')
      true
    rescue
      false
    end
  end
end
