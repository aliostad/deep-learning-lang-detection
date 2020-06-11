class Stringcalc

STRINGCAlC = "1.0"
  def about
   STRINGCAlC
  end

  def callingprivate(number)
   if number.include? '+'
     addition(number)
   else
     substraction(number)
   end
  end

  def calculate(number)
    return 0
  end

  private
  def addition(number)
    addition=Addition.new()
    addition.calculate(number)
  end 

  def substraction(number)
    substraction=Substraction.new()
    substraction.calculate(number)
  end  

end 

class Addition < Stringcalc
  def calculate(number)
    number= number.split '+'
    number[0].to_i+number[1].to_i
 end
end
class Substraction < Stringcalc
  def calculate(number)
    number= number.split '-'
    number[0].to_i-number[1].to_i
 end
end



