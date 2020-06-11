import java.util.Comparator

package object demo {

  /**
    * Max of two objects. Old style. The two objects must implement Comparable interface.
    */
  def max_old[T <: Comparable[T]](x: T, y: T) = {
    if (x.compareTo(y) >= 0) x else y
  }


  /**
    * Max of two objects. Type classes style.
    * Any two objects can be compared as long as evidence (Comparator) is provided.
    */
  def max[T](x: T, y: T)(implicit ev: Comparator[T]) = {
    if (ev.compare(x, y) >= 0) x else y
  }

  /**
    * Only `compare` function can be passes as well.
    */
  def maxFunc[T](x: T, y: T)(implicit compare: (T, T) => Int) = {
    if (compare(x, y) >= 0) x else y
  }
}
