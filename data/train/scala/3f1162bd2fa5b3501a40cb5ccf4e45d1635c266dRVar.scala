package net.flatmap.js.util

import scala.collection.mutable

trait RVar[T] {
  def := (v: T): Unit
  def apply(): T
  def modify(f: T => T): Unit = this := f(this())
  def react(f: T => Unit): () => Unit
  def onChange(f: (T,T) => Unit): () => Unit
}

object RVar {
  def apply[T](v: T, alwaysFire: Boolean = false): RVar[T] = {
    var value = v
    val listeners = mutable.Set.empty[(T,T) => Unit]
    new RVar[T] {
      def := (v: T): Unit = {
        if (alwaysFire || value != v) {
          val old = value
          value = v
          listeners.foreach(_(old,value))
        }
      }
      def apply(): T = value
      def onChange(f: (T,T) => Unit): () => Unit = {
        listeners += f
        () => listeners -= f
      }
      def react(f: T => Unit): () => Unit =
        onChange { case (o,n) => f(n) }
    }
  }
}
