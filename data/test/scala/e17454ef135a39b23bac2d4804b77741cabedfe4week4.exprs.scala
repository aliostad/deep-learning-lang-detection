package week4

object exprs {;import org.scalaide.worksheet.runtime.library.WorksheetSupport._; def main(args: Array[String])=$execute{;$skip(420); 
  def show(e:Expr):String = e match {
  	case Number(x) => x.toString
  	//case Sum(l,r) => "("+show(l) + "+" + show(r)+")"
  	case Prod(l,r) => show(l) + "*" + show(r)
  	case Prod(l:Number,r:Number) => show(l) + "*" + show(r)
  	//case Prod(l:Sum,r:Sum) => "("+show(l)+")" + "*" + "("+ show(r)+")"
  	//case Prod(l:Sum,r:Var) => "("+show(l)+")" + "*" + show(r)
  	case Var(name) => name
};System.out.println("""show: (e: week4.Expr)String""");$skip(36); val res$0 = 
  
  show(Sum(Number(1),Number(2)));System.out.println("""res0: String = """ + $show(res$0));$skip(32); val res$1 = 
  show(Sum(Number(1),Var("X")));System.out.println("""res1: String = """ + $show(res$1));$skip(48); val res$2 = 
  show(Sum(Prod(Number(2),Var("X")), Var("Y")));System.out.println("""res2: String = """ + $show(res$2));$skip(48); val res$3 = 
  show(Prod(Sum(Number(2),Var("X")), Var("Y")));System.out.println("""res3: String = """ + $show(res$3))}
}
