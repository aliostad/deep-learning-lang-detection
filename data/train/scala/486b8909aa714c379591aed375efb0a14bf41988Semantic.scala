package de.ant.api.semantic

import scalaz.syntax.id._

object Semantic extends App {

  val f1 = (¬('r) ∧ 'q) ∧ (¬('p ∧ 'q) ↔ (¬('p) ∨ ¬('q)))
  println(isSatisfiable(f1))
  println(applyRule(f1))
  println("show: "+show(f1))
  println("normalized: "+show(normalize(f1)))

  println(">>"+((('a ∨ ¬('a)) ∧ _1) ∨ _1 |> axioms |> show))

  println(('c ∧ ('b ⊕ 'a)) ∨ (¬('c) ∧ ('b ∨ 'a)) |> normalize |> show)
  println((¬('b) ∨ ¬('a)) ↔ ('b ∨ 'a) |> normalize |> show)

  println('c → ((¬('b) ∧ 'a) ⊕ 'c) |> normalize |> show)
}