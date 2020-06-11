package irreg.std

import irreg._
import irreg.implicits._

import spire.std.BooleanIsRig

import scala.collection.{MapLike, SeqLike, SetLike}

object all {
  implicit val booleanHasKleene =
    new Kleene[Boolean] with BooleanIsRig {
      override def kstar(x: Boolean) = true
    }

  implicit val booleanHasShow: Show[Boolean] =
    Show.gen[Boolean](b => if (b) "t" else "f")

  implicit val charHasShow: Show[Char] =
    Show.gen[Char](_.toString)

  implicit val intHasShow: Show[Int] =
    Show.gen[Int](_.toString)

  implicit val doubleHasShow: Show[Double] =
    Show.gen[Double](_.toString)

  implicit val stringHasShow: Show[String] =
    Show.gen[String](s => s)

  implicit def optionHasShow[A: Show]: Show[Option[A]] =
    Show.gen[Option[A]](_.map(_.show).getOrElse("-"))

  implicit def tuple2HasShow[A: Show, B: Show]: Show[(A, B)] =
    Show.gen[(A, B)] { case (a, b) => s"(${a.show}, ${b.show})" }

  implicit def iterableHasShow[A: Show, CC[A] <: Iterable[A]]: Show[CC[A]] =
    Show.gen[CC[A]]((_: CC[A]).map((_: A).show).mkString("[", ", ", "]"))

  implicit def mapHasShow[A: Show, B: Show]: Show[Map[A, B]] =
    Show.gen[Map[A, B]](_.map { case (a, b) =>
      s"${a.show}→${b.show}"
    }.mkString("{", ", ", "}"))

  implicit def streamHasShow[A: Show]: Show[Stream[A]] =
    Show.gen[Stream[A]](s => if (s.isEmpty) "[]" else s"[${s.head.show}, ...]")
}
