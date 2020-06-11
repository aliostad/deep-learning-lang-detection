import worksheets.week4._

object exprs {
  println("Welcome to the Scala worksheet")       //> Welcome to the Scala worksheet
  
  def show(e:Expr):String =e match{
  	case Number(x) =>x.toString
  	case Var(x) =>x
  	case Sum(l,r) =>show(l)+"+"+ show(r)
  	case Proc(l,r) =>{
  		val left=l match{
  			case Sum(l,r)=>"("+show(Sum(l,r))+")"
  			case _ =>show(l)
  		}
  		val right=r match{
  			case Sum(l,r)=>"("+show(Sum(l,r))+")"
  			case _ =>show(r)
  		}
  		left+"*"+ right
  	}
  }                                               //> show: (e: worksheets.week4.Expr)String
  
  show(Sum(Number(1),Number(44)))                 //> res0: String = 1+44
  
  show(Sum(Proc(Number(2),Var("x")),Var("y")))    //> res1: String = 2*x+y
  show(Proc(Sum(Number(2),Var("x")),Var("y")))    //> res2: String = (2+x)*y
  show(Proc(Sum(Number(2),Var("x")),Sum(Var("y"),Number(13))))
                                                  //> res3: String = (2+x)*(y+13)
}