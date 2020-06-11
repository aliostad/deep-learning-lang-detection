package alaska

/** ExpressionVisitor interface */
abstract class ExprVisitor() {

  def process(expr: Expr): String
}

/**
 * ExpressionVisitor implementation displaying an expression using
 * a postfixed notation
 */
class PostfixedPrinter extends ExprVisitor {

  override def process(expr: Expr): String = expr match {
    case Add(lhs, rhs) => process(lhs) + " " + process(rhs) + " +"
    case Sub(lhs, rhs) => process(lhs) + " " + process(rhs) + " -"
    case Mul(lhs, rhs) => process(lhs) + " " + process(rhs) + " *"
    case Div(lhs, rhs) => process(lhs) + " " + process(rhs) + " /"
    case Const(n) => n.toString
  }
}

/**
 * ExpressionVisitor implementation displaying an expression using
 * a prefixed notation
 */
class PrefixedPrinter extends ExprVisitor {

  override def process(expr: Expr): String = expr match {
    case Add(lhs, rhs) => "+ " + process(lhs) + " " + process(rhs)
    case Sub(lhs, rhs) => "- " + process(lhs) + " " + process(rhs)
    case Mul(lhs, rhs) => "* " + process(lhs) + " " + process(rhs)
    case Div(lhs, rhs) => "/ " + process(lhs) + " " + process(rhs)
    case Const(n) => n.toString
  }
}

class InfixedPrinter extends ExprVisitor {
  override def process(expr: Expr): String = expr match {
    case Add(lhs, rhs) => "(" + process(lhs) + " + " + process(rhs) + ")"
    case Sub(lhs, rhs) => "(" + process(lhs) + " - " + process(rhs) + ")"
    case Mul(lhs, rhs) => "(" + process(lhs) + " * " + process(rhs) + ")"
    case Div(lhs, rhs) => "(" + process(lhs) + " / " + process(rhs) + ")"
    case Const(n) => n.toString
  }
}