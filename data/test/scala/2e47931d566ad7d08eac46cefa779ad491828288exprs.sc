package week4

object exprs {
  def show(e:Expr):String = e match {
  	case Number(x) => x.toString
  	//case Sum(l,r) => "("+show(l) + "+" + show(r)+")"
  	case Prod(l,r) => show(l) + "*" + show(r)
  	case Prod(l:Number,r:Number) => show(l) + "*" + show(r)
  	//case Prod(l:Sum,r:Sum) => "("+show(l)+")" + "*" + "("+ show(r)+")"
  	//case Prod(l:Sum,r:Var) => "("+show(l)+")" + "*" + show(r)
  	case Var(name) => name
}                                                 //> show: (e: week4.Expr)String
  
  show(Sum(Number(1),Number(2)))                  //> scala.MatchError: Sum(Number(1),Number(2)) (of class week4.Sum)
                                                  //| 	at week4.exprs$$anonfun$main$1.show$1(week4.exprs.scala:4)
                                                  //| 	at week4.exprs$$anonfun$main$1.apply$mcV$sp(week4.exprs.scala:14)
                                                  //| 	at org.scalaide.worksheet.runtime.library.WorksheetSupport$$anonfun$$exe
                                                  //| cute$1.apply$mcV$sp(WorksheetSupport.scala:76)
                                                  //| 	at org.scalaide.worksheet.runtime.library.WorksheetSupport$.redirected(W
                                                  //| orksheetSupport.scala:65)
                                                  //| 	at org.scalaide.worksheet.runtime.library.WorksheetSupport$.$execute(Wor
                                                  //| ksheetSupport.scala:75)
                                                  //| 	at week4.exprs$.main(week4.exprs.scala:3)
                                                  //| 	at week4.exprs.main(week4.exprs.scala)
  show(Sum(Number(1),Var("X")))
  show(Sum(Prod(Number(2),Var("X")), Var("Y")))
  show(Prod(Sum(Number(2),Var("X")), Var("Y")))
}