package builder

import com.google.common.base.Function
import core.ProcessF
import scala.util.{Failure, Success, Try}
import conversion.ConverterUtils._

class StreamOperationBuilder[T] {

  def drop(x: Int): ProcessF[T] = { process =>
    process.drop(x)
  }

  def take(x: Int): ProcessF[T] = { process =>
    process.take(x)
  }

  def takeWhile(f: Function[T, Boolean]): ProcessF[T] = takeWhileF(f)

  def takeWhileF(f: T => Boolean): ProcessF[T] = { process =>
    process.takeWhile(t => {
      t._1 match {
        case Success(w) => f(w)
        case Failure(_) => false
      }
    })
  }

}
