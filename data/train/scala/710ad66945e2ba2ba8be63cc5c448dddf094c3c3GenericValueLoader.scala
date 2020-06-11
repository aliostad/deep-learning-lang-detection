package org.nephtys.genericvalueloader

import java.util.NoSuchElementException

import scala.util.Try

/**
  * Created by nephtys on 9/27/16.
  */
case class GenericValueLoader[T](
                                  filename : () => String,
                                  timeout : Option[() => Long],
                                  serialize : T => String,
                                  deseralize : String => T,
                                  defaultFunc : Option[() => T],
                                  additionalCompare : (T, T) => Boolean
                                ) extends GenericGetter[T] with GenericSetter[T] {
  override def getValue(): T = {
    valueLastLoad.synchronized(
    if (isCached) {
      getCacheValue
    } else {
      val t : T = loadFromFile.getOrElse({
          defaultFunc.getOrElse(throw new NoSuchElementException()).apply()
      })
      if (valueLastLoad.isEmpty || !additionalCompare.apply(valueLastLoad.get, t)) {
        setCacheValue(t)
        t
      } else {
        setCacheValue(valueLastLoad.get)
        valueLastLoad.get
      }


    }
    )
  }

  private def isCached : Boolean = {
    val b =
      valueLastLoad.isDefined && timeout.forall(ti => timestampLastLoad + ti.apply() >
        System.currentTimeMillis())

    /*println(s"Cached at $timestampLastLoad and now is ${System.currentTimeMillis()}, value is $valueLastLoad, " +
    s"result " +
      s"of isCached = $b")*/
    b
  }

  private var timestampLastLoad : Long = 0
  private var valueLastLoad : Option[T] = None

  private def getCacheValue : T = valueLastLoad.get
  private def setCacheValue(t : T) = {
    val timestamp = System.currentTimeMillis()
    timestampLastLoad = timestamp
    valueLastLoad = Some(t)
  }
  private def loadFromFile : Option[T] = Try(deseralize.apply(GenericSetter.loadFromFile(filename.apply()))).toOption

  override def setValue(t: T): Unit = valueLastLoad.synchronized(
    {
      GenericSetter.saveToFile(filename.apply(),serialize.apply(t))
      timestampLastLoad = System.currentTimeMillis()
      valueLastLoad = Some(t)
    }
  )
}