trait Showable[T] {
  def show(value: T): String
}

object ImplicitsDecimal {
  implicit object IntShowable extends Showable[Int] {
    def show(value: Int) = Integer.toString(value)
  }
}

object ImplicitsHexadecimal {
  implicit object IntShowable extends Showable[Int] {
    def show(value: Int) = Integer.toString(value, 16)
  }
}

def showValue[T: Showable](value: T) = implicitly[Showable[T]].show(value)
// Or, equivalently:
// def showValue[T](value: T)(implicit showable: Showable[T]) = showable.show(value)

// Usage
{
  import ImplicitsDecimal._
  println(showValue(10))  // Prints "10"
}
{
  import ImplicitsHexadecimal._
  println(showValue(10))  // Prints "a"
}