package chris.sat.parsers

import chris.sat._
import org.scalatest.{FlatSpec, Matchers}

class DimacsResult$Test extends FlatSpec with Matchers {

  behavior of "DimacsResult$"

  it should "parse unknown" in {
    DimacsResult.parse(Seq("s UNKNOWN")) shouldBe Unknown
  }

  it should "parse unsatisfiable" in {
    DimacsResult.parse(Seq("s UNSATISFIABLE")) shouldBe Unsatisfiable
  }

  it should "parse satisfiable" in {
    DimacsResult.parse(Seq("s SATISFIABLE")) should matchPattern {
      case Satisfiable() => }
  }

  it should "parse solutions" in {
    val lines = Seq(
      "s SATISFIABLE",
      "v 1 -2 3 0")
    DimacsResult.parse(lines) should matchPattern {
      case Satisfiable(1, -2, 3) =>
    }
  }

  it should "dump results" in {
    DimacsResult.dump(Unknown) shouldEqual Seq("s UNKNOWN")
    DimacsResult.dump(Unsatisfiable) shouldEqual Seq("s UNSATISFIABLE")
    DimacsResult.dump(Satisfiable()) shouldEqual Seq("s SATISFIABLE")
    val result = Satisfiable(1, -2, 3)
    DimacsResult.dump(result) shouldEqual Seq("s SATISFIABLE", "v 1 -2 3 0")
  }
}
