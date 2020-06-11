package edu.hku.cs.dft.debug

import edu.hku.cs.dft.DFTEnv
import edu.hku.cs.dft.network.DebugInformation
import edu.hku.cs.dft.tracker.{SelectiveTainter, TupleTainter}

/**
  * Created by jianyu on 4/13/17.
  */
object DebugTracer {

  private var threadLocalStorage: ThreadLocal[DebugStorage] = _

  def newStorage(stage: Int, partition: Int): DebugStorage = {
    threadLocalStorage = new ThreadLocal[DebugStorage]() {
      override def initialValue(): DebugStorage = new DebugStorage(stage, partition)
    }
    threadLocalStorage.get()
  }

  def getInstance(): DebugStorage = {
    if (threadLocalStorage == null) new DebugStorage(0, 0) else threadLocalStorage.get()
  }

  def trace[T, U](o: T, f: T => U): T = {
    val debugStorage = getInstance()
    debugStorage.push(o, f)
    o
  }

  def backTrace(): Any = {
    val traceObj = getInstance().pop()
    val traceTaint = TupleTainter.getTaint(traceObj)
    DFTEnv.localChecker.send(DebugInformation(traceObj._1, traceTaint, traceObj._2))
    // wait for the message to be sent
    Thread.sleep(1000)
    val dump = dumpObj(traceObj)
    s"Object $dump\n Taint $traceTaint"
  }

  def dumpObj[T](o: T): Any = {
    o match {
      case (_1, _2) => (dumpObj(_1), dumpObj(_2))
      case (_1, _2, _3) => (dumpObj(_1), dumpObj(_2), dumpObj(_3))
      case arr: Array[_] => arr.map(dumpObj).toList
      case it: Iterable[_] => "{iterable -> " + it.map(dumpObj).toList + "}"
      case it: Iterator[_] => "{iterator -> " + it.map(dumpObj).toList + "}"
      case Int|Long|Short|Float|Double|Boolean|Char|Byte => o
      case _: java.lang.Integer | _:java.lang.Long | _:java.lang.Short | _:java.lang.Float | _:java.lang.Double | _:java.lang.Boolean => o
      case _: java.lang.Character | _: java.lang.Byte | _: String => o
      case it: Object => dumpFields(it)
      case _ => o
    }
  }

  def dumpFields[T](o: T): Any = {
    val c = o.getClass
    val fields = c.getDeclaredFields
    val stringBuilder = new StringBuilder
    stringBuilder.append("{")
    for(f <- fields) {
      f.setAccessible(true)
      try {
        val value = f.get(o)
        val key = f.getName
        stringBuilder.append(s"field: $key -> value: $value,")
      } catch {
        case _: Exception =>
      }
    }
    stringBuilder.append("}")
    stringBuilder.toString()
  }

}
