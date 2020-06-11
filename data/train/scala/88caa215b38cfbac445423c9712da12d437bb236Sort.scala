object Sorter {
  def sort[A](oldLst: List[A], order: Ordering[A]) (implicit manifest: Manifest[A]): List[A] = {
    sortOuter(oldLst, order) match {
      case elt :: lst => elt :: sort(lst, order)
      case Nil => Nil
    }
  }

  private[this] def sortInner[A](oldLst: List[A], order: Ordering[A]) (implicit manifest: Manifest[A]): List[A] = {
    oldLst match {
      case first :: second :: lst => {
        if (order.lteq(first, second)) {
          first :: second :: lst
        }
        else {
          second :: first :: lst
        }
      }
      case elt :: Nil => oldLst
      case Nil => Nil
    }
  }

  private[this] def sortOuter[A](oldLst: List[A], order: Ordering[A]) (implicit manifest: Manifest[A]): List[A] = {
    val tmp = oldLst match {
      case elt :: lst =>  elt :: sortOuter(lst, order)
      case Nil => Nil
    }
    sortInner(tmp, order)
  }
}
