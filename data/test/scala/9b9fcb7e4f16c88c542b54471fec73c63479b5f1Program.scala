package demos.scala.matching.types

class MyClass(val value : Int) {}

object Program {
  def main(args : Array[String]) {
       process(123)
       process(4.56)
       process(7.89)
       process("Foobar")
       process(new MyClass(101))
       process(true)
     }

  def process(something : Any) {
    something match {
         case i : Int => println("Received the integer: " + i)
         case s : String => println("Received the string: " + s)
         case d : Double if(d <= 6) => println("Received a small double: " + d)
         case d : Double if(d > 6) => println("Received a big double: " + d)
         case mc : MyClass => println("Received a MyClass object holding: " + mc.value)
         case _ => println("Received an unknown value")
       }
    }
}
