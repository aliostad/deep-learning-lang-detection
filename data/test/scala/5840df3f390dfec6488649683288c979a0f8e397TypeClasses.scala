package com.github.davidhoyt.playground.learn

//Ad-hoc polymorphism
object TypeClasses extends App {
  class SomethingElse(val x: String)

  class MyPolymorphicClass {
    def foo(x: String) = println(x)
    def foo(x: Int): Unit = foo(x.toString)
    def foo(x: SomethingElse): Unit = println(x.x)
  }

  new MyPolymorphicClass().foo(new SomethingElse("test"))

  trait Show[A] {
    def show(a: A): String
  }

  object Show {
    implicit val intShow = new Show[Int] {
      override def show(a: Int): String =
        "i" + a.toString
    }

    implicit val stringShow = new Show[String] {
      override def show(a: String): String =
        "s" + a
    }
  }

  class MyAdhocPolymorphicClass {
    def showIt[A](a: A)(implicit shows: Show[A]): Unit =
      println(shows.show(a))

    def showIt2[A : Show](a: A): Unit =
      println(implicitly[Show[A]].show(a))
  }

  new MyAdhocPolymorphicClass().showIt(0)
  new MyAdhocPolymorphicClass().showIt2("A")

}
