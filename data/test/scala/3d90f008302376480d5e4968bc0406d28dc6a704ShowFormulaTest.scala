package de.ant.api.semantic

import org.scalatest.FlatSpec
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class ShowFormulaTest extends FlatSpec {

  behavior of "function 'show'"

  it should "shorten atom, 1, 0, ¬, ∨, ∧, →, ↔ and ⊕" in {
    assert(show('a) === "a")
    assert(show(_1) === "1")
    assert(show(_0) === "0")
    assert(show(¬('a)) === "¬a")
    assert(show('a ∨ 'b) === "a ∨ b")
    assert(show('a ∧ 'b) === "ab")
    assert(show('a → 'b) === "a → b")
    assert(show('a ↔ 'b) === "a ↔ b")
    assert(show('a ⊕ 'b) === "a ⊕ b")
  }

  it should "shorten long ∨ and ∧ chains" in {
    assert(show((('a ∨ 'b) ∨ 'c) ∨ 'd) === "a ∨ b ∨ c ∨ d")
    assert(show('a ∨ ('b ∨ ('c ∨ 'd))) === "a ∨ b ∨ c ∨ d")
    assert(show((('a ∧ 'b) ∧ 'c) ∧ 'd) === "abcd")
    assert(show('a ∧ ('b ∧ ('c ∧ 'd))) === "abcd")
    assert(show(('a ∧ 'b) ∨ 'c) === "ab ∨ c")
    assert(show('a ∨ ('b ∧ 'c)) === "a ∨ bc")
    assert(show(('a ∨ 'b) ∧ 'c) === "(a ∨ b)c")
    assert(show('a ∧ ('b ∨ 'c)) === "a(b ∨ c)")
  }

  it should "shorten 1, 0 and ¬ in nested formulas" in {
    assert(show('a ∧ _1) === "a1")
    assert(show(_1 ∧ 'a) === "1a")
    assert(show(('a ∧ 'b) ∧ ¬('c)) === "ab¬c")
    assert(show(('a ∧ 'b) ∨ ¬('c)) === "ab ∨ ¬c")
    assert(show(('a ∨ 'b) ↔ ¬('c)) === "(a ∨ b) ↔ ¬c")
  }

  it should "not shorten combined ∨ and ∧" in {
    assert(show(('a ∨ 'b) ∧ 'c) === "(a ∨ b)c")
    assert(show('a ∧ ('b ∨ 'c)) === "a(b ∨ c)")
    assert(show(('a ∧ 'b) ∨ 'c) === "ab ∨ c")
    assert(show('a ∨ ('b ∧ 'c)) === "a ∨ bc")
  }

  it should "not shorten combined ¬ with ∨, ∧" in {
    assert(show(¬('a ∧ 'b ∧ 'c)) === "¬(abc)")
    assert(show(¬(¬('a) ∨ 'b) ∨ 'b) === "¬(¬a ∨ b) ∨ b")
    assert(show(¬(¬('a ∧ 'b ∧ 'c))) === "¬(¬(abc))")
  }

  it should "group nested formulas with parentheses" in {
    assert(show(('a ∨ 'b) ∧ ('c ∨ 'a)) === "(a ∨ b)(c ∨ a)")
    assert(show('a ∨ ('b → 'c)) === "a ∨ (b → c)")
    assert(show(('a → 'b) → 'c) === "(a → b) → c")
    assert(show('a ∨ ('b → ('c ↔ ¬('a)))) === "a ∨ (b → (c ↔ ¬a))")
    assert(show((¬('a) → ('a ∧ 'b ∧ 'c)) ∨ 'b) === "(¬a → abc) ∨ b")
    assert(show(('a ↔ 'b) → ('c ∧ 'b ∧ ¬('a))) === "(a ↔ b) → cb¬a")
  }

}