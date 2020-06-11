/**
 * A Process represents a process in a PRS.
 * It is either the empty process, a constant process,
 * a sequential composition of processes via +: or
 * a parallel composition of processes via |:.
 *
 * When constructing a process via the factory methods
 * in the companion object or via methods from an
 * existing process, it is always guaranted that
 * a process is in normal form.
**/
sealed abstract class Process[A] {
  def head: Process[A]
  def tail: Process[A]
  
  def +:(p: Process[A]): Process[A] = (p, this) match {
    case (Empty(), _) => this
    case (_, Empty()) => p
    case (head +: tail, _) => new +:(head, tail +: this)
    case _ => new +:(p, this)
  }

  def |:(p: Process[A])(implicit ord: Ordering[Process[A]]): Process[A] = (p, this) match {
    case (Empty(), _) => this
    case (_, Empty()) => p
    case (head |: tail, _) =>
      new |:(head, tail |: this)
    case (_, head |: tail) => if (ord.compare(p, head) > 0)
      new |:(head, p |: tail) else new |:(p, this)
    case _ => if(ord.compare(p, this) > 0)
      new |:(this, p) else new |:(p, this)
  }
}

case class Empty[A]() extends Process[A] {
  override def toString = "ε"
  override def head = throw new UnsupportedOperationException("head of empty process")
  override def tail = throw new UnsupportedOperationException("tail of empty process")
}
case class Const[A](id: A) extends Process[A] {
  override def toString = id.toString
  override def head = this
  override def tail = Empty()
}
case class |:[A](override val head: Process[A], override val tail: Process[A]) extends Process[A] {
  override def toString = "(" + head.toString + "|" + tail.toString + ")"
}
case class +:[A](override val head: Process[A], override val tail: Process[A]) extends Process[A] {
  override def toString = "(" + head.toString + "." + tail.toString + ")"
}

class ProcessOrdering[A](ord: Ordering[A]) extends Ordering[Process[A]] {
  def compare(a: Process[A], b: Process[A]) = (a, b) match {
    case (Const(x), Const(y)) => ord.compare(x, y)
    case (head1 |: tail1, head2 |: tail2) =>
      val c = compare(head1, head2)
      if(c != 0) c else compare(tail1, tail2)
    case (head1 +: tail1, head2 +: tail2) =>
      val c = compare(head1, head2)
      if(c != 0) c else compare(tail1, tail2)
    case _ => a.getClass.toString.compare(b.getClass.toString)
  }
}

object Process {
  implicit def processOrdering[A](implicit ord: Ordering[A]): Ordering[Process[A]] =
    new ProcessOrdering(ord)

  def makeEmpty[A] = new Empty[A]()
  def makeConst[A](const: A) = Const(const)
  def makeParallel[A](children: List[Process[A]])(implicit ord: Ordering[A]): Process[A] =
  children match {
    case Nil => Empty()
    case head :: tail => head |: makeParallel(tail)
  }
  def makeSequential[A](children: List[Process[A]]): Process[A] =
  children match {
    case Nil => Empty()
    case head :: tail => head +: makeSequential(tail)
  }
}

