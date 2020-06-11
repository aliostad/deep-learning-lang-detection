package net.ssanj.describe
package api

final case class PackageElement[T](mi: MemberInfo, elements: Seq[T])

object PackageElement {
  implicit def packageElementShow[T](implicit miShow: Show[MemberInfo], tShow: Show[T]):
    Show[PackageElement[T]] =
      Show.create[PackageElement[T]]{ p =>
        val elems = p.elements.map(e => s"\t${tShow.show(e)}").mkString(newLine)
        s"${miShow.show(p.mi)}:${newLine}${elems}"
      }

  implicit def packageElementOrdering[T] = contraOrdering[PackageElement[T], MemberInfo](_.mi)

  implicit val packageElementFunctor = new Functor[PackageElement] {
    def map[A, B](fa: PackageElement[A], f: A => B): PackageElement[B] =
      fa.copy(elements = fa.elements map f)
  }
}