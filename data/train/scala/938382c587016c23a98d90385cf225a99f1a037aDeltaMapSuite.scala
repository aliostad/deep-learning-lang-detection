package ilc
package feature
package maps

import org.scalatest.FunSuite

class DeltaMapSuite
extends FunSuite
   with ReplacementValuesDerivation
   with SyntaxSugar
   with Evaluation
   with integers.AbelianDerivation
   with integers.Evaluation
   with integers.ImplicitSyntaxSugar
   with sums.Evaluation
   with functions.Pretty // for debugging
{
  val oldMap = mapLiteral(1 -> 100, 2 -> 200, 3 -> 300)

  val newMap = mapLiteral(1 -> 100, 2 -> 400, 5 -> 500)

  /** surgical change from `oldMap` to `newMap` */
  val surgery: Term = {
    import MapSurgery._
    mkSurgicalMapChange(IntType, IntType)(
      MODIFY(2, replacementChange ! 400),
      DELETE(3),
      INSERT(5, 500)
    )
  }

  /** replacement change from `oldMap` to `newMap` */
  val replacement: Term = mkMapReplacement(newMap)

  test("updateTerm behaves as expected on replacement changes") {
    assert(eval(ChangeUpdate ! replacement ! oldMap) === eval(newMap))
  }

  test("updateTerm behaves as expected on surgical changes") {
    assert(eval(ChangeUpdate ! surgery ! oldMap) === eval(newMap))
  }

  test("diffTerm produces replacement changes") {
    assert(eval(Diff ! newMap ! oldMap) === eval(replacement))
  }

  test("mapMinus behaves as expected") {
    assert(eval(mapMinus ! oldMap ! newMap) === MapValue(3 -> 300))
    assert(eval(mapMinus ! newMap ! oldMap) === MapValue(5 -> 500))
  }
}
