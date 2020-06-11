package org.elastic.elasticsearch.graphdb.client

import org.elastic.rest.scala.driver.RestBase._
import org.elastic.rest.scala.driver.RestResources._

/**
  * The client API for accessing the graph DB overlay
  */
object GraphDbApi {
  //TODO: params ... stuff like... version
  //TODO: also save a pointer to typed data allows you to use the API for server side code...?
  //TOOD: (maybe save the typed obj and a transform to change to a string on demand, eg lazy val)

  //TODO: also save the param in Modifier so can do case MyModifier.name => //handle MyModifier

  sealed trait GraphDbOps

  // Create node

  case class `/node/$index/$type`(index: String, `type`: String)
    extends RestSendable[BaseDriverOp]
      with RestResource
      with GraphDbOps

  // Manage node

  case class `/node/$index/$type/$id`(index: String, `type`: String, id: String)
    extends RestReadable[BaseDriverOp]
      with RestSendable[BaseDriverOp]
      with RestWritable[BaseDriverOp]
      with RestDeletable[BaseDriverOp]
      with RestResource
      with GraphDbOps

  // Create edge

  case class `/edge/$index/$fromId/$toId`(index: String, fromId: String, toId: String)
    extends RestSendable[BaseDriverOp]
      with RestResource
      with GraphDbOps

  case class `/edge/$fromIndex/$fromId/$toIndex/$toId`
  (fromIndex: String, fromId: String, toIndex: String, toId: String)
    extends RestSendable[BaseDriverOp]
      with RestResource
      with GraphDbOps

  // Manage edge

  case class `/edge/$edgeId`(edgeId: String)
    extends RestReadable[BaseDriverOp]
      with RestWritable[BaseDriverOp]
      with RestDeletable[BaseDriverOp]
      with RestResource
      with GraphDbOps

  // Create attributes

  case class `/node/$index/$nodeId/attr`(index: String, nodeId: String)
    extends RestSendable[BaseDriverOp]
      with RestResource
      with GraphDbOps

  case class `/edge/$index/$edgeId/attr`(index: String, edgeId: String)
    extends RestSendable[BaseDriverOp]
      with RestResource
      with GraphDbOps

  // Manage attributes

  case class `/node/$index/$edgeId/attr/$attrId`(index: String, edgeId: String, attrId: String)
    extends RestReadable[BaseDriverOp]
      with RestWritable[BaseDriverOp]
      with RestDeletable[BaseDriverOp]
      with RestResource
      with GraphDbOps

  case class `/edge/$index/$edgeId/attr/$attrId`(index: String, edgeId: String, attrId: String)
    extends RestReadable[BaseDriverOp]
      with RestWritable[BaseDriverOp]
      with RestDeletable[BaseDriverOp]
      with RestResource
      with GraphDbOps

  //TODO bulk manage
}
