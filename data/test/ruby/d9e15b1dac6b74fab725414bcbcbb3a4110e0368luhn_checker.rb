class LuhnChecker

  CHECK_PLACEHOLDER = 'x'

  def self.validate(number)
    sum = calculate_sum number
    (sum % 10) == 0
  end

  def self.add_control_digit(number)
    number.to_s + calculate_control_number(number)
  end

  # Calculates a sum according a Luhn Algorithm
  def self.calculate_sum(number, has_check_digit = true)
    number = number.to_s unless number.is_a? String
    number = number + CHECK_PLACEHOLDER unless has_check_digit # Add control digit placeholder if need

    sum, i = 0, 0
    number.reverse.each_char do |c|
      c = c.to_i unless c == CHECK_PLACEHOLDER
      n = 0
      if i.even?
        n = c unless c == CHECK_PLACEHOLDER
      else
        n = c * 2
        n = n - 9 if n > 9
      end
      sum += n
      i += 1
    end

    sum
  end

  def self.calculate_control_number(number)
    sum = calculate_sum number, false
    sum = sum * 9
    sum.to_s.split('').last
  end

end