package uk.ac.cam.bsc28.diss.FrontEnd

object ParseTree {

  // TODO: access modifiers for future usage
  // FIXME: important - you've made arithmetic right associative you idiot

  trait Node

  trait Start extends Node
  case class ProcessStart(proc: Process) extends Start

  trait Name extends Node
  case class VariableName(name: String) extends Name
  case class ChannelName(name: String) extends Name

  trait AddOperation extends Node
  case class AddNode() extends AddOperation
  case class SubtractNode() extends AddOperation

  trait MultiplyOperation extends Node
  case class MultiplyNode() extends MultiplyOperation
  case class DivideNode() extends MultiplyOperation

  trait Factor extends Node
  case class VariableFactor(n: VariableName) extends Factor
  case class LiteralFactor(v: Long) extends Factor
  case class ParenthesisedExpressionFactor(e: Expression) extends Factor

  trait Term extends Node
  case class FactorAuxTerm(f: Factor, more: TermAux) extends Term

  trait TermAux extends Node
  case class OperatorTermAux(op: MultiplyOperation, f: Factor, more: TermAux) extends TermAux
  case class EmptyTermAux() extends TermAux

  trait Expression extends Node
  case class TermAuxExpression(t: Term, more: ExpressionAux) extends Expression
  case class ChannelExpression(c: ChannelName) extends Expression

  trait ExpressionAux extends Node
  case class OperatorExpressionAux(op: AddOperation, t: Term, more: ExpressionAux) extends ExpressionAux
  case class EmptyExpressionAux() extends ExpressionAux

  trait Process extends Node
  case class OutProcess(chan: Name, expr: Expression, more: ProcessAux) extends Process
  case class InProcess(chan: Name, varName: VariableName, more: ProcessAux) extends Process
  case class ParallelProcess(left: Process, right: Process, more: ProcessAux) extends Process
  case class ReplicateProcess(proc: Process) extends Process
  case class IfProcess(left: Expression, right: Expression, proc: Process, more: ProcessAux) extends Process
  case class LetProcess(name: VariableName, value: Expression, proc: Process, more: ProcessAux) extends Process
  case class EndProcess() extends Process
  case class FreshProcess(name: VariableName, proc: Process, more: ProcessAux) extends Process

  trait ProcessAux extends Node
  case class SequentialProcessAux(proc: Process, more: ProcessAux) extends ProcessAux
  case class EmptyProcessAux() extends ProcessAux

}
