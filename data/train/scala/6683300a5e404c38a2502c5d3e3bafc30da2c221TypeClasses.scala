package plda.prolog.typeclasses

/**
 * Haskell:
 *
 * Typeclass Show A where
 *  show:: A -> String
 *
 */

trait Show[T] {
  def show(t: T): String
}

trait JsonSerialization[T] {
  def toJson(t: T): String
}

trait Eq[T] {
  def ===(_this: T, that: T): Boolean
}

class Test {
  def iNeedAShow[T: Show](t: T): String = {
    val showClass = implicitly[Show[T]]
    showClass.show(t)
  }

  def iNeedAShowExplicit[T](t: T)(implicit showClass: Show[T]): String = {
    showClass.show(t)
  }

  def egal[T: Eq](t: T, y: T) = {
    val eqT = implicitly[Eq[T]]
    eqT === (t, y)
  }
}

case class Config(host: String, port: Int)

object Test {
  implicit val showInt = new Show[Int] {
    def show(i: Int) = i.toString().toUpperCase()
  }

  implicit val eqInt = new Eq[Int] {
    def ===(_this: Int, that: Int): Boolean = {
      _this == that
    }
  }
  
  implicit val configJson = new JsonSerialization[Config] {
    def toJson(c: Config): String = {
      s"""
        {
          host: "${c.host}",
          port: ${c.port}  
        }
      """
    }
  }
  
    implicit val configJson2 = new JsonSerialization[Config] {
    def toJson(c: Config): String = {
      s"""
        {
          host: "${c.host}",
          port: ${c.port}  
        }
      """
    }
  }
}

object Test2 {
  import Test._

  val test = new Test()
  test.egal(42, 42)

}