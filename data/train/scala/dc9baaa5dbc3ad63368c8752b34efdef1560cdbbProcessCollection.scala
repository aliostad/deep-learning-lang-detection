package com.qburst.models

import org.json4s.JsonDSL._
import org.json4s.jackson.JsonMethods._

case class ProcessCollection(timestamp: Long, processes: List[ProcessObject]) {
  def toJson: String = {
    compact(render(
      (ProcessCollection.Fields.timestamp -> timestamp) ~
      (ProcessCollection.Fields.processes -> processes.map(_.toJson))
    ))
  }
}

case object ProcessCollection {
  object Fields {
    final val timestamp = "timestamp"
    final val processes = "processes"
  }

  def apply(json: String): ProcessCollection = {
    implicit val formats = org.json4s.DefaultFormats
    val j = parse(json)
    new ProcessCollection(
      (j \ ProcessCollection.Fields.timestamp).extract[Long],
      (j \ ProcessCollection.Fields.processes).extract[List[ProcessObject]])
  }
}
