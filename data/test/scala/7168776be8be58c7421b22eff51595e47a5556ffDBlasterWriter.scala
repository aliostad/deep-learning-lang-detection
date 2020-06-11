package es.dblaster.io

import es.dblaster.events.EventHandler

trait WriteStrategy[T] {

  def write(sequence: Int, data: T, buckets: Array[T]): Unit
}

trait WriteEventHandler[T] extends EventHandler[T]{

  def onWrite(handler: logicHandler): Unit = registerHandler(handler,"write")
  def onWriteAvailable(handler: logicHandler): Unit = registerHandler(handler,"writeAvailable")

}

trait DBlasterWriter[T] extends WriteEventHandler[T] {

  var writeStrategy: WriteStrategy[T] = _

  var waitStrategy: WaitStrategy = _

  def write(data: T, args:Any*): Option[Int]

}