package shapelesscats

import ShowInterpolation._

import scalaprops._
import cats._
import cats.syntax.show._
import cats.syntax.eq._
import cats.std.all._

object ShowInterpolationTest extends Scalaprops {
  final case class Foo(d: Double)

  implicit val showFoo: Show[Foo] = Show.show(foo =>
    s"custom message Foo(${foo.d})")

  implicit val genFoo: Gen[Foo] = Gen[Double].map(Foo.apply)

  implicit val genString: Gen[String] = Gen.asciiString

  val showInterpolates =
    Property.forAll { (i: Int, s: String, f: Foo) =>
      show"i is $i, s is $s, f is $f" ===
        s"i is ${i.show}, s is ${s.show}, f is ${f.show}"
    }
}
