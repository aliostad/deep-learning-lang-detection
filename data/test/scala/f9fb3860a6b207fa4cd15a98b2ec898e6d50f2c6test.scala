import scala.language.experimental.macros

class A {
  val a = "A"
  val b = 10
  val c = 10.5
}

class C(val x: Int) {
  val i = 10
  val s = "Hello"
  val l = List(1, 3, 4)
  val l2 = List(List("1", "2"), List("3", "4"))
  val l3 = List(12.3, 15.4)
}
class D(val x: Int) {
  val c : C = new C(12);
  val y : Int = 11;
  val t : String = "Str";
  val l : List[Int] = List(10,23,55);
}

object Test extends App {
  def show[T](x: T)(implicit s: Showable[T]) = s.show(x)

  println("Int> " + show(10));
  println("Str> " + show("Test"));
  println("Double> " + show(1.5));
  // println("List> " + show(List(1,2,3,4)));
  // println("Array> " + show(Array("1","2","3","4")));

  // println("\n");
  // val a = new A;
  // println("Class A> " + show(a));

  // println("\n");
  // val c = new C(10);
  // println("Class C> " + show(c));

  // println("\n");
  // val d = new D(3);
  // println("Class D> " + show(d))
}
