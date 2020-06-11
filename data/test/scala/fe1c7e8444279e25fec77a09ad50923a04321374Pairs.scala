object Pairs {
  def middle[T](iterable: Iterable[T]) : T = {
    val central = if (iterable.size%2 == 0) (iterable.size/2) -1 else (iterable.size-1)/2
    iterable.drop(central).head
  }

  def swap[A, B](in : ImmutablePair[A, B]) = new ImmutablePair(in.second, in.first)
}

class ImmutablePair[T, S] (val first: T, val second: S ) {
  def swap: ImmutablePair[S, T] = new ImmutablePair(second, first)
}

class MutablePair[T] (var first: T, var second: T) {
  def swap() {
    val oldFirst = first
    first = second
    second = oldFirst
  }
}

class ChalkAndCheese[T,S] (var first: T, var second: S) {
  def swap()(implicit ev1: T =:= S, ev2: S =:= T) {
    val oldFirst = first
    first = second
    second = oldFirst
  }
}