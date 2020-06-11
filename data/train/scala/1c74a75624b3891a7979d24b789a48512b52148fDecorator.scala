package com.lei.designpatterns

/**
  * Created by Lei on 16/7/21.
  */


trait OutputStream {
  def write(msg: String)
}

class Printer extends OutputStream {
  override def write(msg: String): Unit = {
    println(msg)
  }
}

trait Buffer extends OutputStream {
  val cache = collection.mutable.ListBuffer[String]()

  abstract override def write(msg: String): Unit = {
    cache += msg + "end"
    if (cache.size >= 5) {
      cache.map(super.write(_))
      cache.clear()
    }
  }

}

trait Filter extends OutputStream {
  abstract override def write(msg: String): Unit = {
    super.write(msg.take(3))
  }

}


object Decorator {
  def main(args: Array[String]): Unit = {
    val out = new Printer() with Filter with Buffer
    out.write("11111")
    Thread.sleep(500)
    out.write("22222")
    Thread.sleep(500)
    out.write("33333")
    Thread.sleep(500)
    out.write("44444")
    Thread.sleep(500)
    out.write("55555")
    Thread.sleep(500)
    out.write("66666")
  }

}
