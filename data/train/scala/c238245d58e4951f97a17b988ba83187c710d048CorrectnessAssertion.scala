package ilc
package language
package bacchus

import org.scalatest.FunSuite

trait CorrectnessAssertion
extends FunSuite
   with feature.base.Derivation
   with FineGrainedDifference
   with ChangingTerms
{
  private[this]
  def assembleTerm(operator: Term, operands: Seq[Term]): Term =
    if (operands.isEmpty)
      operator
    else
      assembleTerm((operator ! operands.head), operands.tail)

  def assertCorrect(t: Term, args: ChangingTerms*) {
    val oldTerm = assembleTerm(t, args.map(_.oldTerm))

    val newOutput = eval(assembleTerm(t, args.map(_.newTerm)))

    val replacement = assembleTerm(derive(t), args flatMap { terms =>
      List(terms.oldTerm, (Diff ! terms.newTerm ! terms.oldTerm).toTerm)
    })

    val surgery = assembleTerm(derive(t), args flatMap { terms =>
      List(terms.oldTerm, fineGrainedDiff(terms.newTerm, terms.oldTerm))
    })

    List(replacement, surgery) foreach { changeTerm =>
      assert(eval(ChangeUpdate ! changeTerm ! oldTerm) === newOutput)
    }
  }
}
