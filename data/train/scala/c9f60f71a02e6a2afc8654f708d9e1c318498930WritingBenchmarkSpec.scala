package io.circe.benchmarks

import argonaut.Parse, argonaut.Argonaut._
import org.scalatest.FlatSpec

class WritingBenchmarkSpec extends FlatSpec with VersionSpecificWritingSpec {
  val benchmark: WritingBenchmark = new WritingBenchmark

  import benchmark._

  def decodeInts(json: String): Option[List[Int]] =
    Parse.decodeOption[List[Int]](json)

  def decodeFoos(json: String): Option[Map[String, Foo]] =
    Parse.decodeOption[Map[String, Foo]](json)

  "The writing benchmark" should "correctly write integers using Circe" in {
    assert(decodeInts(writeIntsCirce) === Some(ints))
  }

  it should "correctly write integers using Argonaut" in {
    assert(decodeInts(writeIntsArgonaut) === Some(ints))
  }

  it should "correctly write integers using Spray JSON" in {
    assert(decodeInts(writeIntsSpray) === Some(ints))
  }

  it should "correctly write integers using Json4s" in {
    assert(decodeInts(writeIntsJson4s) === Some(ints))
  }

  // TODO: Figure out why this is failing.
  ignore should "correctly write integers using Jackson" in {
    assert(decodeFoos(writeIntsJackson) === Some(ints))
  }

  it should "correctly write case classes using Circe" in {
    assert(decodeFoos(writeFoosCirce) === Some(foos))
  }

  it should "correctly write case classes using Argonaut" in {
    assert(decodeFoos(writeFoosArgonaut) === Some(foos))
  }

  it should "correctly write case classes using Spray JSON" in {
    assert(decodeFoos(writeFoosSpray) === Some(foos))
  }

  it should "correctly write case classes using Json4s" in {
    assert(decodeFoos(writeFoosJson4s) === Some(foos))
  }

  it should "correctly write case classes using Jackson" in {
    assert(decodeFoos(writeFoosJackson) === Some(foos))
  }
}
