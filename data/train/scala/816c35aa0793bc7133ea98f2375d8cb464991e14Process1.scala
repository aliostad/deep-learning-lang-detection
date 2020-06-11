package streamingio15

/**
  * Stream Transducer
  * 한 스트림을 다른 스트림을 변환하는 작업을 서술
  */
sealed trait Process[I, O] {
  /**
    * Stream을 변환하는 구동기
    */
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
        case Await(recv) => Await { // recv를 재귀 형태로 바꿈
          case None => recv(None)
          case s => go(recv(s))
        }
        case Emit(h, t) => Emit(h, go(t))
    }

    go(this)
  }

  /**
    * 연습문제 15.5
    */
  def |>[O2](p2: Process[O, O2]): Process[I, O2] = ???

  def map[O2](f: O => O2): Process[I, O2] = this |> Process.lift(f)

  def ++(p: Process[I, O]): Process[I, O] = this match {
    case Halt() => p
    case Await(recv) => Await(recv andThen (_ ++ p))
    case Emit(h, t) => Emit(h, t ++ p)
  }

  def flatMap[O2](f: O => Process[I, O2]): Process[I, O2] = this match {
    case Halt() => Halt()
    case Await(recv) => Await(recv andThen (_ flatMap f))
    case Emit(h, t) => f(h) ++ t.flatMap(f)
  }
}

/* head를 출력 스트림에 방출, tail 상태로 전이 */
case class Emit[I, O](head: O, tail: Process[I, O] = Halt[I, O]()) extends Process[I, O]
/* 입력 스트림에서 값 하나를 요청, 읽을 요소가 없으면 None */
case class Await[I, O](recv: Option[I] => Process[I, O]) extends Process[I, O]
/* 입력 또는 출력을 멈춤 */
case class Halt[I, O]() extends Process[I, O]

object Process {

  /**
    * A helper function to await an element or fall back to another process
    * if there is no input.
    */
  def await[I,O](f: I => Process[I,O],
                 fallback: Process[I,O] = Halt[I,O]()): Process[I,O] =
    Await[I,O] {
      case Some(i) => f(i)
      case None => fallback
    }

  def liftOne[I, O](f: I => O): Process[I, O] = Await {
    // opt => opt match { 을 생략한 형태.
    case Some(i) => Emit(f(i))
    case None => Halt()
  }

  def lift[I, O](f: I => O): Process[I, O] = liftOne(f).repeat

  def filter[I](p: I => Boolean): Process[I, I] = Await[I, I] {
    case Some(i) if p(i) => Emit[I, I](i)
    case _ => Halt()
  }.repeat

  def sum: Process[Double, Double] = {
    def go(acc: Double): Process[Double, Double] = Await {
      case Some(d) => Emit(d + acc, go(d + acc))
      case _ => Halt()
    }

    go(0.0)
  }

  /**
    * 연습문제 15.4
    */
  def sum2: Process[Double, Double] = loop(0.0)((d, acc) => (d + acc, d + acc))

  def loop[S, I, O](z: S)(f: (I, S) => (O, S)): Process[I, O] = Await {
    (opt: Option[I]) => opt match {
      case Some(i) => f(i, z) match {
        case (o, s2) => Emit(o, loop(s2)(f))
      }
      case _ => Halt()
    }
  }
  // await helper를 사용했을 때
  //  await((i: I) => f(i, z) match {
  //    case (o, s2) => Emit(o, loop(s2)(f))
  //  })
}