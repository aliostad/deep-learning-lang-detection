package com.dragade.svcc

/**
 * Simple example showing how a case class can be used to test different
 * cases and parse the object.
 */
object CaseClassExample {

  def makePerson(i: Int): Person = {
    if (i % 3 == 0) {
      Person("Foo", i)
    }
    else if (i % 2 == 0) {
      Person("Bar", 5)
    }
    else {
      Person("Baz", i)
    }
  }

  def makePeople() {
    for (i <- 1 to 10) {
      makePerson(i) match {
        case Person("Foo", x) => printf("Foo is %d years old.", x)
        case Person(s, x) if x == 5 => printf("Person %s is five years old.", s)
        case Person(s, x) => printf("Person %s is %d years old", s, x)
      }
      println()
    }
  }


}

case class Person(name: String, age: Int)
