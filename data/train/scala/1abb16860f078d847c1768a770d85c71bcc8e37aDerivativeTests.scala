package ilc
package language
package bacchus

import ilc.feature._

/** Tests for all kinds of derivations
  *
  * Examples:
  * {{{
  * // test the correctness of basic derivation
  * class BacchusBasicDerivationSuite
  * extends DerivationTests
  *    with BasicDerivation
  *
  * // test the correctness of optimized derivation
  * class BacchusOptimizedDerivationSuite
  * extends DerivationTests
  *    with OptimizedDerivation
  * }}}
  */

trait DerivativeTests
extends CorrectnessAssertion
   with Subjects
   with Evaluation
   with naturals.ImplicitSyntaxSugar
{
  test("diff and apply works on functions") {
    val f = PlusNat ! 25
    val g = PlusNat ! 100
    assert(eval(ChangeUpdate ! (Diff ! g ! f) ! f ! 20).toNat === 120)
  }

  test("[s ⊕ (t ⊝ s) == t] holds for maybe, sums, numbers and maps") {
    def applyDiff(s: Term, t: Term): Value =
      eval(ChangeUpdate ! (Diff ! t ! s) ! s)
    val ff = Nope(ℕ)
    val tt = Just ! 0
    val ll = Inj1(ℕ) ! 0
    val rr = Inj2(ℕ) ! 0
    List.apply[ChangingTerms](
      ff ↦ ff, ff ↦ tt, tt ↦ ff, tt ↦ tt,
      ll ↦ ll, ll ↦ rr, rr ↦ ll, rr ↦ rr,
      392 ↦ 1522,
      (sum ! oldMap) ↦ (sum ! newMap),
      oldMap ↦ newMap,
      mapLiteral(oldMap -> EmptyMap(ℕ, ℕ),
                 newMap -> oldMap,
                 mapLiteral(99 -> 217) -> mapLiteral(2012 -> 56)) ↦
        mapLiteral(oldMap -> EmptyMap(ℕ, ℕ),
                   newMap -> newMap,
                   EmptyMap(ℕ, ℕ) -> newMap)
    ).foreach { case ChangingTerms(oldTerm, newTerm) =>
      assert(applyDiff(oldTerm, newTerm) === eval(newTerm))
    }
  }

  test("the derivative of constants are nil changes of themselves") {
    def assertNil(t: Term): Unit =
      assert(eval(ChangeUpdate ! derive(t) ! t) === eval(t))

    List.apply[Term](
      Nat(5), EmptyMap(ℕ, ℕ), Inj1(ℕ) ! EmptyMap(ℕ, ℕ), Inj2(ℕ) ! 5
    ).foreach(assertNil)
  }

  test("the derivative of Plus is correct") {
    (natPairs, natPairs.reverse).zipped.foreach { (p1, p2) =>
      val ((x, xNew), (yNew, y)) = (p1, p2)
      assertCorrect(PlusNat, x ↦ xNew, y ↦ yNew)
    }
  }

  test("the derivative of FoldNat is correct") {
    val args2 = List(5 ↦ 1997, (PlusNat ! 25) ↦ (PlusNat ! 100))
    val args3 = args2 ++ List(40 ↦ 5)

    assertCorrect(FoldNat(ℕ), args3: _*)

    val foldNatWithFixedIterations: Term =
      lambda(ℕ, ℕ =>: ℕ) { case Seq(z, f) => FoldNat ! z ! f ! 25 }

    assertCorrect(foldNatWithFixedIterations, args2: _*)
  }

  test("the derivative of Update is correct") {
    // stable keys and values
    keyCases foreach { key =>
      assertCorrect(Update ! key ! 18, oldMap ↦ newMap)
    }

    // stable keys
    keyCases foreach { key =>
      assertCorrect((Update ! key) % ℕ, 10 ↦ 18, oldMap ↦ newMap)
    }

    // changing everything
    for {
      oldKey <- keyCases
      newKey <- keyCases
    } {
      assertCorrect(Update(ℕ, ℕ), oldKey ↦ newKey, 10 ↦ 18, oldMap ↦ newMap)
    }
  }

  test("the derivative of Delete is correct") {
    // stable key & map
    assertCorrect(Delete ! 4 ! oldMap)
    assertCorrect(Delete ! 5 ! oldMap)

    // stable key
    List(1, 3, 5, 7).foreach { i =>
      assertCorrect(Delete(ℕ, ℕ) ! i, oldMap ↦ newMap)
    }

    // changing everything
    assertCorrect(Delete(ℕ, ℕ), 5 ↦ 5, oldMap ↦ oldMap)
    assertCorrect(Delete(ℕ, ℕ), 5 ↦ 5, oldMap ↦ newMap)
    assertCorrect(Delete(ℕ, ℕ), 5 ↦ 7, oldMap ↦ newMap)
  }

  test("the derivative of Fold is correct") {
    val plusValue = lambda(ℕ) { x => PlusNat }

    // constant f z
    assertCorrect(Fold ! plusValue ! 0, oldMap ↦ newMap)

    // constant f
    assertCorrect(Fold ! plusValue, 0 ↦ 100, oldMap ↦ newMap)

    // changing everything
    assertCorrect(Fold(ℕ, ℕ, ℕ),
      plusValue ↦ lambda(ℕ, ℕ, ℕ) {
        case Seq(k, x, y) => PlusNat ! (PlusNat ! 2000 ! x) ! y
      },
      0 ↦ 100,
      oldMap ↦ newMap)
  }
}
