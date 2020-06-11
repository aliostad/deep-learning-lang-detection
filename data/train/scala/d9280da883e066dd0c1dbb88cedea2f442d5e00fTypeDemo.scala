
/**
 * Demonstrate a Show type-class.
 * Per wikipedia "a type class is a type system construct that supports ad hoc polymorphism".
 */
object TypeClassDemo {

    case class Person(name: String, age: Int)

    object Person {
        implicit val show : Show[Person] = new Show[Person] {
            override def show(t: Person): String = t.name + " has " + t.age
        }
    }

    def sayHey[T](t : T)(implicit show : Show[T]): Unit = {
        println(show.show(t))
    }

    // using a context bound reduce the boilerplate
    def sayHeyWithContextBound[T : Show](t : T): Unit = {
        sayHey(t)
    }

    def main(args: Array[String]) {
        sayHey(123)
        sayHey("hello!")
        sayHey(Person("toto", 12))
        sayHeyWithContextBound(Person("tata", 21))
    }
}
