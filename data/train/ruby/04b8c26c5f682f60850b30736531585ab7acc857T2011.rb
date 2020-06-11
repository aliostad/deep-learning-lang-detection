def tests
  puts calculate(1, [1]) == "No"
  puts calculate(1, [2]) == "No"
  puts calculate(1, [3]) == "No"
  puts 
  puts calculate(2, [1,2]) == "No"
  puts calculate(2, [1,3]) == "No"
  puts 
  puts calculate(3, [1,2,3]) == "Yes"
  puts calculate(3, [1,1,1]) == "No"
  puts calculate(3, [1,1,2]) == "No"
  puts calculate(3, [1,2,2]) == "No"
  puts 
  puts calculate(4, [1,2,3,3]) == "Yes"
  puts calculate(4, [1,2,2,3]) == "Yes"
  puts calculate(4, [1,1,2,3]) == "Yes"
  puts calculate(4, [1,1,3,3]) == "Yes"
  puts calculate(4, [1,1,1,3]) == "No"
  puts calculate(4, [1,1,1,1]) == "No"
  puts 
  puts calculate(5, [1,1,1,1,1]) == "No"
  puts calculate(5, [1,1,1,1,2]) == "No"
  puts calculate(5, [1,1,1,2,2]) == "Yes"
  puts calculate(5, [1,1,1,2,3]) == "Yes"
  puts calculate(5, [1,1,2,2,3]) == "Yes"
  puts calculate(5, [1,2,2,2,3]) == "Yes"
  puts calculate(5, [1,2,2,2,2]) == "No"
  puts 
  puts calculate(6, [1,1,1,1,1,2]) == "Yes"
  puts calculate(6, [1,1,1,1,2,2]) == "Yes"
  puts calculate(6, [1,1,1,1,2,3]) == "Yes"
  puts calculate(6, [1,1,1,1,1,1]) == "No"
end

def has_six_words(yes)
  if yes 
    return "Yes"
  else
    return "No"
  end 
end

def letter_count(letters)
  count = 1
  1.upto(letters.size - 1) do |x|
    count += 1 if letters[x] != letters[x-1]
  end
  count
end

def frequency(letters)
  freq = Hash.new 0
  letters.each{|x| freq[x] += 1}
  freq
end

def calculate(n, letters)
  if letters.size >= 6
    return has_six_words letters[0] != letters[-1]
  elsif letters.size < 3
    return has_six_words false
  else
    c = letter_count letters
    if c == 3
      return has_six_words true
    elsif c == 2
      freq = frequency letters
      return has_six_words freq[letters[0]] >= 2 && freq[letters[-1]] >= 2
    else
      return has_six_words false
    end
  end
end

n = gets.chomp.to_i
letters = gets.chomp.split(" ").map {|x| x.to_i}
puts calculate n, letters.sort

#tests()
