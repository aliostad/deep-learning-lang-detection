
val tolerance = 0.0001

def isClosedEnough(x: Double, y: Double)=
  abs((x-y)/x)/x < tolerance

def abs(num: Double)=
if(num < 0) -num
else num

def fixedPoint(f:Double=>Double)(firstGuess: Double)={
  def iterate(guess: Double): Double = {
    val next = f(guess)
    if(isClosedEnough(guess,next)) next
    else iterate(next)
  }
  iterate(firstGuess)
}

fixedPoint(x=> 1+(x/2))(1)

def averageDump(f: Double => Double)(x: Double)= (x + f(x))/2
def sqrt(x: Double)=
fixedPoint(averageDump(y=>x/y))(1)

sqrt(25)







