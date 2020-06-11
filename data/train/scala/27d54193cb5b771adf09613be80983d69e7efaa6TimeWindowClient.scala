package com.scindex.db

import com.google.common.primitives.Longs
import com.scindex.{TypeAlias, Deserializable}
import org.rocksdb.{Options, RocksDB, RocksIterator}

import scala.collection.mutable


class TimeWindowClient[A: TypeAlias.L, B: TypeAlias.L](path: String, ttl: Int)(
  implicit a: Deserializable[A], b: Deserializable[B]) {

  RocksDB.loadLibrary()

  private val options = new Options().setCreateIfMissing(true)
  options.setMaxOpenFiles(-1)

  private val rocksDB = RocksDB.open(options, path)

  def set(key: A, value: B, time: Long) = {
    val dumpValue = value.dump
    rocksDB.put(Longs.toByteArray(time) ++ key.dump ++ dumpValue, dumpValue)
  }

  def remove(key: A, value: B, time: Long) = rocksDB.remove(Longs.toByteArray(time) ++ key.dump ++ value.dump)

  def get(batchNum: Int): List[(A, B, Long)] = {
    val result = mutable.ArrayBuffer[(A, B, Long)]()
    val broken = mutable.ArrayBuffer[Array[Byte]]()
    val iterator: RocksIterator = rocksDB.newIterator()
    iterator.seekToFirst()
    var expired = true
    while (iterator.isValid && result.size < batchNum && expired) {
      val time = Longs.fromByteArray(iterator.key().take(Longs.BYTES))
      expired = time + ttl <= System.currentTimeMillis
      if (expired) {
        val key = a.load(Option(iterator.key().drop(Longs.BYTES).dropRight(iterator.value().size)))
        val value = b.load(Option(iterator.value()))
        if (key.isDefined && value.isDefined)
          result += ((key.get, value.get, time))
        else
          broken += iterator.key()
      }
      iterator.next()
    }
    iterator.dispose()
    broken.par.foreach(rocksDB.remove)
    result.toList
  }

  def close() = rocksDB.close()

}
