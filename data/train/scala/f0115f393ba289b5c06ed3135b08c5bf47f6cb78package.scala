package play.api.libs.context

import org.scalactic.{Every, Many, One}
import play.api.libs.context.functional.Show

package object show extends ShowDefaults

trait ShowDefaults {

  implicit def showOne[T](implicit s: Show[T]): Show[One[T]] = Show.show(one => s"One(${one.loneElement})")

  implicit def showMany[T](implicit s: Show[T]): Show[Many[T]] = {
    Show.show(every => every.map(s.show).mkString("Many(", ", ", ")"))
  }

  implicit def showEvery[T](implicit s: Show[T]): Show[Every[T]] = {
    Show.show {
      case one: One[T]   => showOne(s).show(one)
      case many: Many[T] => showMany(s).show(many)
    }
  }
}
