package de.ant.api.semantic.parser

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.FlatSpec
import de.ant.semantic.parser.FormulaParsers
import de.ant.semantic.formula.Formulas
import de.ant.semantic.formula.SemanticBehavior

@RunWith(classOf[JUnitRunner])
class FormulaParsersTest extends FlatSpec with FormulaParsers with SemanticBehavior {

  behavior of "formula parser"

  it should "parse atom, 1, 0, ¬" in {
    assert(show(formula("a")) === "a")
    assert(show(formula("1")) === "1")
    assert(show(formula("0")) === "0")
    assert(show(formula("¬a")) === "¬a")
  }

  it should "parse ∧, ∨, →, ↔, ⊕" in {
    assert(show(formula("ab")) === "ab")
    assert(show(formula("a ∧ b")) === "ab")
    assert(show(formula("a ∨ b")) === "a ∨ b")
    assert(show(formula("a → b")) === "a → b")
    assert(show(formula("a ↔ b")) === "a ↔ b")
    assert(show(formula("a ⊕ b")) === "a ⊕ b")
  }

  it should "parse + as ∧, * as ∨" in {
    assert(show(formula("a * b")) === "ab")
    assert(show(formula("a + b")) === "a ∨ b")
  }

  it should "parse nested formula" in {
    assert(show(formula("abcd")) === "abcd")
    assert(show(formula("a ∨ b ∨ c ∨ d")) === "a ∨ b ∨ c ∨ d")
    assert(show(formula("a → b → c → d")) === "((a → b) → c) → d")
    assert(show(formula("a ↔ b ↔ c ↔ d")) === "((a ↔ b) ↔ c) ↔ d")
    assert(show(formula("a ⊕ b ⊕ c ⊕ d")) === "((a ⊕ b) ⊕ c) ⊕ d")
  }

  it should "parse parentheses" in {
    assert(show(formula("(ab)")) === "ab")
    assert(show(formula("(((ab)))")) === "ab")
    assert(show(formula("(ab)(cd)")) === "abcd")
    assert(show(formula("((ab)c)d")) === "abcd")
    assert(show(formula("a(b(cd))")) === "abcd")
  }

  it should "parse combinations of formulas" in {
    assert(show(formula("ab ∨ ab")) === "ab ∨ ab")
  }

  def formula(in: String): Formula =
    parseFormula(in).fold(sys.error, identity)
}