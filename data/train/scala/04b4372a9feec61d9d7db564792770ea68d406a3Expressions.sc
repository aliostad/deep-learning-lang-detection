package week4

object Expressions {

  def precedence(expression: Expression): Int = {
    expression match {
      case _: Number => 3
      case _: Sum => 1
      case _: Product => 2
      case _: Variable => 3
    }
  }                                               //> precedence: (expression: week4.Expression)Int
    
  def show(expr: Expression): String = {
  
    def showOperand(child: Expression): String = {
      if (precedence(child) < precedence(expr)) "(" + show(child) + ")"
      else show(child)
    }
    
    expr match {
      case Number(value) => value.toString
      case Sum(left, right) => showOperand(left) + " + " + showOperand(right)
      case Product(left, right) => showOperand(left) + " * " + showOperand(right)
      case Variable(name) => name
    }
  }                                               //> show: (expr: week4.Expression)String
  
  val expr = Product(Sum(Number(5), Number(1)), Sum(Number(2), Number(6)))
                                                  //> expr  : week4.Product = Product(Sum(Number(5),Number(1)),Sum(Number(2),Numbe
                                                  //| r(6)))
  
  show(expr)                                      //> res0: String = (5 + 1) * (2 + 6)
  expr.eval                                       //> res1: Int = 48
  
}