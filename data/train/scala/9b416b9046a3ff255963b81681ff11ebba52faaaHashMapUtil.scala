package com.buzzinate.keywords.util

import scala.collection.mutable.HashTable
import scala.collection.mutable.DefaultEntry

object HashMapUtil {
  trait IntHashMap[A] extends HashTable[A, DefaultEntry[A, Int]] {
    def adjustOrPut(key: A, incr: Int, value: Int): Int = {
      val e = findEntry(key)
      if (e == null) {
        addEntry(new DefaultEntry[A, Int](key, value))
        0
      } else {
        val old = e.value
        e.value += incr
        old
      }
    }

    def putMax(key: A, value: Int): Int = {
      val e = findEntry(key)
      if (e == null) {
        addEntry(new DefaultEntry[A, Int](key, value))
        0
      } else {
        val old = e.value
        if (value > e.value) e.value = value
        old
      }
    }
  }
  
  trait DoubleHashMap[A] extends HashTable[A, DefaultEntry[A, Double]] {
    def adjustOrPut(key: A, incr: Double, value: Double): Double = {
      val e = findEntry(key)
      if (e == null) {
        addEntry(new DefaultEntry[A, Double](key, value))
        0
      } else {
        val old = e.value
        e.value += incr
        old
      }
    }

    def putMax(key: A, value: Double): Double = {
      val e = findEntry(key)
      if (e == null) {
        addEntry(new DefaultEntry[A, Double](key, value))
        0
      } else {
        val old = e.value
        if (value > e.value) e.value = value
        old
      }
    }
  }
}