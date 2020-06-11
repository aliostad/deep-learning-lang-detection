package demo

import java.util.Comparator

import demo.Gender.Gender

case class Person_old(name: String, age: Int, gender: Gender) extends Comparable[Person_old] {
  override def compareTo(t: Person_old): Int = age.compareTo(t.age)
}

case class Person(name: String, age: Int, gender: Gender)

object Person {

  /**
    * Default [[Person]] comparator
    */
  implicit val personComp = new Comparator[Person] {
    override def compare(t: Person, t1: Person): Int = t.age.compareTo(t1.age)
  }

  /**
    * Default [[Person]] appender
    */
  implicit val personAppend = new CanAppend[Person] {
    override def append(x: Person, y: Person): Person =
      Person(s"${x.name} and ${y.name}", x.age + y.age,
        if (x.gender == y.gender) x.gender else Gender.???)
  }

}