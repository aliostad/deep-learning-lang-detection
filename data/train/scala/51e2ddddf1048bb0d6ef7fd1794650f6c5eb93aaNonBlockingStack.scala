package learningConcurrentProgramming

import java.util.concurrent.atomic.AtomicReference

/**
 * Created by Vlad on 20.04.2015.
 */
object NonBlockingStack {
}

class NonBlockingStack[T] {

  private val ref = new AtomicReference[Node[T]]

  def push(elem: T): Unit = {
    val oldHead = ref.get
    val newHead = new Node(elem, oldHead)
    if (!ref.compareAndSet(oldHead, newHead)) push(elem)
  }

  def pop(): T = {
    val currHead = ref.get
    if (currHead == null) null.asInstanceOf
    else {
      val next: Node[T] = currHead.next
      if (ref.compareAndSet(currHead, next)) next.elem
      else pop()
    }
  }

  class Node[U <: T](val elem: U, val next: Node[U])

}

