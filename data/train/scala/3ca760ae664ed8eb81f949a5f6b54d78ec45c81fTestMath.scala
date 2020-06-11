package math.test

import math.symbolic._
import math.symbolic.functions._
import math.symbolic.Preamble._
import math.values._

object TestMath {
  val x = new Variable[DoubleVal] ("x")
  
  def main(args : Array[String]) : Unit = {
    val one = new DoubleVal (1)
    val zero = new DoubleVal (0)    
    val values = Map (x -> DoubleVal (4))
    val point = new EvalPoint (values)
    val xSquared = new Pow (one, x, DoubleVal (2))
    val xCubed = new Pow (one, x, DoubleVal (3))
    val prod = xSquared * xCubed
    
    val quotient = Quotient (xCubed, xSquared)
    val poly = 3 * x * x * x + 3.0 * x;
        
    show (new Constant (one).eval (point))    
    show (xSquared.diff (x).eval (point))
    show (xCubed.diff (x).eval (point))
    show (prod)
    show (prod.diff (x))
    show (prod.eval (point))
    show (new Constant (DoubleVal (8)).diff (x))
    show ("--")
    show (quotient.diff (x))
    show (poly)
    show (poly.eval (point))
    show (x * x * x * (x * x))
    show (Simplifier.flattenProd (x * x * x * (x * x)))
    show (Simplifier.collect (x * x * x))
    show (Simplifier.collect (Simplifier.collect (x * x * x * x * x)))
    val f = (1 / x)
    val df = f.diff (x)
    show (f)
    show (df)
    show (df.eval (ep(1)))
    show (df.eval (ep(2)))
    show ("--")
    val fun = Quotient (Constant (one), x).diff (x)
    show (fun)
    show (fun.eval (point))
    show (Invert (x).diff (x))
  }
  
  def ep (d : Double) = EvalPoint (Map (x -> DoubleVal (d)))
  
  def show (v : Any) {
    print (v)
    println
  } 
}