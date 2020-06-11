package oscar.cp.core.domains

import oscar.cp.core.CPOutcome
import scala.util.Random
import oscar.algo.reversible.ReversibleContext

abstract class IntervalDomain extends Iterable[Int] {
  
  def context: ReversibleContext

  def size: Int

  def isEmpty: Boolean
  
  def isBound: Boolean 

  def max: Int

  def min: Int
  
  def randomValue(rand: Random): Int
  
  def hasValue(value: Int): Boolean
  
  def assign(value: Int): CPOutcome

  def updateMin(value: Int): CPOutcome

  def updateMax(value: Int): CPOutcome

  def nextValue(value: Int): Int

  def prevValue(value: Int): Int

  def delta(oldMin: Int, oldMax: Int, oldSize: Int): Iterator[Int]
}