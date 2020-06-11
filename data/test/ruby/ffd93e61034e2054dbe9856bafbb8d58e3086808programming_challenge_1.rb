module ProgrammingChallenges
  module PrimaryArithmetic
    def self.calculate_carries(a, b)
      carry_count = 0
      a_array = a.to_s.chars.map(&:to_i)
      b_array = b.to_s.chars.map(&:to_i)
      length = a_array.length <  b_array.length ? a_array.length : b_array.length
      carry_amount = 0
      (length -1).downto(0) do |i|
        if a_array[i] + b_array[i]  + carry_amount >= 10
          _, carry_amount =  (carry_amount +a_array[i] + b_array[i]).divmod(10)
          carry_count += 1
        else
          carry_amount = 0
        end
      end
      puts "#{carry_count} carry operations"
    end
  end
end

ProgrammingChallenges::PrimaryArithmetic.calculate_carries(123, 456)

ProgrammingChallenges::PrimaryArithmetic.calculate_carries(555, 555)

ProgrammingChallenges::PrimaryArithmetic.calculate_carries(123, 594)

ProgrammingChallenges::PrimaryArithmetic.calculate_carries(0, 10)




