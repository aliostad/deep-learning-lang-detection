package sc.ala.neo4j.commands

import sc.ala.neo4j.{Neo,Tsv}
import org.neo4j.graphdb.Node
import scala.collection.JavaConversions._
import scala.Console.err

trait Dump { this:Neo =>
  def dump = R{
    for (n1 <- db.getAllNodes) {
      for (r <- n1.getRelationships) {
	val n2 = r.getEndNode
	if (n1 != n2)
	  printf("%s\t%s\t%s\n", nodeName(n1), r.getType, nodeName(n2))
      }
    }
  }

  private def nodeName(node:Node) = node("name") match {
    case Some(value) => value
    case None => format("(id:%s)", node.getId)
  }
}
