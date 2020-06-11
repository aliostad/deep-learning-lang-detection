package com.ysoft.odc

import com.ysoft.odc.SetDiff.Selection


object SetDiff{
  sealed abstract class Selection
  object Selection{
    case object None extends Selection
    case object Both extends Selection
    case object Old extends Selection
    case object New extends Selection
  }
}

class SetDiff[T](val oldSet: Set[T], val newSet: Set[T]) {
  lazy val added = newSet -- oldSet
  lazy val removed = oldSet -- newSet
  lazy val isEmpty = newSet == oldSet
  def nonEmpty = !isEmpty

  def map[U](f: T => U): SetDiff[U] = new SetDiff[U](
    oldSet = oldSet.map(f),
    newSet = newSet.map(f)
  )

  private def setPair(oldSetBool: Boolean, newSetBool: Boolean) = (oldSetBool, newSetBool) match {
    case (false, false) => Selection.None
    case (false, true) => Selection.New
    case (true, false) => Selection.Old
    case (true, true) => Selection.Both
  }

  def whichNonEmpty = setPair(oldSet.nonEmpty, newSet.nonEmpty)

  def whichEmpty = setPair(oldSet.isEmpty, newSet.isEmpty)

}
