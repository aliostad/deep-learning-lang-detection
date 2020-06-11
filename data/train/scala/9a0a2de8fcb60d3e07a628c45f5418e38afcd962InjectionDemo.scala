package typeclasses.homebrew.demos

import typeclasses.homebrew.{ ShowInstances, Show }

/**
 * Created by eap on 8/1/14.
 */

sealed trait Inject
case class CaseA(n: Int) extends Inject
case class CaseB(s: String) extends Inject

object Inject {
  implicit def showA = Show[CaseA] {
    case CaseA(n) => s"-#!? Injected! $n ?!#-"
  }
}

object InjectionDemo {

  def main(args: Array[String]) {
    import Show._
    import shapeless._
    import ShowInstances.auto._
    {
      import Inject._
      println((CaseA(12): Inject).show)
      println(CaseA(19).show)
    }
    {
      println((CaseA(12): Inject).show)
      println(CaseA(19).show)
    }
  }
}
