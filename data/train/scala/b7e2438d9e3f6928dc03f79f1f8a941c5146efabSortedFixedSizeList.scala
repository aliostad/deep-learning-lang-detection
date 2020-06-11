package module1.hw1

import module1.hw1.Processor.IdCount

class SortedFixedSizeList(val size: Int) {
  private val elements = Array.ofDim[IdCount](size)

  def add(element: IdCount): Unit = {
    var break = false
    for (i <- 0 until size) {
      if (!break) {
        if (elements(i) == null || elements(i)._2 < element._2) {
          insert(i, element)
          break = true
        }
      }
    }
  }

  private def insert(index: Int, element: IdCount) = {
    var old = element
    for (i <- index until size) {
      val current = elements(i)
      elements(i) = old
      old = current
    }
  }

  def toList: List[IdCount] = {
    elements.filter(_ != null).toList
  }
}
