


object ExprShow {;import org.scalaide.worksheet.runtime.library.WorksheetSupport._; def main(args: Array[String])=$execute{;$skip(218); 
     def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Var(x) => x
    case Sum(l, r) => show(l) + " + " + show(r)
    case Prod(l, r) => show(l) + " * " + show(r)
  };System.out.println("""show: (e: <error>)String""");$skip(49); val res$0 = 
  show(Sum(Prod(Number(2), Var("x")), Var("y")));System.out.println("""res0: <error> = """ + $show(res$0))}
  
}
