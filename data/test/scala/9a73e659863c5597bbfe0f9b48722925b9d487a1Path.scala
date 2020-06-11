package symplegades.core.path

import cats.Show

import scala.language.implicitConversions
import scala.language.postfixOps
import cats.data.NonEmptyList
import cats.syntax.show._
import cats.std.list._

sealed trait Path[+E] {
  def andThen[E2 >: E](e: E2): NonRootPath[E2]
}

case object RootPath extends Path[Nothing] {
  def andThen[E2](e: E2) = NonRootPath(NonEmptyList(e))

  implicit def show: Show[RootPath.type] = new Show[RootPath.type] {
    override def show(path: RootPath.type) = "<obj>"
  }
}

case class NonRootPath[E](path: NonEmptyList[E]) extends Path[E] {
  def andThen[E2 >: E](e: E2) = NonRootPath(NonEmptyList(path.head, path.tail :+ e))
  def lastElement: E = path.unwrap.last
  def removeLastElement: Path[E] = NonEmptyList.fromList(path.unwrap.reverse.tail.reverse).map { NonRootPath(_) } getOrElse Path.root[E]
}

object NonRootPath {
  implicit def show[E](implicit eShow: Show[E]): Show[NonRootPath[E]] = new Show[NonRootPath[E]] {
    override def show(path: NonRootPath[E]) = path.path.unwrap.map(_.show).mkString("/")
  }
}

object Path {
  def root[E](): Path[E] = RootPath.asInstanceOf[Path[E]]

  implicit def path[E](s: String)(implicit pe: PathAlg[E]) = NonRootPath(NonEmptyList(pe field s))

  implicit class PathExtensionSyntax[E: PathAlg](p: Path[E]) {
    def /(fieldName: String): NonRootPath[E] = p andThen implicitly[PathAlg[E]].field(fieldName)
  }

  implicit def show[E](implicit eShow: Show[E]): Show[Path[E]] = new Show[Path[E]] {
    override def show(path: Path[E]) = path match {
      case p: RootPath.type => RootPath.show.show(p)
      case p: NonRootPath[E] => p.show
    }
  }

}
