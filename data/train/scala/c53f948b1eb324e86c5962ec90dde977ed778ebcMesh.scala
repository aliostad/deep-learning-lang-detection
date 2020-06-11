package de.exoticorn.modelconverter

import de.exoticorn.math._
import scala.collection.immutable._
import scala.collection.mutable.ArrayBuilder
import scala.collection.mutable.ArrayBuffer

sealed class VertexAttribute(val size: Int)
case object VertexAttributePosition extends VertexAttribute(3)
case object VertexAttributeNormal extends VertexAttribute(3)
case object VertexAttributeUV extends VertexAttribute(2)

sealed trait Polygons {
  def vertexIndex(polygonIndex: Int): Int
  def vertexCount(polygonIndex: Int): Int
  def size: Int
}
case class Triangles(val size: Int) extends Polygons {
  def vertexIndex(polygonIndex: Int) = polygonIndex * 3
  def vertexCount(polygonIndex: Int) = 3
}
case class MixedPolygons(offsets: Array[Int]) extends Polygons {
  def vertexIndex(polygonIndex: Int) = offsets(polygonIndex)
  def vertexCount(polygonIndex: Int) = offsets(polygonIndex + 1) - offsets(polygonIndex)
  def size = offsets.size - 1
}

case class Mesh(data: Map[VertexAttribute, Array[Double]], indices: Array[Int], polygons: Polygons) {
  assert(data.isDefinedAt(VertexAttributePosition))
  val numVertices = data(VertexAttributePosition).size / 3
  assert(data forall { case (a, d) => d.size / a.size == numVertices })

  def toTriangles: Mesh = {
    val builder = ArrayBuilder.make[Int]
    for (polygonIndex <- 0 until polygons.size) {
      var base = polygons.vertexIndex(polygonIndex)
      for (i <- 1 to (polygons.vertexCount(polygonIndex) - 2)) {
        builder += indices(base)
        builder += indices(base + i)
        builder += indices(base + i + 1)
      }
    }
    val newIndices = builder.result()
    Mesh(data, newIndices, Triangles(newIndices.size / 3))
  }

  def addPerPolygonVertexIndexAttribute(attr: VertexAttribute, data: Array[Double], indices: Array[Long]): Mesh = {
    val unpackedData = new Array[Double](indices.size * attr.size)
    for {
      i <- 0 until indices.size
      srcBase = indices(i).toInt * attr.size
      dstBase = i * attr.size
      j <- 0 until attr.size
    } {
      unpackedData(dstBase + j) = data(srcBase + j)
    }
    addPerPolygonVertexAttribute(attr, unpackedData, 0)
  }

  def addPerPolygonVertexAttribute(attr: VertexAttribute, aData: Array[Double], tolerance: Double): Mesh = {
    def reindex: (Int, Array[Int], Array[List[(Int, Int)]]) = {
      val indicesBuilder = ArrayBuilder.make[Int]
      val oldToNew = Array.fill(data(VertexAttributePosition).size / 3)(List.empty[(Int, Int)])
      var nextIndex = 0
      for (i <- 0 until indices.size) {
        val oldIndex = indices(i)
        val mapping = oldToNew(oldIndex)
        val base = i * attr.size
        def findBest(list: List[(Int, Int)], tolerance: Double, bestSoFar: List[(Int, Int)]): List[(Int, Int)] = list match {
          case Nil => bestSoFar
          case (oldIndex, newIndex) :: xs =>
            var sum = 0.0
            val base2 = oldIndex * attr.size
            for (j <- 0 until attr.size) {
              val diff = aData(base + j) - aData(base2 + j)
              sum += diff * diff
            }
            if (sum <= tolerance * tolerance)
              findBest(xs, math.sqrt(sum), list)
            else findBest(xs, tolerance, bestSoFar)
        }
        indicesBuilder += {
          findBest(mapping, tolerance, Nil) match {
            case Nil =>
              val newIndex = nextIndex
              nextIndex += 1
              oldToNew(oldIndex) = (i, newIndex) :: mapping
              newIndex
            case (_, i) :: _ => i
          }
        }
      }
      (nextIndex, indicesBuilder.result(), oldToNew)
    }

    def remapOld(numVertices: Int, oldToNew: Array[List[(Int, Int)]]): Map[VertexAttribute, Array[Double]] =
      for ((attr, data) <- data) yield {
        val newData = new Array[Double](numVertices * attr.size)
        for (i <- 0 until oldToNew.size) {
          val base = i * attr.size
          for ((_, dest) <- oldToNew(i)) {
            val destBase = dest * attr.size
            for (j <- 0 until attr.size) {
              newData(destBase + j) = data(base + j)
            }
          }
        }
        attr -> newData
      }

    def remapNew(numVertices: Int, oldToNew: Array[List[(Int, Int)]]): Array[Double] = {
      val newData = new Array[Double](numVertices * attr.size)
      for (i <- 0 until oldToNew.size) {
        for ((old, dest) <- oldToNew(i)) {
          val base = old * attr.size
          val destBase = dest * attr.size
          for (j <- 0 until attr.size) {
            newData(destBase + j) = aData(base + j)
          }
        }
      }
      newData
    }

    val (numVertices, newIndices, oldToNew) = reindex
    Mesh(remapOld(numVertices, oldToNew) + (attr -> remapNew(numVertices, oldToNew)), newIndices, polygons)
  }
}