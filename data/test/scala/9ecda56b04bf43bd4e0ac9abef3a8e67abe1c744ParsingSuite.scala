package redis.interchange.hrd

import org.scalatest.FunSuite
import org.scalatest.junit.JUnitRunner
import org.junit.runner.RunWith
import collection.SortedSet

/**
 * Suite for testing various dump combinations.
 * @author <a href="mailto:roman.kashitsyn@gmail.com">Roman Kashitsyn</a>
 */

@RunWith(classOf[JUnitRunner])
class ParsingSuite extends FunSuite {

  test("Demo example works fine") {
    val parser = new HrdParser

    val result = parser.parseAll(parser.dump, TestData.DemoExample)

    println(result)

    result match {
      case parser.Success(_, _) => ()
      case parser.Error(msg, _) => fail(msg)
    }

    val dump = result.get

    assert(dump("list").isInstanceOf[List[Any]])
    assert(dump("set").isInstanceOf[Set[Any]])
    assert(dump("sortedSet").isInstanceOf[SortedSet[(Double, Any)]])
    assert(dump("hash").isInstanceOf[Map[Any, Any]])
    assert(dump("binary").isInstanceOf[Array[Byte]])
    assert(dump("key") == "value")
    assert(java.util.Arrays.equals(dump("binary").asInstanceOf[Array[Byte]], toAsciiBytes("hello")))
    assert(dump.expiration.get("exp1").isDefined)
    assert(dump.expiration.get("exp1").get.isInstanceOf[UnixTimestamp])
    assert(dump.expiration.get("exp2").isDefined)
    assert(dump.expiration.get("exp2").get.isInstanceOf[ExpirationTimeSpan])
  }

  test("Set elements with the same score are not replaced") {
    val sortedSet = readSortedSet(""" "zset": #{(1 "a") (1 "b")} """, "zset")
    assert(sortedSet.size == 2)
    assert(sortedSet.firstKey == (1, "a"))
    assert(sortedSet.lastKey == (1, "b"))
  }

  test("Set elements with the same score and value are not duplicated") {
    val sortedSet = readSortedSet(""" "zset": #{(1 "a") (1 "a")} """, "zset")
    assert(sortedSet.size == 1)
    assert(sortedSet.firstKey == (1, "a"))
  }

  test("Set elements with the same score but mixed content are not replaced") {
    val sortedSet = readSortedSet(""" "zset": #{(1 "a") (1 2)} """, "zset")
    assert(sortedSet.size == 2)
  }

  test("Comments are fully ignored") {
    val parser = new HrdParser
    val result = parser.parseAll(parser.dump, """
    -- Several comment
    -- lines
    "key" : "value"
    """)

    val dump = result.get

    assert(dump.values.size == 1)
    assert(dump("key") == "value")
  }

  private def readSortedSet(dump: String, key: String) = {
    val parser = new HrdParser
    val parsedDump = parser.parseAll(parser.dump, dump)
    val zset = parsedDump.get(key)
    assert(zset.isInstanceOf[SortedSet[(Double, Any)]])
    zset.asInstanceOf[SortedSet[(Double, Any)]]
  }
  private def toAsciiBytes(str: String): Array[Byte] = str.map(_.toByte).toArray

}
