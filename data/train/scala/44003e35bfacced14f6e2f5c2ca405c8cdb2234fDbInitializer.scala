package text

import java.io.File

import org.neo4j.graphdb.Direction

import main.Main.logger
import pishen.db.Record

object DbInitializer {
  def setupIndexes() = {
    Neo4j.createIndexIfNotExist(Labels.Paper, "dblpKey")
    Neo4j.createIndexIfNotExist(Labels.Paper, "ee")
    logger.info("wait for indexes")
    Neo4j.waitForIndexes(100)
  }

  def createPapers() = {
    new DblpIterator().foreach(p => {
      val nodeOpt = Neo4jOld.getRecord(p.dblpKey)
      if (nodeOpt.nonEmpty) {
        val node = nodeOpt.get
        val ty = Neo4jOld.getNodeProp(node, "CITATION_TYPE")
        val text = new File("text-records/" + p.dblpKey)
        if (ty == "NUMBER" && text.exists()) {
          Paper.createPaper(p.dblpKey, p.title, p.year.toString, p.ee)
        }
      }
    })
  }

  def connectPapers() = {
    Paper.allPapers.foreach(p => {
      val nodeOpt = Neo4jOld.getRecord(p.dblpKey)
      if (nodeOpt.nonEmpty) {
        logger.info("create Refs: " + p.dblpKey)
        val node = nodeOpt.get
        Neo4j.withTx {
          Neo4jOld.getRels(node, Record.Ref, Direction.OUTGOING)
            .map(Neo4jOld.getEndNode)
            .foreach(ref => {
              val index = Neo4jOld.getNodeProp(ref, "REF_INDEX").toInt
              val target = Neo4jOld.getRels(ref, Record.Ref, Direction.OUTGOING).map(Neo4jOld.getEndNode)
              if (target.nonEmpty) {
                val targetKey = Neo4jOld.getNodeProp(target.head, "NAME")
                Paper.getPaperByDblpKey(targetKey) match {
                  case Some(t) => p.createRefTo(t, index)
                  case None    => //should not happen
                }
              }
            })
        }
      }
    })
  }

}