package io.uarun.experiments.typelevel.scalaz.show

object ShowUsage {
  import scalaz.Show
  import scalaz.std.anyVal._
  import scalaz.std.string._

  def main(args: Array[String]): Unit = {
    val intShow = Show.apply[Int]
    println(intShow.shows(1))

    val strShow = Show.apply[String]
    println(strShow.shows("Me"))

    import scalaz.std.tuple._
    import scalaz.syntax.show._

    println("Test".show)
    println(100.show)
    println((1, 2).show)

    import scalaz.std.list._
    println(List(1, 2).show)

    import scalaz.std.map._
    println(Map("1" → 1, "Two" → 2).show)
  }
}
