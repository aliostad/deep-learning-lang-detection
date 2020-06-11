package com.bayesianwitch.injera.counting

trait Counter[T] {
  //mutable counters
  def inc(t: T): Long
  def get(t: T): Long
}

trait AddableCounter[T] extends Counter[T] {
  def add(t: T, n: Long): Long
}

trait IterableCounter[T] extends Counter[T] {
  def keys: Iterator[T]
}

trait IterableAddableCounterFactory[V[A] <: IterableCounter[A] with AddableCounter[A]] {
  def newZero[T](old: V[T]): V[T]
}

trait ZeroableCounter[T] extends Counter[T] {
  //The counter can be zeroed out, returning the old counts
  def zero: Map[T,Long]
}
