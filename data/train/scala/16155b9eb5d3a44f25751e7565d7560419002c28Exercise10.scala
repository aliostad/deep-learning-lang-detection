package chapter17


object Exercise10 {
  
  def main(args: Array[String]): Unit = {  
    class Person(val in: Int) {
      override def toString = "Person: " + in
    }
    class Student(in: Int) extends Person(in) {
      override def toString = "Student: " + in
    }
    
    class Pair[S, T] (var first: S, var second: T) {
      def swap()(implicit ev: T =:= S) = {
        val firstOld: S = first
        first = second
        second = firstOld.asInstanceOf[T]
        this
      }
      override def toString() = first + " " + second
    }
    
    val pairInt = new Pair(3,5)
    val pairIntString = new Pair(4, "Hallo")
    
    println(pairInt.swap)
    println(pairInt)

 // Ok, the following is not allowed: type mismatch;  found   : firstOld.type (with underlying type S)  required: T	
 // println(pairIntString.swap)
    println(pairIntString)
  }  
  
}