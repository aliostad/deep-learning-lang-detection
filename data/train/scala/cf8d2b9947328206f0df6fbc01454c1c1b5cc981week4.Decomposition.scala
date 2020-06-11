package week4

object Decomposition {;import org.scalaide.worksheet.runtime.library.WorksheetSupport._; def main(args: Array[String])=$execute{;$skip(197); 

  def eval(e: ExprOld): Int = {
    if (e.isNumberOld) e.numValue
    else if (e.isSumOld) eval(e.leftOp) + eval(e.rightOp)
    else throw new Error("NO")
  };System.out.println("""eval: (e: week4.ExprOld)Int""");$skip(57); val res$0 = 
  
  eval(new SumOld(new NumberOld(1),new NumberOld(2)));System.out.println("""res0: Int = """ + $show(res$0))}

}

trait ExprOld {
  def isNumberOld: Boolean
  def isSumOld: Boolean
  def numValue: Int
  def leftOp: ExprOld
  def rightOp: ExprOld
}

class NumberOld(n: Int) extends ExprOld {
  def isNumberOld: Boolean = true
  def isSumOld: Boolean = false
  def numValue: Int = n
  def leftOp: ExprOld = throw new Error("NumberOld.leftOp")
  def rightOp: ExprOld = throw new Error("NumberOld.rightOp")
}

class SumOld(e1: ExprOld, e2: ExprOld) extends ExprOld {
  def isNumberOld: Boolean = false
  def isSumOld: Boolean = true
  def numValue: Int = throw new Error("SumOld.numValue")
  def leftOp: ExprOld = e1
  def rightOp: ExprOld = e2
}
