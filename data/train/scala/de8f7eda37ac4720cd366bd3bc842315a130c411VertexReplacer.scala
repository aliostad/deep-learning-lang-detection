package net.cyndeline.rlgraph.util

import scala.collection.mutable.ArrayBuffer
import scalax.collection.GraphPredef.{EdgeLikeIn, OuterEdge}
import scalax.collection.immutable.Graph

/**
 * Replaces vertices in an arbitrary graph, maintaining edge connections by rebuilding the
 * graph from scratch.
 *
 * @constructor Creates a new vertex replacer.
 */
class VertexReplacer[VType, EType[X] <: EdgeLikeIn[X]](edgeFactory: EdgeCopyFactory[VType, EType]) {

  def replace(oldVertex: VType, newVertex: VType, graph: Graph[VType, EType]): Graph[VType, EType] = {
    var newGraph: Graph[VType, EType] = graph

    val incoming = graph.get(oldVertex).incoming
    val savedIncoming = new ArrayBuffer[EType[VType]]()
    for (edge <- incoming) {
      savedIncoming += edge.toOuter
      newGraph -= edge
    }

    val outgoing = graph.get(oldVertex).outgoing
    val savedOutgoing = new ArrayBuffer[EType[VType]]()
    for (edge <- outgoing) {
      savedOutgoing += edge.toOuter
      newGraph -= edge
    }

    newGraph -= oldVertex
    newGraph += newVertex

    for (edge <- savedIncoming) {
      newGraph += copyEdge(edge, oldVertex, newVertex)
    }

    for (edge <- savedOutgoing) {
      newGraph += copyEdge(edge, oldVertex, newVertex)
    }

    newGraph
  }

  private def copyEdge(edge: EType[VType], oldVertex: VType, newVertex: VType): EType[VType] with OuterEdge[VType, EType] = {
    val a = if (edge._1 == oldVertex) newVertex else edge._1
    val b = if (edge._2 == oldVertex) newVertex else edge._2
    edgeFactory.copyEdge(edge, a, b)
  }
}
