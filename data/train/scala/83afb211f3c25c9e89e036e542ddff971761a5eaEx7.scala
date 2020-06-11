package ch4

import scala.concurrent.{Promise, Future}
import scala.collection.concurrent._

/**
 * @author Got Hug
 */
object Ex7 {
  class IMap[K, V] {
    val map = new TrieMap[K, Promise[V]]()

    private def obtainPromise(k: K): Promise[V] = {
      val p = Promise[V]()
      val oldP = map.putIfAbsent(k, p)
      oldP.getOrElse(p)
    }

    def update(k: K, v: V): Unit = {
      val p = obtainPromise(k)

      if (!p.trySuccess(v)) {
        throw new Exception(s"key '$k' already assigned a value")
      }
    }

    def apply(k: K): Future[V] = {
      val p = obtainPromise(k)
      p.future
    }
  }
}

object Ex7Test extends App {
  import Ex7._

  val m = new IMap[String, Int]()

  println(m("a").value)
  m.update("a", 1)
  println(m("a").value)

  m.update("b", 2)
  println(m("b").value)
}
