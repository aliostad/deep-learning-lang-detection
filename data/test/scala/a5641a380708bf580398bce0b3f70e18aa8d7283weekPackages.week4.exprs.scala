package weekPackages.week4

object exprs {;import org.scalaide.worksheet.runtime.library.WorksheetSupport._; def main(args: Array[String])=$execute{;$skip(164); 

  def showInParenthesis(e: Expr): String = e match {
    case Sum(_, _) => "(" + show(e) + ")"
    case _ => show(e)
  };System.out.println("""showInParenthesis: (e: weekPackages.week4.Expr)String""");$skip(222); 

  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(l, r) => show(l) + " + " + show(r)
    case Prod(l, r) => showInParenthesis(l) + " * " + showInParenthesis(r)
    case Var(s) => s
  };System.out.println("""show: (e: weekPackages.week4.Expr)String""");$skip(36); val res$0 = 

  show(Sum(Number(1), Number(44)));System.out.println("""res0: String = """ + $show(res$0));$skip(18); val res$1 = 

  show(Var("x"));System.out.println("""res1: String = """ + $show(res$1));$skip(49); val res$2 = 
  show(Sum(Prod(Number(2), Var("x")), Var("y")));System.out.println("""res2: String = """ + $show(res$2));$skip(50); val res$3 = 

  show(Prod(Sum(Number(2), Var("x")), Var("y")));System.out.println("""res3: String = """ + $show(res$3))}

}
