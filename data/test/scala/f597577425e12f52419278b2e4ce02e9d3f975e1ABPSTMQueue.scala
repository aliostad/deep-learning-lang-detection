package dk.itu.wsq.queue.stm

import dk.itu.wsq.queue._

import scala.concurrent.stm._
import scala.concurrent.stm.skel.AtomicArray
import java.util.concurrent.atomic._

case class Tag(val value: Int) extends AnyVal

class ABPSTMQueue[E: Manifest](val size: Int) extends WorkStealingQueue[E] {
  private val tag: Ref[Tag] = Ref(Tag(0))
  private val top: Ref[Int] = Ref(0) 
  private var bottom: Int = 0
  private val queue: Ref[Array[E]] = Ref(new Array[E](size))

  final def push(v: E): Unit = {
    val localBot = bottom
    queue.single()(localBot) = v
    bottom = localBot + 1
  }

  final def take(): Option[E] = {
    val oldBottom = bottom

    if (oldBottom == 0) {
      None
    }
    else {
      val localBot = oldBottom - 1
      bottom = localBot

      val v = queue.single()(localBot)
 
      val oldTag = tag.single()
      val oldTop = top.single()
    
      if (localBot > oldTop) {
        Some(v)
      }
      else {
        bottom = 0
        val newTag = Tag(oldTag.value + 1)
        val newTop = 0    
        atomic { implicit txn => 
          if (localBot == oldTop) {
            if (tag() == oldTag && top() == oldTop) {
              tag() = newTag
              top() = newTop
              Some(v)
            }
            else {
              tag() = newTag
              top() = newTop
              None
            }
          }
          else {
            tag() = newTag
            top() = newTop
            None
          }
        }
      }
    }
  }

  final def steal(): Option[E] = {
    val oldTag = tag.single()
    val oldTop = top.single()

    val localBot = bottom

    if (localBot <= oldTop) {
      None
    }
    else {
      val v = queue.single()(oldTop)
      val newTag = oldTag
      val newTop = oldTop + 1
      atomic { implicit txn => 
        if (tag() == oldTag && top() == oldTop) {
          tag() = newTag
          top() = newTop
          Some(v)
        }
        else {
          None
        }
      }
    }
  }

  final def length = bottom - top.single()
}