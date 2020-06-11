package week4

object Exprs {;import org.scalaide.worksheet.runtime.library.WorksheetSupport._; def main(args: Array[String])=$execute{;$skip(73); 
  println("Welcome to the Scala worksheet");$skip(123); 
  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(l, a) => show(l) + "+" + show(a)
  };System.out.println("""show: (e: week4.Expr)String""");$skip(19); val res$0 = 

  show(Number(1));System.out.println("""res0: String = """ + $show(res$0));$skip(34); val res$1 = 
  show(Sum(Number(1), Number(2)));System.out.println("""res1: String = """ + $show(res$1))}
}
