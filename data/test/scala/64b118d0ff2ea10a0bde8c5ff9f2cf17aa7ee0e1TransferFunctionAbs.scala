package insane
package dataflow

import CFG._
import utils._

abstract class TransferFunctionAbs[E <: EnvAbs[E], S] {
  def apply(stmt: S, oldEnv : E, edge: Option[CFGEdge[S]]) : E
}

abstract class SimpleTransferFunctionAbs[E <: EnvAbs[E], S] extends TransferFunctionAbs[E, S]  {
  def apply(stmt: S, oldEnv : E) : E

  def apply(stmt: S, oldEnv : E, edge: Option[CFGEdge[S]]) : E = {
    apply(stmt, oldEnv)
  }
}

abstract class UnitTransferFunctionAbs[E <: EnvAbs[E], S] extends TransferFunctionAbs[E, S] {
  def apply(stmt: S, oldEnv : E) : Unit

  def apply(stmt: S, oldEnv : E, edge: Option[CFGEdge[S]]) : E = {
    apply(stmt, oldEnv)
    oldEnv
  }
}
