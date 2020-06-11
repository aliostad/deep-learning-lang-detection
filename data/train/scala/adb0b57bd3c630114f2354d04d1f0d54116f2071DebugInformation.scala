package pparkkin.scala.akka.practice.model

import collection.immutable
import java.util.concurrent.atomic.AtomicReference

class DebugInformation {
  private[this] val counterMap = new AtomicReference(immutable.Map.empty[String, Int])

  def increment(counter: String): Int = {
    var updated = false
    while(!updated) {
      val oldMap = counterMap.get
      val newMap =
        if (oldMap.contains(counter))
          oldMap + (counter -> (oldMap(counter)+1))
        else
          oldMap + (counter -> 1)
      if (counterMap.compareAndSet(oldMap, newMap))
        updated = true
    }
    counterMap.get()(counter)
  }

  def get(counter: String): Int = counterMap.get()(counter)

  def keys(): Iterable[String] = counterMap.get.keys

}
