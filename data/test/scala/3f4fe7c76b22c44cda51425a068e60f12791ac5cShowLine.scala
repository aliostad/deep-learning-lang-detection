package af.flat

/**
  * Created by me on 06/07/2016.
  */
trait ShowLine[T] {
  r =>
  def renders: List[(String, T => String)]

  def &(o: ShowLine[T]): ShowLine[T] = new ShowLine[T] {
    override def renders: List[(String, (T) => String)] =
      r.renders ++ o.renders
  }

  def contraMap[V](f: V => T): ShowLine[V] = new ShowLine[V] {
    override def renders: List[(String, (V) => String)] =
      r.renders.map { case (a, g) => a -> ((v: V) => g(f(v))) }
  }

  def prefix(s: String) = new ShowLine[T] {
    override def renders: List[(String, (T) => String)] =
      r.renders.map { case (x, y) => s"$s$x" -> y }
  }

  implicit class onSymbol(s: String) {
    def ~>[V](f: T => V)(implicit r: Show[V]): (String, T => String) =
      (s, t => r.apply(f(t)))
  }

}
