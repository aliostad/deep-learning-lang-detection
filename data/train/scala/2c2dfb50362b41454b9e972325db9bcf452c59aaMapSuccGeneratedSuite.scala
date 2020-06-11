package ilc
package examples

import org.scalatest.FunSuite
import ilc.feature.bags.BagChanges
import MapSuccGenerated._

class MapSuccGeneratedSuite
extends FunSuite
   with BagChanges
{
  val n = 100

  val oldInput: InputType = (1 to n).map(i => i -> 1)(collection.breakOut)
  val oldOutput = program(oldInput)

  test("the compiled derivative increments collections") {
    val expected: OutputType = for {
      (element, multiplicity) <- oldInput
    } yield (element + 1, multiplicity)
    assert(oldOutput === expected)
  }

  test("the compiled derivative is correct") {
    import collection.immutable.TreeMap // for sorted print-out
    changes foreach { change =>
      val outputChange = derivative(oldInput)(change)
      val updatedOutput = updateOutput(outputChange)(oldOutput)
      val newInput = updateInput(change)(oldInput)
      assert(
        TreeMap(updatedOutput.toSeq: _*) ===
          TreeMap(program(newInput).toSeq: _*))
    }
  }

  val changes: Iterable[ChangeToBags[Int]] =
    changesToBagsOfIntegers.map(_ _2 n)

}
