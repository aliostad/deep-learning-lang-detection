package ru.biocad.yneo.graph

import org.neo4j.driver.v1.{Record, Statement}
import ru.biocad.graph._
import ru.biocad.yneo.StatementResultIterator
import ru.biocad.yneo.common.NeoRunner
import ru.biocad.yneo.nodes.{NeoNode, Node}
import ru.biocad.yneo.relationships.{NeoRelationship, Relationship}

/**
  * Created by pavel on 05.05.16.
  */
class NeoGraph(runner : NeoRunner, nodes : NeoNode, relationships : NeoRelationship) {
  def create(graph : Graph) : IndexedSeq[Long] =
    create(GraphDump.fromGraph(graph))

  def create(dump : GraphDump) : IndexedSeq[Long] =
    insertGraph(dump)((node : GraphNode, run : Statement => StatementResultIterator) => nodes.merge(node, run),
                       (rel : GraphRel, begin : Long, end : Long,
                        run : Statement => StatementResultIterator) => relationships.create(rel, begin, end, run))

  def merge(graph : Graph) : IndexedSeq[Long] =
    merge(GraphDump.fromGraph(graph))

  def merge(dump : GraphDump) : IndexedSeq[Long] =
    insertGraph(dump)((node : GraphNode, run : Statement => StatementResultIterator) => nodes.merge(node, run),
                       (rel : GraphRel, begin : Long, end : Long,
                        run : Statement => StatementResultIterator) => relationships.merge(rel, begin, end, run))


  def reconstruct(resultIterator : Iterator[Record], nodes : (String, String), rels : String) : Graph = {
    resultIterator.foldRight(Graph()) {
      case (record, graph) =>
        val n = Node(record.get(nodes._1))
        val m = Node(record.get(nodes._2))
        val r = Relationship(record.get(rels))

        graph + (n ~ m)(r)
    }
  }

  private def insertGraph(dump : GraphDump)(insertNode : (GraphNode, Statement => StatementResultIterator) => Long,
                                            insertRelationship : (GraphRel, Long, Long, Statement => StatementResultIterator) => Long) : IndexedSeq[Long] = {
    var ids = IndexedSeq.empty[Long]
    runner.transaction {
      case run =>
        ids = dump.nodes.map(insertNode(_, run))
        dump.relationships.foreach {
          case ((begin, end), rel) =>
            insertRelationship(rel, ids(begin), ids(end), run)
        }
    }
    ids
  }
}
