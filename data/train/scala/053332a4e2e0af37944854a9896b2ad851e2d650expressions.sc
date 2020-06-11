package week4

object expressions {

	def eval(e: Expr): Int = e match {
		case Number(n) => n
		case Sum(l, r) => eval(l) + eval(r)
	}                                         //> eval: (e: week4.Expr)Int
	
	def show(e: Expr): String = e match {
		case Number(n) => n.toString
		case Sum(l, r) => show(l) + " + " + show(r)
		case Var(v) => v
		case Prod(l, r) => {
			def innerProd(inner: Expr): String = inner match {
				case Sum(_, _) => "(" + show(inner) + ")"
				case _ => show(inner)
			}
			innerProd(l) + " * " + innerProd(r)
		}
 	}                                         //> show: (e: week4.Expr)String
 	
 	val example1 = Sum(Number(3), Number(4))  //> example1  : week4.Sum = Sum(Number(3),Number(4))
 	val example2 = Sum(Prod(Number(2), Var("x")), Var("y"))
                                                  //> example2  : week4.Sum = Sum(Prod(Number(2),Var(x)),Var(y))
 	val example3 = Prod(Sum(Number(2), Var("x")), Var("y"))
                                                  //> example3  : week4.Prod = Prod(Sum(Number(2),Var(x)),Var(y))

 	show(example1)                            //> res0: String = 3 + 4
 	eval(example1)                            //> res1: Int = 7
 	show(Var("aVar"))                         //> res2: String = aVar
 	show(example2)                            //> res3: String = 2 * x + y
 	show(example3)                            //> res4: String = (2 + x) * y

 	show(Sum(example2, example3))             //> res5: String = 2 * x + y + (2 + x) * y
 	show(Prod(example2, example3))            //> res6: String = (2 * x + y) * (2 + x) * y

 	show(Prod(Sum(example2, example3), example2))
                                                  //> res7: String = (2 * x + y + (2 + x) * y) * (2 * x + y)
 	show(Prod(Sum(example2, example3), example3))
                                                  //> res8: String = (2 * x + y + (2 + x) * y) * (2 + x) * y
}