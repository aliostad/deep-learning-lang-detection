package com.timeserieszen

import org.scalacheck._
import scalaz._
import Scalaz._
import scalaz.stream._
import scalacheck.ScalazProperties._
import Arbitrary.arbitrary
import Prop._
import TestHelpers._
import org.scalacheck.Prop.BooleanOperators
import java.util.Arrays

object UtilsSpec extends Properties("Utils") {

  property("sorting") = forAllNoShrink(arbitrary[(Array[Long], Array[Double])])((m: (Array[Long], Array[Double])) => {
    val n = math.min(m._1.distinct.length, m._2.distinct.length)
    val (t,v) = ( m._1.distinct.slice(0,n), m._2.distinct.slice(0,n) )
    val (oldT, oldV) = (Arrays.copyOf(t, n), Arrays.copyOf(v, n))
    Utils.sortSeries(t,v)
    (oldT.zip(oldV).toMap == t.zip(v).toMap) :| "Sorting preserves the time->value mapping"
  })

  property("remove duplicates") = forAllNoShrink(arbitrary[(Array[Long], Array[Double])])((m: (Array[Long], Array[Double])) => {
    val n = math.min(m._1.distinct.length, m._2.distinct.length)
    val (t,v) = ( m._1.distinct.slice(0,n), m._2.distinct.slice(0,n) )
    if (t.size > 3) {
      t(0) = 3
      t(1) = 3
    }
    val (oldT, oldV) = (Arrays.copyOf(t, n), Arrays.copyOf(v, n))
    Utils.sortSeries(oldT, oldV)

    val (newT, newV) = Utils.stripDuplicates(oldT, oldV)
    (oldT.toSet.size == newT.size) :| "There are no duplicates in the result"
  })

}
