package scoute

import utest._
import utest.ExecutionContext.RunNow

import scala.scalajs.js

sealed trait Link
object NotFound extends Link
case class ConstDoubleConstInt(val double: Double)(val int: Int) extends Link
case class BoolStringConst(val bool: Boolean)(val string: String) extends Link

object TestRouter extends SPARouter[Link] {

  val constDoubleConstInt = "const0" /:: double /:: "const1" /:: int >> ConstDoubleConstInt.apply
  val boolStringConst = boolean /:: string /:: "const0" >> BoolStringConst.apply
  lazy val manageEvents = "organizer" /:: long /:: "events" /:: "manage" >> ((id: Long) => NotFound)

  def routes = js.Array[Route[Link]](constDoubleConstInt, boolStringConst)
}

object SPARouterTests extends TestSuite {
  import TestRouter._

  val tests = TestSuite {
    val constDoubleConstIntLink = "#const0/5.23/const1/5"
    val boolStringConstLink0 = "#1/bob/const0"
    val boolStringConstLink1 = "#0/bob2/const0"

    'link {
      assert(link(constDoubleConstInt)(5.23)(5) == constDoubleConstIntLink)
      assert(link(boolStringConst)(true)("bob") == boolStringConstLink0)
      assert(link(boolStringConst)(false)("bob2") == boolStringConstLink1)
      assert(link(manageEvents)(2) == "#organizer/2/events/manage")
    }
    'route {
      var res: Option[Link] = Some(ConstDoubleConstInt(5.23)(5))
      assert(TestRouter.route(constDoubleConstIntLink) == res)

      res = Some(BoolStringConst(true)("bob"))
      assert(TestRouter.route(boolStringConstLink0) == res)

      res = Some(BoolStringConst(false)("bob2"))
      assert(TestRouter.route(boolStringConstLink1) == res)
    }
    'notRoute {
      assert(TestRouter.route("#true/bob/const0") == None)

      assert(TestRouter.route("#0/bob/const") == None)
      assert(TestRouter.route("#0//const0") == None)
    }
  }
}