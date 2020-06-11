package ru.biocad.graph

/**
  * Created by pavel on 05.05.16.
  */
case class GraphDump(nodes : IndexedSeq[GraphNode], relationships : Map[(Int, Int), GraphRel])

object GraphDump {
  def fromGraph(graph : Graph) : GraphDump = {
    // DARK MAGIC: NB! top vertex of graph will be always first
    val nodesList =
      graph.top match {
        case Some(top) if graph.nodes.contains(top) => (top :: nodesToList(graph.nodes)).distinct
        case _                                      => nodesToList(graph.nodes)
      }

    val nodesMap = nodesList.zipWithIndex.map { case (node, idx) => node -> idx }.toMap
    val relationships = graph.relationships.map {
      case relationship =>
        (nodesMap(relationship.begin), nodesMap(relationship.end)) -> relationship.rel
    }.toMap
    val nodes = new Array[GraphNode](graph.nodes.size)
    nodesMap.foreach {
      case (node, idx) =>
        nodes(idx) = node
    }

    GraphDump(nodes, relationships)
  }

  def nodesToList(map : Map[GraphNode, Long]) : List[GraphNode] = map.toList.sortBy((_._2)).map((_._1))
}