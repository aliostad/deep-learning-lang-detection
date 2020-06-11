package util

trait Prioritizable[T] {
  def priority: Int
  def setPriority(newPriority: Int): T
  def increasePriority: T
  def decreasePriority: T
}

object Prioritizable {
  def rePrioritize[T <: Prioritizable[T]](prioritizable: T, amongst: Iterable[T], newPriority: Int): Iterable[T] = {
    val oldPriority = prioritizable.priority

    val part1: Iterable[T] = for (t <- amongst if (newPriority < oldPriority && t.priority < oldPriority && t.priority >= newPriority)) yield t.increasePriority
    val part2: Iterable[T] = for (t <- amongst if (newPriority > oldPriority && t.priority > oldPriority && t.priority <= newPriority)) yield t.decreasePriority
    List(prioritizable.setPriority(newPriority)) ++ part1 ++ part2
  }
}
