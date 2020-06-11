include Math
require 'bigdecimal'

=begin
create String class
=end
class  String
   def truncate(n)
     self[0,n] 
   end
   def isNotNumber
    match(/\A[+-]?\d+?(_?\d+)*(\.\d+e?\d*)?\Z/) == nil ? true : false
  end
end
def Accuracy()
  return 0.0001
end

=begin
define factorial functionality
=end
def calculateFactorial(n)     
  if n < 1     
    return 1     
  else     
    return n * calculateFactorial(n-1)   
  end 
end

=begin
define power functionality
=end
def calculatePowerNum(x,powerNum)
  if powerNum == 0
    return 1
  else
     return x*calculatePowerNum(x,powerNum-1) 
   end
 end
 
=begin
get absolute value
=end
def Absolute(value)
  if(value <= 0)
    value = value.abs
  else 
    value = value
  end
  return value
end

=begin
get value of pi
=end
def calculatePi()
iterations = 10
sum = BigDecimal.new("0")
 
for k in (0..iterations)
  sum += 
    (
      BigDecimal.new(((-1)**k).to_s)
      BigDecimal.new(calculateFactorial(6*k).to_s) *
      BigDecimal.new((13591409 + 545140134 * k).to_s)
    ) / 
    (
      BigDecimal.new(calculateFactorial(3*k).to_s) *
      BigDecimal.new(calculateFactorial(k).to_s)**3 *
      BigDecimal.new(((640320)**(3*k+3.0/2.0)).to_s)
    )
  end
  pi = BigDecimal.new("1")/(BigDecimal.new("12")*sum)
  String s =pi.to_s('F')
  p = s.truncate(16)
return p.to_f()
end

=begin
f1(x,k) = power(x,k)/k!
=end
def f1(x,k)
  if k == 0
    return 1
  else
    return  calculatePowerNum(x,k)/calculateFactorial(k)   
  end
end

=begin
get value of k
=end
def calculateK()
k = 0
while  f1(PI,k) > Accuracy()
  k = k + 1
end
return k
end

=begin
f2 = a - sin(a)
=end
def f2(alpha)
  m=[]
  n=[]  
  sum1 = 0
  sum2 = 0
  i=0
  while i >=0 && (4 * i + 5)<=calculateK()
  m[i]= 4 * i + 3
  n[i] = 4 * i + 5
  sum1 = sum1 + f1(alpha,m[i])
  sum2 = sum2 + f1(alpha,n[i]) 
  i = i+1
end
return sum1-sum2
end

=begin
f3 = a - sin(a) - PI/2
=end
def f3(alpha)
  return f2(alpha)-PI/2
end

=begin
get value of alpha
=end
def calculateAlpha()
alpha = 2*PI/3
while alpha<=PI
  a1 = Absolute(f3(alpha))
  a2 = Absolute(f3(alpha+Accuracy()))
  if (a2 > a1)
    return alpha
  end
alpha = alpha + Accuracy()
end
end

=begin
get value of iterations
=end
def calculateTimes()
alpha = 2*PI/3
s = []
i = 0
while alpha<=PI
  s[i] = Absolute(f3(alpha))
  s[i+1] = Absolute(f3(alpha+Accuracy()))
  if (s[i+1] > s[i])
    return i+1
  end
i = i + 1
alpha = alpha + Accuracy()
end
end

=begin
define sinAlpha function
=end
def sinAlpha(x)
sin = 0
for n in 0..((calculateK()-1)/2)
sin = sin + calculatePowerNum(-1,n)*calculatePowerNum(x,2*n+1)/calculateFactorial(2*n+1)
end
return sin
end

=begin
define cosAlpha function
=end
def cosAlpha(x)
return sqrt(1-calculatePowerNum(sinAlpha(x),2))
end 

=begin
calculate L
=end
def calculateLength(r)
return 2*r*(1-cosAlpha(calculateAlpha()/2))
end

print "Enter the Radius: "
Radius = gets
if Radius.isNotNumber
  print "Warning: Invalid input of Radius!!!\n"
  exit
elsif Radius.to_f < 0
  print "Warning: Radius cannot be negative value!!!\n"
  exit
end
print "Calculated Pi value: "
print calculatePi(),"\n"
print "Calculated Alpha value: "
print calculateAlpha(),"\n"
print "Length of Overlap of the two circles (L): "
print calculateLength(Radius.to_f),"\n"
print "   R          L","\n"
print "   1    ",calculateLength(1.0),"\n"
print "   5    ",calculateLength(5.0),"\n"
print "   10   ",calculateLength(10.0),"\n"
print "   20   ",calculateLength(20.0),"\n"
print "   50   ",calculateLength(50.0),"\n"
print "   100  ",calculateLength(100.0),"\n"
print "   200  ",calculateLength(200.0),"\n"
print "   500  ",calculateLength(500.0),"\n"
print "   1000 ",calculateLength(1000.0),"\n"