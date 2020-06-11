package com.timeserieszen.storage

import com.timeserieszen._
import com.timeserieszen.storage._

import java.io.File
import java.util.UUID
import org.scalacheck._
import scalaz._
import Scalaz._
import scalaz.stream._
import scalacheck.ScalazProperties._
import org.scalacheck.Prop.BooleanOperators
import Arbitrary.arbitrary
import Prop._
import TestHelpers._

object SequentialBinaryV1StorageHandlerSpec extends Properties("SequentialBinaryV1StorageHandler") {
  private def mkdirs(f: File): (File, File) = {
    val stagingDir = new File(f, "staging")
    stagingDir.mkdir()
    val dataDir = new File(f, "data")
    dataDir.mkdir()
    (stagingDir, dataDir)
  }

  property("to and from file") = forAllNoShrink(genArrayForSeries)( data => {
    withTempDir(f => {
      val (stagingDir, dataDir) = mkdirs(f)
      val s = SequentialBinaryV1Storage(dataDir, stagingDir)
      val id = SeriesIdent(UUID.randomUUID().toString)
      val oldSeries = BufferedSeries(id, data._1, data._2)
      s.write(oldSeries)
      val newSeries = s.read(id).fold(_ => ???, s => s)
      ((oldSeries.ident == newSeries.ident) :| "identities do not match") &&
      ((oldSeries.data == newSeries.data) :| "data series do not match")
    })
  })
  property("to and from file + append, no rewrite") = forAllNoShrink(genArrayForSeries)( data => {
    withTempDir(f => {
      val (stagingDir, dataDir) = mkdirs(f)

      val s = SequentialBinaryV1Storage(dataDir, stagingDir)
      val id = SeriesIdent(UUID.randomUUID().toString)

      val N = data._1.size
      val cutPoint = data._1.size/2
      val (firstTimes, firstValues) = (data._1.slice(0,cutPoint), data._2.slice(0,cutPoint))
      val (lastTimes, lastValues) = (data._1.slice(cutPoint,N), data._2.slice(cutPoint, N))
      val oldSeries = BufferedSeries(id, data._1, data._2)
      val oldSeries1 = BufferedSeries(id, firstTimes, firstValues)
      val oldSeries2 = BufferedSeries(id, lastTimes, lastValues)
      s.write(oldSeries1)
      s.write(oldSeries2)

      val newSeries = s.read(id).fold(_ => ???, s => s)

      ((oldSeries.ident == newSeries.ident) :| "identities do not match") &&
      ((oldSeries.data == newSeries.data) :| "data series do not match")
    })
  })
  property("to and from file + append, with rewrite") = forAllNoShrink(for {
    x <- genArrayForSeries
    y <- genArrayForSeries
  } yield (x,y))( data2 => {
    withTempDir(f => {
      val (stagingDir, dataDir) = mkdirs(f)
      val s = SequentialBinaryV1Storage(dataDir, stagingDir)

      val id = SeriesIdent(UUID.randomUUID().toString)

      val (t1, v1) = data2._1
      val (t2, v2) = data2._2
      var i=0 //Interleave the timestamps
      while(i < t1.size) {
        t1(i) = t1(i)*2
        i += 1
      }
      i = 0
      while(i < t2.size) {
        t2(i) = t2(i)*2+1
        i += 1
      }
      val (t, v) = ((t1 ++ t2).toArray, (v1 ++ v2).toArray)
      Utils.sortSeries(t,v)

      s.write(BufferedSeries(id, t1, v1))
      s.write(BufferedSeries(id, t2, v2))

      val oldSeries = BufferedSeries(id, t, v)
      val newSeries = s.read(id).fold(_ => ???, s => s)

      ((oldSeries.ident == newSeries.ident) :| "identities do not match") &&
      ((oldSeries.data == newSeries.data) :| "data series do not match")
    })
  })
}
