package org.eknet.county

import java.util.concurrent.ConcurrentHashMap

/**
 * @author Eike Kettner eike.kettner@gmail.com
 * @since 22.03.13 23:16
 */
class BasicCounterPool(granularity: Granularity = Granularity.Minute) extends CounterPool {

  private val map = new ConcurrentHashMap[String, Counter]()

  def getOrCreate(name: String) = find(name) getOrElse {
    val c = createCounter(name)
    val old = map.putIfAbsent(name, c)
    if (old == null) c else old
  }

  def find(name: String) = Option(map.get(name))

  def remove(name: String) = Option(map.remove(name)).isDefined

  def createCounter(name: String) = new BasicCounter(granularity)
}
