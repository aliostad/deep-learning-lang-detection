package org.shapefun.parser.syntaxtree

import org.shapefun.utils.ParameterChecker
import org.shapefun.parser.{NumKind, Kind, Context}

/**
 *
 */
case class IncDecOp(identifier: Symbol, increment: Boolean) extends Expr {
  ParameterChecker.requireIsIdentifier(identifier, 'identifier)

  protected def doCalculateTypes(staticContext: StaticContext): Kind = {
    // TODO: Get specified var from context, check that it is a var
    // TODO: Get type of specified var from context, check that it is num

    NumKind
  }

  def calculate(context: Context): AnyRef = {
    val oldBoxedVal: AnyRef = context.getVar(identifier)
    val oldValue = Double.unbox(oldBoxedVal)
    val newValue = Double.box(if (increment) oldValue + 1 else oldValue - 1)
    context.setVar(identifier, newValue)
    oldBoxedVal
  }
}