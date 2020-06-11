package container

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap
import scala.collection.mutable.ListBuffer
import org.scalatest.junit.JUnitRunner
import common.CommonTest
import org.junit.runner.RunWith
import org.scalatest.FunSuite
import java.io.File
import container.api.SkillState

@RunWith(classOf[JUnitRunner])
class FullTest extends FunSuite {

  @inline final def tmpFile(s: String) = {
    val r = File.createTempFile(s, ".sf")
    r.deleteOnExit
    r.toPath
  }

  @inline final def read(s: String) = {
    println(s)
    SkillState.read("src/test/resources/"+s)
  }
  @inline final def dump(state: SkillState) {
    for (t ← state.all) {
      println(s"Pool[${t.name}${
        if (t.superName.isDefined)
          " <: "+t.superName.get
        else
          ""
      }]")
      for (i ← t.all) {
        println(s"  $i = ${
          t.allFields.map {
            f ⇒ s"${f.name}: ${i.get(t, f)}"
          }.mkString("[", ", ", "]")
        }")
      }
      println()
    }
  }

  // reflective read
  test("read reflective: nodes") { dump(read("node.sf")) }
  test("read reflective: two node blocks") { dump(read("twoNodeBlocks.sf")) }
  test("read reflective: colored nodes") { dump(read("coloredNodes.sf")) }
  test("read reflective: four colored nodes") { dump(read("fourColoredNodes.sf")) }
  test("read reflective: empty blocks") { dump(read("emptyBlocks.sf")) }
  test("read reflective: two types") { dump(read("twoTypes.sf")) }
  test("read reflective: trivial type definition") { dump(read("trivialType.sf")) }
  test("read reflective: nullable restricted null pointer") { dump(read("nullableNode.sf")) }
  test("read reflective: null pointer in an annotation") { dump(read("nullAnnotation.sf")) }
  test("read reflective: subtypes") { dump(read("localBasePoolStartIndex.sf")) }
  test("read reflective: container") { dump(read("container.sf")) }
  test("read reflective: commutativity path 1") { dump(read("commutativityPath1.sf")) }
  test("read reflective: commutativity path 2") { dump(read("commutativityPath2.sf")) }

  // compound types
  //    test("create container instances") {
  //      val p = tmpFile("container.create")
  //  
  //      locally {
  //        val state = SkillState.create
  //        state.Container(
  //          Arr = ArrayBuffer(0, 0, 0),
  //          Varr = ArrayBuffer(1, 2, 3),
  //          L = ListBuffer(),
  //          S = Set().to,
  //          F = HashMap("f" -> HashMap(0L -> 0L)),
  //          SomeSet = Set().to
  //        )
  //        for (c ← state.Container.all)
  //          c.s = c.arr.toSet.to
  //  
  //        state.write(p)
  //      }
  //  
  //      locally {
  //        val state = SkillState.read(p)
  //        val c = state.Container.all.next
  //        assert(c.arr.size === 3)
  //        assert(c.varr.sameElements(1 to 3))
  //        assert(c.l.isEmpty)
  //        assert(c.s.sameElements(0 to 0))
  //        assert(c.f("f")(c.s.head) == 0)
  //      }
  //    }
}