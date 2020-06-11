package mot.dump

import org.scalatest.FunSuite
import mot.protocol.MessageTypes

class DumpFilterParserTest extends FunSuite {
 
  val p = new DumpFilterParser

  import Filters._
  import Side._
  import MessageTypes._
  
  test("test motdump expresion parser") {
    assert(!p.parseAll("whatever").successful)
    assertResult(Disj(Type(Heartbeat), Port(Any, 3000)))(p.parseAll("type heartbeat or port 3000").get)
    assertResult(Conj(Neg(Type(Heartbeat)), Port(Any, 3000)))(p.parseAll("not type heartbeat and port 3000").get)
  }
  
}