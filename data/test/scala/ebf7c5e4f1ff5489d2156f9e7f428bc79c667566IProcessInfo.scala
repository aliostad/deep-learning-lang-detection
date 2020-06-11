package mysqlcommon.tables

import java.sql.Timestamp
import java.util.Date
import slick.jdbc.MySQLProfile.api._
import mysqlcommon.models.{ProcessInfo}

/**
  * Created by mor on 8/20/17.
  */
trait IProcessInfo {
  class ProcessInfoTable(tag: Tag) extends Table[ProcessInfo](tag, "Process_Info") {
    // Columns
    def processId = column[Int]("process_id")

    def bundle = column[String]("bundle", O.Length(30))

    def filesList = column[String]("files_list", O.Length(4000))

    def processFinishedDate = column[Timestamp]("process_finished_date")

    def status = column[String]("status", O.Length(30), O.Default("Not_Checked"))

    def createDate = column[Timestamp]("create_date",O.Default(new Timestamp(new Date().getTime)))

    def updateDate = column[Timestamp]("update_date",O.Default(new Timestamp(new Date().getTime)))

    def pk = primaryKey("pk_a", (processId))

    //    // Indexes
    //    def emailIndex = index("USER_EMAIL_IDX", email, true)

    // Select
    def * = (processId, bundle, filesList, processFinishedDate, status, createDate, updateDate) <> (ProcessInfo.tupled, ProcessInfo.unapply)
  }

  val processInfo = TableQuery[ProcessInfoTable]
}
