package com.immediatus

object dependentTypeClasses {
  trait Show[T] extends (T => String)

  class CB[T : Show](val x : T) {
    def get = implicitly[Show[T]] apply x
  }

  trait Functor[F[_], Bound[_]] {
    def map[A : Bound, B : Bound](fa : F[A])(f : A => B): F[B]
  }

  abstract class FunctorSyntax[F[_], Bound[_], A : Bound] {
    val self: F[A]
    def map[B : Bound](f : A => B)(implicit F : Functor[F, Bound]): F[B] = F.map(self)(f)
  }

  implicit val showInt = new Show[Int] {
    def apply(x: Int) = s"Int: $x"
  }

  implicit val showDouble = new Show[Double] {
    def apply(x: Double) = s"Double: $x"
  }

  implicit val showLong = new Show[Long] {
    def apply(x: Long) = s"Long: $x"
  }

  implicit val cfFunctor = new Functor[CB, Show] {
    def map[A : Show, B : Show](fa : CB[A])(f : A => B): CB[B] = {
      new CB[B](f(fa.x))
    }
  }

  implicit def functorSyntax[F[_], A : Show](cb: F[A]) = new FunctorSyntax[F, Show, A] {
    val self = cb
  }

  val f = (_: Int) * 2.25
  val g = math.round(_: Double)

  val a = new CB(5)

  val F1 = a.map(f).map(g)
  val F2 = a.map(f andThen g)

  println(s"a(${a.get}) , F1(${F1.get})")
}
