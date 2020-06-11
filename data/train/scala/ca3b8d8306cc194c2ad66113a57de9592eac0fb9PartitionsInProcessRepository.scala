package mysqlcommon.repositories

import mysqlcommon.tables.{IPartitionsInProcess}
import mysqlcommon.traits.Db
import slick.basic.DatabaseConfig
import slick.jdbc.JdbcProfile
import slick.jdbc.MySQLProfile.api._

/**
  * Created by mor on 8/20/17.
  */
class PartitionsInProcessRepository(val config: DatabaseConfig[JdbcProfile])
  extends Db with IPartitionsInProcess {

  def getPartitionsForProcess(processId: Int, bundle: String) = {
    val q = partitionsInProcess.filter(_.processId === processId).filter(_.bundle === bundle).result
    db.run(q)
  }

  def getPartitionsForProcesses(processIds: Seq[Int], bundle: Seq[String]) = {
    val query: DBIO[Seq[(Int, String, String)]] =
      sql"""select process_id, Bundle, PartitionDesc
           from Partitions_In_Process
           where bundle in (#${bundle mkString("'", "','", "'")})
           and process_id in (#${processIds mkString ","})"""
        .as[(Int, String, String)]

    val qStr = s"select process_id, Bundle, PartitionDesc from Partitions_In_Process where bundle in (${bundle mkString("'", "','", "'")}) and process_id in (${processIds mkString ","})"

    println(s"getPartitionsForProcesses query -> ${qStr}")

    db.run(query)
  }
}
