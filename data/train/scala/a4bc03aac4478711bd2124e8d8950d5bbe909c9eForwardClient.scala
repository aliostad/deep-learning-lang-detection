package com.scindex.db

import com.scindex.{TypeAlias, Deserializable}
import org.rocksdb.{Options, RocksDB}

import scala.collection.JavaConversions._


class ForwardClient[A: TypeAlias.L, B: TypeAlias.L](path: String)(
  implicit a: Deserializable[A], b: Deserializable[B]) {

  RocksDB.loadLibrary()
  private val options = new Options().setCreateIfMissing(true)
  options.setMaxOpenFiles(-1)
  val rocksDB = RocksDB.open(options, path)

  def set(key: A, value: B): Unit = rocksDB.put(key.dump, value.dump)

  def mset(items: List[(A, B)]): Unit = items.par.foreach(item => set(item._1, item._2))

  def get(key: A): Option[B] = b.load(Option(rocksDB.get(key.dump)))

  def mget(keys: List[A]): Map[A, Option[B]] = rocksDB.multiGet(keys.par.map(_.dump).toList).par.map {
    case (k, v) => a.load(Option(k)) -> b.load(Option(v))
  }.collect {
    case (Some(k), v) => k -> v
  }.seq.toMap

  def remove(key: A): Unit = rocksDB.remove(key.dump)

  def close() = rocksDB.close()

}
