
object weektwo {
def abs(x:Double):Double = if(x<0) -x else x      //> abs: (x: Double)Double

  println("Welcome to the Scala worksheet")       //> Welcome to the Scala worksheet
  val tolerance = 0.0001                          //> tolerance  : Double = 1.0E-4
  
  def isCloseEnough(x:Double,y:Double):Boolean=
  abs((x-y)/x/2)< tolerance                       //> isCloseEnough: (x: Double, y: Double)Boolean
  
  def fixedPoint(f:Double=>Double)(firstguess:Double)={
  def iterate(guess:Double):Double={
  val next = f(guess)
  if(isCloseEnough(guess,next)) next
   else iterate(next)
  }
  iterate(firstguess)
  
  }                                               //> fixedPoint: (f: Double => Double)(firstguess: Double)Double
  
  def averageDump(f:Double=>Double)(x:Double)=(x+f(x))/2
                                                  //> averageDump: (f: Double => Double)(x: Double)Double
  
 def sqrt(x:Double)=fixedPoint(averageDump(y=>x/y))(1)
                                                  //> sqrt: (x: Double)Double
sqrt(2)                                           //> res0: Double = 1.4142135623746899

}