package com.scindex.db

import com.scindex.{TypeAlias, Deserializable}
import org.rocksdb.{Options, RocksDB, RocksIterator}

import scala.collection.mutable


class InvertClient[A: TypeAlias.L, B: TypeAlias.L](path: String)(
  implicit a: Deserializable[A], b: Deserializable[B]) {

  RocksDB.loadLibrary()
  private val options = new Options().setCreateIfMissing(true)
  options.setMaxOpenFiles(-1)
  val rocksDB = RocksDB.open(options, path)

  def add(key: A, value: B) = {
    val dumpValue = value.dump
    rocksDB.put(key.dump ++ dumpValue, dumpValue)
  }

  def get(key: A): Vector[B] = {
    val iterator: RocksIterator = rocksDB.newIterator()
    val results = mutable.ArrayBuffer[Option[B]]()
    val dumpKey = key.dump
    val dumpKeyDeep = dumpKey.deep
    iterator.seek(dumpKey)
    while (iterator.isValid && iterator.key().dropRight(iterator.value().size).deep == dumpKeyDeep) {
      results += b.load(Option(iterator.value()))
      iterator.next()
    }
    iterator.dispose()
    results.flatten.toVector
  }

  def remove(key: A, value: B): Unit = rocksDB.remove(key.dump ++ value.dump)

  def close() = rocksDB.close()

}
