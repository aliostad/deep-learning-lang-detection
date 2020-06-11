package week1

/**
  * Created by rdsel on 15/9/2016.
  */
object test extends App {

  println("Hello World")

  val f: PartialFunction[String, String] = {
    case "ping" => "pong"
  }

  println(f("ping"))

  // How to manage with
  println(f.isDefinedAt("ping"))
  println(f.isDefinedAt("pong"))
  println(f.isDefinedAt("Something else?"))

  val g: PartialFunction[AnyVal, Unit] = {
    case num => println(num)
  }
  println(g.isDefinedAt(2))

  val example: PartialFunction[List[Int], String] = {
    case Nil => "one"
    case x :: y :: rest => "two"
  }
  println(example.isDefinedAt(List(1, 2, 3)))

  val example2: PartialFunction[List[Int], String] = {
    case Nil => "one"
    case x :: rest =>
      rest match {
        case Nil => "two"
      }
  }
  println(example2.isDefinedAt(List(1,2, 3)))


}

