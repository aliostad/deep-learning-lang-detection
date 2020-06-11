package typeclasses.homebrew

import shapeless._

/**
 * Created by eap on 7/31/14.
 */
object ShowInstances extends TypeClass[Show] {
  import Show._

  override def emptyProduct: Show[HNil] = Show { _ => "" }

  override def project[A, B](
    instance: Show[B],
    to: (A) => B,
    from: (B) => A): Show[A] =
    Show { a => instance.show(to(a)) }

  override def product[H, T <: HList](
    name: String,
    CH: Show[H],
    CT: Show[T]): Show[::[H, T]] =
    Show {
      case head :: tail =>
        val hs = CH.show(head)
        val ts = CT.show(tail)
        val end = if (ts.isEmpty) "" else s", $ts"
        s"$name: $hs$end"
    }

  override def emptyCoproduct: Show[CNil] =
    Show { _ => throw new Exception("Should never call instance for CNil") }

  override def coproduct[L, R <: Coproduct](
    name: String,
    CL: => Show[L],
    CR: => Show[R]): Show[:+:[L, R]] = Show {
    case Inl(left) => s"$name {${CL.show(left)}}"
    case Inr(right) => CR.show(right)
  }
}
