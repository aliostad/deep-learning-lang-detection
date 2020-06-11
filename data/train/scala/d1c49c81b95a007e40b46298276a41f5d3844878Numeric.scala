package algorithm

import collection.mutable.Seq

object Numeric {
  def Itoa[T](c: Seq[T], it: Itoa[T]) {
    for (i <- 0 until c.size) {
      c(i) = it()
      it++
    }
  }

  def Accumulate[T](c: Iterable[T], init: T, op: (T, T) => T)  = {
    (init /: c)(op)
  }

  def InnerProduct[T](a: Iterable[T], b: Iterable[T], op: (T, T) => T) = {
    for ((x, y) <- a.zip(b)) yield op(x, y)
  }

  def AdjacentOp[T](a: Iterable[T], op: (T, T) => T) = {
    var prev : Option[T] = None
    def adjacentOp(value: T) = {
      prev match {
        case Some(oldVal) => {
          prev = Some(value)
          op(oldVal, value)
        }
        case None => {
          prev = Some(value)
          value
        }
      }
    }
    a.map(adjacentOp)
  }

  def PartialReduce[T](a: Iterable[T], op: (T, T) => T) = {
    var prev : Option[T] = None
    def partialReduce(value: T) = {
      prev match {
        case Some(oldVal) => {
          prev = Some(op(oldVal, value))
        }
        case None => {
          prev = Some(value)
        }
      }
      prev.get
    }
    a.map(partialReduce)
  }
}
