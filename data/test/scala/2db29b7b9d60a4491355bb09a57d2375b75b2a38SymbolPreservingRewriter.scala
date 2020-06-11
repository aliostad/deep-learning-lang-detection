package choicecalculus
package phases
package namer

import lang.trees.{ Choice, Dimension, Identifier, Share, Tree }

trait SymbolPreservingRewriter extends org.kiama.rewriting.CallbackRewriter { 
    self: Namer =>

  def rewriting[T](oldTerm: T, newTerm: T): T = {

    // Fix kiama attribution (otherwise the children property is empty)
    newTerm match {
      case t: Tree => t.initTreeProperties
      case _ =>
    }

    (oldTerm, newTerm) match {

      // Binding instances
      case (oldDim: Dimension, newDim: Dimension) =>
        oldDim->moveSymbolTo(newDim)

      case (oldShare: Share, newShare: Share) =>
        oldShare->moveSymbolTo(newShare)

      // Bound instances
      case (oldId: Identifier, newId: Identifier) =>
        oldId->copySymbol(newId)

      case (oldChoice: Choice, newChoice: Choice) =>
        oldChoice->copySymbol(newChoice)

      case _ =>
    }

    newTerm
  }
}