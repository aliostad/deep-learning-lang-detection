import models._
import org.junit.runner.RunWith
import org.specs2.mutable.Specification
import org.specs2.runner.JUnitRunner

@RunWith(classOf[JUnitRunner])
class SymbolSpec extends Specification with SymbolTestData  {
  "Finding symbols" should {
    "watch unique symbols move around" in {
      findOld(newStaysPut) must_== Some(oldStaysPut)
      findOld(newMoves) must_== Some(oldMoves)
    }

    "fail to find old symbols for newly created ones" in {
      findOld(newCreated) must_== None
    }

    "fail to find ambiguous renamings" in  {
      findOld(newAmbiguous1) must_== None
    }

    "use diff data to maintain ambiguous definitions" in {
      findOld(newAmbiguous2) must_== Some(oldAmbiguous2)
    }

    "successfully notice a refactor" in {
      findOld(newRefactored) must_== Some(oldRefactored)
    }

    "not refactor accross kinds" in {
      findOld(newPretending) must_== None
    }
  }
}


trait SymbolTestData {
  def symbol(name: String, line: Int, kind: String): Symbol = {
    new Symbol(0, "test", name, line, kind)
  }

  val oldStaysPut   = symbol("staysPut",     1, "v")
  val oldDeleted    = symbol("deleted",      2, "v")
  val oldMoves      = symbol("moves",        3, "m")
  val oldAmbiguous1 = symbol("ambiguous",    50, "a")
  val oldAmbiguous2 = symbol("ambiguous",    55, "a")
  val oldRefactored = symbol("oldName",      60, "r")
  val oldPretending = symbol("pretending",   80, "a")

  val newStaysPut   = symbol("staysPut",     1, "v")
  val newMoves      = symbol("moves",        2, "m")
  val newCreated    = symbol("created",      4, "c")
  val newAmbiguous1 = symbol("nonambiguous", 52, "a")
  val newAmbiguous2 = symbol("ambiguous",    56, "a")
  val newRefactored = symbol("newName",      70, "r")
  val newPretending = symbol("newVariable",  80, "b")


  val newSymbols = List(
    newStaysPut,
    newMoves,
    newCreated,
    newAmbiguous1,
    newAmbiguous2,
    newRefactored,
    newPretending
  )

  val oldSymbols = List(
    oldStaysPut,
    oldMoves,
    oldDeleted,
    oldAmbiguous1,
    oldAmbiguous2,
    oldRefactored,
    oldPretending
  )

  val newToOld = Map(
    1 -> 1,
    2 -> 3,
    52 -> 50,
    56 -> 55,
    70 -> 60,
    80 -> 80
  )

  def findOld(newSymbol: Symbol) = {
    Symbol.findOldSymbol(newSymbol, newSymbols, oldSymbols, newToOld)
  }
}

