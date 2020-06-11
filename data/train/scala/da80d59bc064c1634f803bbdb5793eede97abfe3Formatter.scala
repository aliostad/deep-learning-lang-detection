package js

import java.io.Writer

import js.JsToken.Operator
import js.ast._

/**
 * Created by Kamil on 24.09.2015.
 */
object Formatter {

  def write(node: AstNode): String = node match {

    case Access(from, prop) => s"${write(from)}.$prop"
    case VarAccess(name) => name
    case Block(statements) =>
      val lines = statements map write map (_+";")
      "{" + lines.mkString + "}"
    case Call(fun, pars, Seq(), None) => s"${write(fun)}(${pars map write mkString ","})"
    case Function(params, body: Block) =>
      val paramNames = params map {
        case VarPattern(n) => n
        case IgnorePattern => "_"
      } mkString ","
      s"function($paramNames)${write(body)}"
    case FunctionDef(name, params, body: Block) => s"function $name(${params mkString ","})${write(body)}"
    case Return(v) => s"return ${write(v)}"
    case OperatorExpression(l, Operator(o), r) => s"${write(l)}$o${write(r)}"
    case Var(VarPattern(name), Some(v)) => s"var $name=${write(v)}"
    case Var(VarPattern(name), None) => s"var $name"
    case StringValue(v) =>
      val escaped = v replaceAll("\"", "\\\"")
      "\"" + escaped + "\""
    case NumberValue(v) => v.toString
    case BooleanValue(true) => "true"
    case BooleanValue(false) => "false"
    case ArrayLiteral(vals) =>
      val v = vals map write mkString ","
      s"[$v]"
    case VanillaFor(init, cond, iter, body: Block) => s"for(${write(init)};${write(cond)};${write(iter)})${write(body)}"
    case If(cond, then, None) => s"if(${write(cond)})${write(then)}"
    case If(cond, then, Some(els)) => s"if(${write(cond)})${write(then)} else ${write(els)}"
    case OperatorAssignement(lval, Operator(op), rval) => s"${write(lval)}$op=${write(rval)}"
    case Paren(exp) => s"(${write(exp)})"
    case Subscript(arr, idx) => s"${write(arr)}[${write(idx)}]"
    case UnaryOperatorExpression(Operator(op), exp) => s"$op${write(exp)}"
    case While(cond, body) => s"while(${write(cond)})${write(body)}"
    case Assignement(lval, rval) => s"${write(lval)}=${write(rval)}"
    case ObjectLiteral(props) =>
      val p = props map { case (k, v) => s"${write(StringValue(k))}: ${write(v)}"} mkString ","
      s"{$p}"
    case InlineJavascript(src) => src
    case Throw(e) => s"throw ${write(e)}"
    case New(e) => s"new ${write(e)}}"
  }

}
