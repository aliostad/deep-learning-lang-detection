package heap.persistence

import heap.core.Class
import heap.records.ClassDumpRecord

import scala.collection.mutable.{Map => MMap}

/**
  * Created by mehmetgunturkun on 12/02/17.
  */
trait Store[T] {
  def store(key: Long, item: T)
  def get(key: Long): Option[T]
}

trait InMemoryStore[T] {
  private val map: MMap[Long, T] = MMap.empty

  def store(key: Long, item: T) = map += (key -> item)

  def get(key: Long): Option[T] = map.get(key)
}


object StringStore extends InMemoryStore[String]
object ClassStore extends InMemoryStore[Class]
object ClassDumpStore extends InMemoryStore[ClassDumpRecord]