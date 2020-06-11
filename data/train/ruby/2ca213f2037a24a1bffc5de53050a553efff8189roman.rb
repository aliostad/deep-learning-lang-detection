class Roman

  def initialize
    @tracker=""
  end

  def calculate_symbol(digit,iterator,letter)
    if digit.modulo(iterator)==digit
      count=0
    else 
      count=((digit-(digit.modulo(iterator)))/iterator)
    end
    @tracker+=letter*count
    digit.modulo(iterator)
  end

  def convert(digit)
    digit=calculate_symbol(digit,1000,"M")
    digit=calculate_symbol(digit,500,"D")
    digit=calculate_symbol(digit,100,"C")
    digit=calculate_symbol(digit,50,"L")
    digit=calculate_symbol(digit,10,"X")
    digit=calculate_symbol(digit,5,"V")
    calculate_symbol(digit,1,"I")
    puts @tracker
  end

end

puts "What number would you like to convert into Roman numerals?"
answer=gets.chomp!
attempt=Roman.new
puts attempt.convert(answer.to_i)