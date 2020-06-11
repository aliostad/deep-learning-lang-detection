package itweek.v2

object Visitor extends App {

  trait E {
    def visit(h: H): Unit
  }

  case class E1(n: Int) extends E {
    def visit(h: H) = h.process(this)
  }

  case class E2(s: String) extends E {
    def visit(h: H) = h.process(this)
  }

  trait H {
    def process(list: List[E]): Unit =
      list.foreach(_.visit(this))

    def process(e: E1): Unit
    def process(e: E2): Unit
  }

  class H1 extends H {
    def process(e: E1) =
      println(s"${e.n} processed")

    def process(e: E2) =
      println(s"${e.s} processed")
  }

  val list = List(E1(1), E2("a"), E1(2), E2("b"))
  val h: H = new H1()
  h.process(list)

}
