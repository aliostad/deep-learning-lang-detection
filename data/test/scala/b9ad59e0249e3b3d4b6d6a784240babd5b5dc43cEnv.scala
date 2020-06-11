package bhoward.interp3a

import bhoward.interp._

trait Env {
  def get(name: String): Val
}

case object Init extends Env {
  def get(name: String): Val = name match {
    case "succ" => Succ
    case "pred" => Pred
    case "=" => Eq1
    case "+" => Plus1
    case "-" => Minus1
    case "*" => Times1
    case "/" => Divide1
  }
}

case class Simp(bvar: Var, bval: Val, old: Env) extends Env {
  def get(name: String): Val = if (name == bvar.name) bval else old.get(name)
}

case class Rec(letx: LetRec, old: Env) extends Env {
  def get(name: String): Val = if (name == letx.dvar.name) Closure(letx.dexp, this) else old.get(name)
}
