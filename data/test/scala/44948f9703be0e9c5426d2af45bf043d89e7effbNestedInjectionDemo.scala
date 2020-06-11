package typeclasses.homebrew.demos

import typeclasses.homebrew.{ ShowInstances, Show }

/**
 * Created by eap on 8/6/14.
 */

sealed trait CRA
case class BA(s: String) extends CRA
case class RA(n: Int, b: CRB) extends CRA

sealed trait CRB
case class BB(n: Int) extends CRB
case class RB(d: Double, c: CRC) extends CRB

sealed trait CRC
case class BC(s: String) extends CRC
case class RC(s: String, a: CRA) extends CRC

object NestedInjectionDemo {
  def main(args: Array[String]) {
    import Show._
    import shapeless._
    import ShowInstances.auto._

    implicit def injectedShowRecB(implicit showCRC: Lazy[Show[CRC]]): Show[RB] = Show {
      case RB(d, c) => s"Injected! $d, ${showCRC.value.show(c)}"
    }

    println((RA(1, RB(3.14, BC("hi"))): CRA).show)
  }
}
