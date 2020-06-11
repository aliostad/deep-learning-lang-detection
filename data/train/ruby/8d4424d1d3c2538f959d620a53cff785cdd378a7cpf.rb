module Cpf
  def self.generate
    digits = "#{rand(9)}#{rand(9)}#{rand(9)}#{rand(9)}#{rand(9)}#{rand(9)}#{rand(9)}#{rand(9)}#{rand(9)}"

    first_digit = self.calculate_digit(digits, 10)
    second_digit = self.calculate_digit("#{digits}#{first_digit}", 11)
    "#{digits}#{first_digit}#{second_digit}"
  end

  private
  def self.calculate_digit(numbers, first_number)
    digit = 0
    (0...first_number-1).each { |i| digit = digit + numbers[i].to_i * (first_number-i) }
    digit = (digit % 11) < 2 ? 0 : 11 - (digit % 11)

    digit
  end
end