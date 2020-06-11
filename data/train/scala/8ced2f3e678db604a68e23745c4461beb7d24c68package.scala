package org.hammerlab.io

/**
 * Auto-generate [[cats.Show]] instances for case-classes and sealed traits (via [[shapeless.HList]]s and
 * [[shapeless.Coproduct]]s)
 */
package object show {

  import cats.syntax.all._
  import shapeless._
  import cats.Show.show

  // Shorter aliases for common default Show instances
  implicit val int = cats.implicits.catsStdShowForInt
  implicit val long = cats.implicits.catsStdShowForLong
  implicit val bool = cats.implicits.catsStdShowForBoolean
  implicit val string = cats.implicits.catsStdShowForString

  type Show[T] = cats.Show[T]

  implicit val showCNil: Show[CNil] = show { _ ⇒ "" }
  implicit def showCoproduct[H, T <: Coproduct](implicit
                                                head: Show[H],
                                                tail: Show[T]): Show[H :+: T] =
    show[H :+: T] {
      case Inl(h) ⇒
        h.show
      case Inr(t) ⇒
        t.show
    }

  implicit def showAsCoproduct[T, G <: Coproduct](implicit
                                                  generic: Generic.Aux[T, G],
                                                  showGeneric: Show[G]
                                                 ): Show[T] =
    show[T] {
      generic
        .to(_)
        .show
    }

  implicit val showHNil: Show[HNil] = show { _ ⇒ "" }
  implicit def showHList[H, T <: HList](implicit
                                        head: Show[H],
                                        tail: Show[T]): Show[H :: T] =
    show[H :: T] {
      case h :: HNil ⇒
        h.show
      case h :: t ⇒
        show"$h,$t"
    }

  implicit def showAsHList[T, G <: HList](implicit
                                          generic: Generic.Aux[T, G],
                                          showGeneric: Show[G]
                                         ): Show[T] =
    show {
      t ⇒
        val name =
          t.getClass.getSimpleName match {
            case "" ⇒ "anon"
            case name ⇒ name
          }

        generic.to(t) match {
          case _: HNil ⇒ name.show
          case hl ⇒ show"$name($hl)"
        }

    }
}
