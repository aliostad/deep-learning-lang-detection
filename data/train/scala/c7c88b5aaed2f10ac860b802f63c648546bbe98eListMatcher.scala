package com.chromy.reactiveui

import scala.annotation.tailrec

/**
 * Created by chrogab on 2015.06.17..
 */
class ListMatcher {

}

trait ListOperation[A]

case class Removed[A](index: Int, item: A) extends ListOperation[A]
case class Added[A](index: Int, item: A) extends ListOperation[A]

object ListMatcher {
  def diff1[A](oldList: Seq[A], newList: Seq[A]): Seq[ListOperation[A]] = {
    diff[A,A](oldList, newList){elem: A => elem}
  }

  def diff[A,B](ol: Seq[A], nl: Seq[A])(getId: A => B): Seq[ListOperation[A]] = {

    val (_, oldAssoc, oldList) = ol.foldLeft((0, Map[B, (A, Int)](), List[B]())) { case ((index, mapAccu, listAccu), a) =>
      (index + 1,  mapAccu.updated(getId(a), (a, index)), getId(a) :: listAccu)
    }

    val (_, newAssoc, newList) = nl.foldLeft((0, Map[B, (A, Int)](), List[B]())) { case ((index, mapAccu, listAccu), a) =>
      (index + 1,  mapAccu.updated(getId(a), (a, index)), getId(a) :: listAccu)
    }

    @tailrec
    def traverse(oldTail: List[B], oldMap: Map[B, (A, Int)], newMap: Map[B, (A, Int)]): (Map[B, (A, Int)], Map[B, (A, Int)]) = {
      oldTail match {
        case Nil => (oldMap, newMap)
        case h :: tail if(newMap.get(h).isDefined) =>
          traverse(tail, oldMap - h, newMap - h)
        case h :: tail if(newMap.get(h).isEmpty) =>
          traverse(tail, oldMap, newMap)
        case _ => (oldMap, newMap)
      }
    }

    val r = traverse(oldList, oldAssoc, newAssoc)

    val r2 = r._1.map { case(elem, (originalElement, index)) => Removed(index, originalElement)}
    val r3 = r._2.map { case(elem, (originalElement, index)) => Added(index, originalElement)}
    (r2 ++ r3).toList
  }
}
