object Sorter {
  def sort[A](oldArray: Array[A], order: Ordering[A]): Array[A] = {
    val arr = oldArray.clone
    for (i <- 0 until arr.length) {
      val index = argMin(arr, i, order)
      swap(arr, i, index)
    }
    arr
  }

  private[this] def argMin[A](arr: Array[A], start: Int, order: Ordering[A]): Int = {
    (start until arr.length) reduceRight {(x, y) =>
      if (order.lteq(arr(x), arr(y))) x else y
                                     }
  }

  private[this] def swap[A](arr: Array[A], first: Int, second: Int) {
    val tmp = arr(first)
    arr(first) = arr(second)
    arr(second) = tmp
  }
}
