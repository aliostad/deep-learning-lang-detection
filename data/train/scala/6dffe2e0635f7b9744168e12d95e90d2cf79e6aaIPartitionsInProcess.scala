package mysqlcommon.tables

import mysqlcommon.models.{PartitionsInProcess}
import slick.jdbc.MySQLProfile.api._

/**
  * Created by mor on 8/20/17.
  */
trait IPartitionsInProcess {

  class PartitionsInProcessTable(tag: Tag) extends Table[PartitionsInProcess](tag, "Partitions_In_Process") {
    // Columns
    def processId = column[Int]("process_id")

    def bundle = column[String]("Bundle", O.Length(30))

    def partitionDesc = column[String]("PartitionDesc", O.Length(200))

    // Select
    def * = (processId, bundle, partitionDesc) <> (PartitionsInProcess.tupled, PartitionsInProcess.unapply)
  }

  val partitionsInProcess = TableQuery[PartitionsInProcessTable]
}
