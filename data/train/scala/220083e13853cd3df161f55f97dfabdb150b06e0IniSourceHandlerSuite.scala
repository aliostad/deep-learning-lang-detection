package ozer.handlers

import org.junit.runner.RunWith
import org.scalatest.FunSuite
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class IniSourceHandlerSuite extends FunSuite {
  test("adding same not allowed") {
    val oldSources = List("/src")

    val (newSources, warnings) = PureSourceHandler.add(
      oldSources,
      List("/src", "/src"),
      (x: String, y: String) => true,
      (x: String) =>  true)

    assert(newSources == oldSources)
    assert(warnings.size == 2)
  }

  test("adding invalid not allowed") {
    val oldSources = List("/src")

    val (newSources, warnings) = PureSourceHandler.add(
      oldSources,
      List("a", "b"),
      (x: String, y: String) => false,
      (x: String) =>  false)

    assert(newSources == oldSources)
    assert(warnings.size == 2)
  }

  test("add - correct case") {
    val oldSources = List("/src")

    val (newSources, warnings) = PureSourceHandler.add(
      oldSources,
      List("/src2", "/src3"),
      (x: String, y: String) => false,
      (x: String) =>  true)

    assert(newSources == List("/src3", "/src2", "/src"))
    assert(warnings.size == 0)
  }

  test("remove not existing not allowed") {
    val oldSources = List("src1") 
    val files = List("nope1", "nop2")

    val (newSources, warnings) = PureSourceHandler.remove(
      oldSources,
      files,
      (x: String, y: String) => false)

    assert(newSources == oldSources)
    assert(warnings.size == 2)
  }

  test("removing - correct case") {
    val oldSources = List("src1", "src2", "src3") 
    val files = List("src2", "src3")

    val (newSources, warnings) = PureSourceHandler.remove(
      oldSources,
      files,
      (x: String, y: String) => x == y)

    assert(newSources == List("src1"))
    assert(warnings.size == 0)
  }
}
