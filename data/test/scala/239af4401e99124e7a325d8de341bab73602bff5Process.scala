package stream

/**
  * Process
  * Author: zhe.jiang
  * Desc:
  * Change log:
  * 2016/10/15 - created by zhe.jiang
  */
sealed trait Process[I, O] {

  def apply(s: Stream[I]): Stream[O] = this match {
    case Halt() => Stream()
    case Await(recv) => s match {
      case h #:: t => recv(Some(h))(t)
      case xs => recv(None)(xs)
    }
    case Emit(h, t) => h #:: t(s)
  }

  def repeat: Process[I, O] = {
    def go(p: Process[I, O]): Process[I, O] = p match {
      case Halt() => go(this)
      case Await(recv) => Await {
        case None => recv(None)
        case i => go(recv(i))
      }
      case Emit(h, t) => Emit(h, go(t))
    }
    go(this)
  }

  def |>[O2](p2: Process[O, O2]): Process[I, O2] = this match {
    case Halt() => Halt()
    case Await(r) => Await {
      i =>
        val result = r(i)
        result match {
        case Halt() => Halt()
        case Await(r1) => result |> p2
        case e: Emit[I, O] => processEmit(e, p2)
      }
    }
    case e: Emit[I, O] => processEmit(e, p2)
  }

  def processEmit[O2](e: Emit[I, O], p2: Process[O, O2]): Process[I, O2] =
    p2 match {
      case Halt() => Halt()
      case Await(r2) =>
        val result3 = r2(Some(e.head))
        result3 match {
          case Halt() => Halt()
          case Await(_) => processEmit(e, result3)
          case Emit(h3, t3) => Emit(h3, e.tail |> p2)
        }
      case Emit(h2, t2) =>
        Emit(h2, e.tail |> p2)
    }


//    Await{
//      i => p2 match {
//        case Halt() => Halt()
//        case Await(r2) =>
//          val result3 = r2(Some(e.head))
//          result3 match {
//            case Halt() => Halt()
//            case Await(r3) => processEmit(e, result3)
//            case Emit(h3, t3) => processEmit(e, result3)
//          }
//        case Emit(h2, t2) =>
//          Emit(h2, processEmit(e, t2))
//      }
//    }

  def map[O2](f: O => O2): Process[I, O2] = this |> Process.lift(f)
}

case class Emit[I, O](head: O, tail: Process[I, O] = Halt[I, O]()) extends Process[I, O]

case class Await[I, O](recv: Option[I] => Process[I, O]) extends Process[I, O]

case class Halt[I, O]() extends Process[I, O]

object Process {
  def liftOne[I, O](f: I => O): Process[I, O] =
    Await {
      case Some(i) => Emit[I, O](f(i))
      case None => Halt()
    }

  def none[I, O]: Process[I, O] = Halt[I, O]()

  def lift[I, O](f: I => O): Process[I, O] = liftOne(f).repeat

  def filter[I](p: I => Boolean): Process[I, I] = Await[I, I] {
    case Some(i) if p(i) => Emit[I, I](i)
    case _ => Halt()
  }.repeat

  def sum: Process[Double, Double] = {
    def go(acc: Double): Process[Double, Double] = Await {
      case Some(d) => Emit(d + acc, go(d + acc))
      case None => Halt()
    }
    go(0.0)
  }

  def take[I](n: Int): Process[I, I] =
    if (n == 0) Halt()
    else Await {
      case Some(i) => Emit(i, take(n - 1))
      case None => Halt()
    }

  def alwaysTake[I]: Process[I, I] = Await[I, I] {
    case Some(i) => Emit(i, alwaysTake[I])
    case None => Halt()
  }


  def drop[I](n: Int): Process[I, I] = Await[I, I] {
    case None => Halt()
    case Some(i) =>
      if (n > 0) drop(n - 1)
      else Emit(i, alwaysTake[I])
  }.repeat

  def takeWhile[I](f: I => Boolean): Process[I, I] = Await[I, I] {
    case Some(i) if f(i) => Emit(i, takeWhile(f))
    case _ => Halt()
  }

  def dropWhile[I](f: I => Boolean): Process[I, I] = Await[I, I] {
    case Some(i) if f(i) => dropWhile(f)
    case _ => alwaysTake[I]
  }

  def count[I]: Process[I, Int] = {
    def count0(n: Int): Process[I, Int] = Await[I, Int] {
      case Some(_) => Emit(n + 1, count0(n + 1))
      case None => Halt()
    }
    count0(0)
  }

  def mean: Process[Double, Double] = {
    def mean0(state: (Int, Double)): Process[Double, Double] = Await[Double, Double] {
      case Some(d) =>
        val (c, s) = state
        val c1 = c + 1
        val s1 = s + d
        Emit(s1 / c1, mean0 (c1, s1))
      case None => Halt()
    }
    mean0 (0, 0.0)
  }

  def loop[S, I, O](z: S)(f: (I, S) => (O, S)): Process[I, O] = Await[I, O] {
    case Some(i) => f(i, z) match {
      case (o, s2) => Emit(o, loop(s2)(f))
    }
    case None => Halt()
  }

  def countX[I]: Process[I, Int] = loop(0)((i, s) => (s + 1, s + 1))

  def sumX: Process[Double, Double] = loop(0.0)((i, s) => (s + i, s + i))
}

object Run {
  def main(args: Array[String]): Unit = {
//    val p = Process.liftOne((x: Int) => x)
//    val p = Process.none[Int, Int]
//    val p = Process.filter((x: Int) => x % 2 == 0)
//    val p = Process.sum
//    val p = Process.take[Int](2)
//    val p = Process.drop[Int](2)
//    val p = Process.takeWhile[Int](_ < 4)
//    val p = Process.dropWhile[Int](_ < 4)
//    val p = Process.count[Int]
//    val p = Process.sumX
    val p = Process.sum.map(_ * 2)
    val xs = p(Stream(1,2,3,4,5)).toList
    println(xs)
  }

}