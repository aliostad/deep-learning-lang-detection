package ch3

import java.util.concurrent.atomic.AtomicReference

import scala.collection.mutable

import scala.concurrent._

/**
 * @author Got Hug
 */
class TreiberStack[T] {
  val stack = new AtomicReference[mutable.LinkedList[T]](mutable.LinkedList())

  def push(x: T): Unit = {
    val lOld = stack.get

    val lNew = lOld :+ x

    if (!stack.compareAndSet(lOld, lNew)) push(x)
  }

  def pop(): T = {
    val lOld = stack.get

    if (lOld.nonEmpty) {
      val el = lOld.last

      val lNew = lOld.init

      if (stack.compareAndSet(lOld, lNew)) el else pop()
    } else {
      throw new Exception("Pop on empty stack")
    }
  }
}

object TreiberStack extends App {
  val ts = new TreiberStack[Int]

  for (i <- 1 to 10) {
    val r = new Runnable {
      override def run(): Unit = {
        for (i <- 1 to 4) {
          println("Pushing..")
          ts.push(i)
        }
      }
    }

    ExecutionContext.global.execute(r)
  }

  Thread.sleep(4000)

  println(ts.stack.get.size)
  println(ts.stack.get)
  println(ts.stack.get.toList.sortWith(_ < _).groupBy(x => x).mapValues(_.size))
}