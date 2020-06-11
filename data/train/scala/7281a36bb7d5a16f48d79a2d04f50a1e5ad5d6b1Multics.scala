package tests

import java.util.concurrent.atomic.{ AtomicReference => AtomR, AtomicLong }
import java.util.Random
import scala.collection.immutable.HashMap

object Multics {
  type MT = Map[String, Int]
  val info: AtomR[MT] = new AtomR(HashMap.empty)
  val clashCnt = new AtomicLong
  def main(argv: Array[String]) {
    runThread {
      repeatEvery(1000) {
        println("Clash Count: " + clashCnt + " Total: " +
          info.get.foldLeft(0)(_ + _._2))
      }
    }

    for (i <- 1 to 2000) runThread {
      var cnt = 0
      val ran = new Random
      val name = "K" + i
      doSet(info) { old => old + (name -> 0) }
      repeatEvery(ran.nextInt(100)) {
        doSet(info) { old => old + (name -> (old(name) + 1)) }
        cnt = cnt + 1
        if (cnt != info.get()(name))
          throw new Exception("Thread: " + name + " failed")
      }
    }
  }
  
  def runThread(f: => Unit) =
    (new Thread(new Runnable { def run(): Unit = f })).start

  def doSet[T](atom: AtomR[T])(update: T => T) {
    val old = atom.get
    if (atom.compareAndSet(old, update(old))) ()
    else {
      clashCnt.incrementAndGet
      doSet(atom)(update)
    }
  }
  
  def repeatEvery(len: => Int)(body: => Unit): Unit = {
    try {
      while (true) {
        Thread.sleep(len)
        body
      }
    } catch {
      case e => e.printStackTrace; System.exit(1)
    }
  }
}