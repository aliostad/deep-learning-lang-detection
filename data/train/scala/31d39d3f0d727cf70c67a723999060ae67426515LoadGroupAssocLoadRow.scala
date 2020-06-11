package org.runger.lulight.rds

import java.util.UUID

import org.runger.lulight.Logging
import org.runger.lulight.rds.RDSConfig.api._

/**
  * Created by randy on 9/29/16.
  */
case class LoadGroupAssocLoadRow(hostGroupId: UUID, loadId: UUID)

class LoadGroupAssocLoadTable(tag: Tag) extends Table[LoadGroupAssocLoadRow](tag, "LoadGroupAssocLoad") with Logging {

//  def id = column[UUID]("id", O.PrimaryKey)

  def hostGroupId = column[UUID]("hostGroupId")
  def hostGroup = foreignKey("hostGroupId", hostGroupId, Tables.groups)(_.id, ForeignKeyAction.Restrict)

  def loadId = column[UUID]("loadId")
  def load = foreignKey("loadId", loadId, Tables.loads)(_.id, ForeignKeyAction.Restrict)

//  def subGroupId = column[Option[UUID]]("subGroupId")
//  def subGroup = foreignKey("subGroupId", subGroupId, Tables.groups)(_.id, ForeignKeyAction.Restrict)

  def uniqueHostLoad = index("uniqueHostLoadSub", (hostGroupId, loadId), unique = true)

  val toRow = (tup: (UUID, UUID)) => {
    LoadGroupAssocLoadRow(tup._1, tup._2)
  }

  val fromRow = (row: LoadGroupAssocLoadRow) => {
    Option((row.hostGroupId, row.loadId))
  }

  override def * = (hostGroupId, loadId) <> (toRow, fromRow)
}


