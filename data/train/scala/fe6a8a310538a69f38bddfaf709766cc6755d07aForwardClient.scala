package com.dedup.scindex.client
import org.rocksdb.{Options, RocksDB}

import com.dedup.scindex.{TypeAlias, Deserializable}


class ForwardClient[A: TypeAlias.L, B: TypeAlias.L](path: String)(
  implicit a: Deserializable[A], b: Deserializable[B]) {

  RocksDB.loadLibrary()
  private val options = new Options().setCreateIfMissing(true)
  options.setMaxOpenFiles(-1)
  val rocksDB = RocksDB.open(options, path)

  def set(key: A, value: B): Unit = rocksDB.put(key.dump, value.dump)

  def mset(items: List[(A, B)]): Unit = items.par.foreach(item => set(item._1, item._2))

  def get(key: A): Option[B] = Option(rocksDB.get(key.dump)).flatMap(b.load)

  def remove(key: A): Unit = rocksDB.remove(key.dump)

  def close() = rocksDB.close()

}
