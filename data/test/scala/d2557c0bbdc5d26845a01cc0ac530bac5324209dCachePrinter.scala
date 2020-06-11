package com.lei.thread

import scala.collection.mutable.ListBuffer

/**
  * Created by com.lei on 16-3-17.
  */
object CachePrinterTest {
  def main(args: Array[String]) {
    val printer = new CachePrinter[String]
    Thread.sleep(1000)
    printer.write("1")
    printer.write("2")
    printer.write("3")
    printer.write("4")
    printer.write("5")
    printer.write("6")
    printer.write("7")
    printer.write("8")
    printer.write("9")
    printer.write("10")

  }

}

class CachePrinter[T](private val size: Int = 5, private val flushInterval: Long = 10000) {
  val cache = ListBuffer[T]()

  val schedulerWriteThread = new Runnable {
    override def run(): Unit = {
      while (true) {
        cache synchronized {
          doWrite()
        }
        Thread.sleep(flushInterval)
      }
    }
  }

  new Thread(schedulerWriteThread).start()

  def write(t: T): Unit = {
    // 在cache上进行同步
    cache synchronized {
      if (cache.length < size) {
        cache += t
      } else {
        cache += t
        doWrite()
      }
    }

  }

  private def doWrite(): Unit = {
    cache foreach println
    cache clear
  }


}
