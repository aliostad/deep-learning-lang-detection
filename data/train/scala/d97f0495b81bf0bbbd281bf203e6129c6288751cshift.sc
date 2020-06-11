def idValue(f: Int => Int, x: Int): Int = f(x)
type idType[A[_], B] = A[B]
idValue(x => x+ 1, 3)
import scala.util.continuations._
reset {
  shift { k: (Int=>Int) =>
    k(3)
  } + 1
}
def doStuff(x: => Unit): String = {
  "3"
}
def isTrue = {
  println(123)
  true
}
doStuff(while(true){})
case class A[T](t: T)
trait Dumper[T] {
  def dump(a: A[T], t: T): Unit
}
class B {
  def dump[T](a: A[T], t: T)(implicit dumper: Dumper[T]) = dumper.dump(a, t)
}
implicit val IntDummper = new Dumper[Int] {
  override def dump(a: A[Int], t: Int): Unit = {
    println("int dummper processing it")
  }
}

implicit val StringDummper = new Dumper[String] {
  override def dump(a: A[String], t: String): Unit = {
    println("string dummper processing it")
  }
}

val result = new B

result.dump(A("3"), "3") //string dummper processing it
result.dump(A(3), 3) //int dummper processing it

val dup = List(3,3,3,1,1,1,2,3,4,5,5,6,100,101,101,102)
dup.groupBy(identity).collect { case (x, List(_,_,_*)) => x }
//dup.groupBy(identity).collect { case (x, col) if col.lengthCompare(3) => x }
