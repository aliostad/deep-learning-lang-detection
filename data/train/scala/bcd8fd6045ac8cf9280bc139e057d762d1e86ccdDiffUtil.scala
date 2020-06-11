package org.liquidizer.doc.lib

import scala.xml._
import scala.collection.mutable.PriorityQueue

case class DiffObject[T](val value : T)
case class Deleted[T](oldValue : T) extends DiffObject[T](oldValue)
case class Inserted[T](newValue : T) extends DiffObject[T](newValue)
case class Copied[T](keepValue : T) extends DiffObject[T](keepValue)

class DiffPath[T](val oldList : Seq[T], 
                  val newList : Seq[T],
		  val history : List[DiffObject[T]],
		  val weight : Double) extends Ordered[DiffPath[T]] {

  def isComplete() = oldList.isEmpty && newList.isEmpty

  def deletePath(weight : Double) =
    new DiffPath(oldList.tail, newList, Deleted(oldList.head)::history, weight)

  def insertPath(weight : Double) =
    new DiffPath(oldList, newList.tail, Inserted(newList.head)::history, weight)

  def copyPath() =
    new DiffPath(oldList.tail, newList.tail, Copied(oldList.head) :: history, weight)

  def successors() : Seq[DiffPath[T]] = {
    if (oldList.isEmpty) { Seq(insertPath(weight+ 2.0)) }
    else {
      if (newList.isEmpty) { Seq(deletePath(weight + 1.0)) }
      else {
	if (oldList.head == newList.head) {
	  Seq(copyPath())
	} else {
	  if (history.firstOption.exists { _.isInstanceOf[Deleted[T]] })
	    Seq(deletePath(weight + 1.0))
	  else
	    Seq(deletePath(weight + 1.0), insertPath(weight+ 1.0))
	}
      }
    }
  }

  def compare(other : DiffPath[T])= -weight.compare(other.weight)
  
  def dominates(other : DiffPath[T]) =
    newList.size <= other.newList.size &&
    oldList.size <= other.oldList.size
}

object DiffUtil {
  def diffPath[T](oldList : Seq[T], newList : Seq[T]) : DiffPath[T] = {
    var tried= List[DiffPath[T]]()
    var queue= new PriorityQueue[DiffPath[T]]
    queue += new DiffPath(oldList, newList, Nil, 0.0)
    while (!queue.head.isComplete) {
      val path= queue.dequeue
      val acc= queue.size / 10
      if (!tried.exists( _.dominates(path))) {
	tried = path :: tried.filter { path.dominates _ }
	for (succ <- path.successors)
          queue += succ
      }
    }
    queue.head
  }

  def diff[T](oldList : Seq[T], newList : Seq[T]) : List[DiffObject[T]] = {
	  diffPath(oldList, newList).history.reverse
  }
  
  def diffWeight[T](oldList : Seq[T], newList : Seq[T]) : Double = {
	  diffPath(oldList, newList).weight;
  }

  def invert[T](list : List[DiffObject[T]]) : List[DiffObject[T]] = {
    if (list.isEmpty) Nil
    else {
      val newHead = list.head match {
	case Inserted(value) => Deleted(value)
	case Deleted(value) => Inserted(value)
	case x => x
      } 
      newHead :: invert(list.tail)
    }
  }
}

object DiffRenderer {
  def renderDiff(content : List[DiffObject[String]]) : NodeSeq = {
    if (content.isEmpty) NodeSeq.Empty else {
      val head= content.takeWhile(_.getClass==content.head.getClass)
      val tail= content.drop(head.size)
      val body= Text(head.map( _.value ).mkString(" "," "," "))
      content.head match {
	case Copied(_) => Seq(body) ++ renderDiff(tail)
	case Deleted(_) => 
	  <span class="deleted">{body}</span> ++ renderDiff(tail)
	case Inserted(_) => 
          <span class="inserted">{body}</span> ++ renderDiff(tail)
      }
    }
  }

  def split(str : String) : Array[String]= 
    if (str.isEmpty) Array() else str.split("\\s+")

  def renderDiff(str1 : String, str2 : String) : NodeSeq = {
    val s1= split(str1)
    val s2= split(str2)
    renderDiff(DiffUtil.diff(s1,s2))
  }

  def renderDiff2(content : List[DiffObject[DiffObject[String]]]) : NodeSeq = {
    if (content.isEmpty) NodeSeq.Empty else {
      val head= content.takeWhile(_.getClass==content.head.getClass)
      val tail= content.drop(head.size)
      val body= head.map( _.value )
      val res : NodeSeq =content.head match {
	case Copied(_) => renderDiff(body)
	case Inserted(_) => <span class="quickdiff">{renderDiff(body)}</span>
	case _ => NodeSeq.Empty
      } 
      res ++ renderDiff2(tail)
    }
  }

  def renderDiff(str1 : String, str2a : String, str2b : String) : NodeSeq = {
    val s1= split(str1)
    val s2a= split(str2a)
    val s2b= split(str2b)
    val diff= DiffUtil.diff(DiffUtil.diff(s1,s2a), DiffUtil.diff(s1,s2b))
    renderDiff2(diff)
  }
}
