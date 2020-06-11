package EDN

import java.util.UUID
import org.scalatest.FunSuite

class WriterTest extends FunSuite {

  test("int / double") {
    expectResult("1") { Writer.writeAll(1) }
    expectResult("42") { Writer.writeAll(42) }

    expectResult("1.0") { Writer.writeAll(1.0) }
    expectResult("42.0") { Writer.writeAll(42.0) }
  }

  test("set") {
    expectResult("#{}") { Writer.writeAll(Set()) }
    expectResult("#{1}") { Writer.writeAll(Set(1)) }
    expectResult("#{1.0 42.0}") { Writer.writeAll(Set(1, 42.0)) }
    expectResult("#{1 42.0 #{3}}") { Writer.writeAll(Set(1, 42.0, Set(3))) }
  }

  test("vector") {
    expectResult("[]") { Writer.writeAll(Vector()) }
    expectResult("[1]") { Writer.writeAll(Vector(1)) }
    expectResult("[1.0 42.0]") { Writer.writeAll(Vector(1, 42.0)) }
    expectResult("[1 42.0 #{3}]") { Writer.writeAll(Vector(1, 42.0, Set(3))) }
  }

  test("list") {
    expectResult("()") { Writer.writeAll(List()) }
    expectResult("(1)") { Writer.writeAll(List(1)) }
    expectResult("(1.0 42.0)") { Writer.writeAll(List(1, 42.0)) }
    expectResult("(1 42 #{3.0 [66]})") { Writer.writeAll(List(1, 42, Set(3.0, Vector(66)))) }
  }

  test("strings / keyword") {
    expectResult("\"a\"") { Writer.writeAll("a") }
    expectResult(":a") { Writer.writeAll(":a") }
    expectResult("[::foo/bar \"baz\"]") { Writer.writeAll(Vector("::foo/bar", "baz")) }
  }

  test("map") {
    expectResult("{}") { Writer.writeAll(Map()) }
    expectResult("{:a 1}") { Writer.writeAll(Map(":a" -> 1)) }
    expectResult("{{} {}}") { Writer.writeAll(Map(Map() -> Map())) }
    expectResult("{{} [1]}") { Writer.writeAll(Map(Map() -> Vector(1))) }
    expectResult("{{} [1] #{42.0} ()}") { Writer.writeAll(Map(Map() -> Vector(1), Set(42.0) -> List())) }
  }

  test("true / false / nil") {
    expectResult("true") { Writer.writeAll(true) }
    expectResult("false") { Writer.writeAll(false) }
    expectResult("(true false nil)") { Writer.writeAll(List(true, false, null)) }
  }

  test("#uuid") {
    val uuidStr = "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
    expectResult("#uuid \"" + uuidStr + "\"") { Writer.writeAll(UUID.fromString(uuidStr)) }
  }

  test("#inst") {
    val dateStr = "2012-01-01T01:23:45.000-00:00"
    expectResult("#inst \"" + dateStr + "\"") { Writer.writeAll(Instant.read(dateStr)) }
  }
}
