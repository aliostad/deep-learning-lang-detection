package org.gga.graph.impl

import org.gga.graph.Edge
import org.gga.graph.EdgeIterator
import org.gga.graph.Graph
import org.gga.graph.search.dfs.Dfs

/**
 * @author mike
 */
object SubGraph {
  trait GraphFilter {
    def acceptVertex(v: Int): Boolean

    def acceptEdge(e: Edge): Boolean
  }

}

class SubGraph extends Graph {
  ???
/*
  def this(graph: Graph, filter: SubGraph.GraphFilter) {
    this()
    this.graph = graph
    edges = new Array[Boolean](graph.E)
    vertices = new Array[Boolean](graph.V)
    var numVertices: Int = 0
    {
      var v: Int = 0
      while (v < graph.V) {
        {
          vertices(v) = filter.acceptVertex(v)
          if (vertices(v)) {
            numVertices += 1
            import scala.collection.JavaConversions._
            for (e <- graph.getEdges(v)) {
              if (filter.acceptVertex(e.other(v))) {
                edges(e.idx) = filter.acceptEdge(e)
              }
            }
          }
        }
        ({
          v += 1; v - 1
        })
      }
    }
    oldVertexToNewVertexMap = new Array[Int](graph.V)
    newVertexToOldVertexMap = new Array[Int](numVertices)
    Arrays.fill(oldVertexToNewVertexMap, -1)
    Arrays.fill(newVertexToOldVertexMap, -1)
    {
      var v: Int = 0
      var newIdx: Int = 0
      while (v < graph.V) {
        {
          if (filter.acceptVertex(v)) {
            oldVertexToNewVertexMap(v) = newIdx
            newVertexToOldVertexMap(newIdx) = v
            newIdx += 1
          }
        }
        ({
          v += 1; v - 1
        })
      }
    }
    this.numVertices = numVertices
  }
*/

  def V: Int = {
    return numVertices
  }

  def E: Int = {
    return graph.E
  }

  def isDirected: Boolean = {
    return graph.isDirected
  }



/*
  @Nullable def edge(v: Int, w: Int): Edge = ???/*{
    val edge: Edge = graph.edge(newVertexToOldVertexMap(v), newVertexToOldVertexMap(w))
    return if (edge != null && edges(edge.idx)) edge else null
  }*/
*/

  def edge(v: Int, w: Int) = ???

  def edges(v: Int) = ???

  def getEdgeIterator(v: Int): EdgeIterator = ???


  override def getEdgesIterator(v: Int) = ???
/*
  def getEdgesIterator(v: Int): Iterator[Edge] = ??? /*{
    val l: List[Edge] = newArrayList
    val oldV: Int = newVertexToOldVertexMap(v)
    import scala.collection.JavaConversions._
    for (edge <- graph.getEdges(oldV)) {
      if (edges(edge.idx) && vertices(edge.w)) {
        l.add(new Edge(oldVertexToNewVertexMap(edge.v), oldVertexToNewVertexMap(edge.w)))
      }
    }
    return l.iterator
  }*/
*/


  def getDfs: Dfs = ??? /*{
    return new Dfs {
      def depthFirstSearch(visitor: DfsVisitor) {
        DepthFirstSearch.depthFirstSearch(SubGraph.this, visitor)
      }

      def depthFirstSearch(startVertex: Int, visitor: DfsVisitor) {
        DepthFirstSearch.depthFirstSearch(SubGraph.this, startVertex, visitor)
      }
    }
  }*/

  def getEdges(v: Int): Iterable[Edge] = ???/*{
    return new Iterable[Edge] {
      def iterator: Iterator[Edge] = {
        return getEdgesIterator(v)
      }
    }
  }*/

  override def toString: String = ???/*{
    return GraphsImpl.toString(this)
  }*/

/*
  private final val vertices: Array[Boolean] = null
  private final val edges: Array[Boolean] = null
*/
  private final val graph: Graph = null
/*
  private final val oldVertexToNewVertexMap: Array[Int] = null
  private final val newVertexToOldVertexMap: Array[Int] = null
*/
  private final val numVertices: Int = 0
}