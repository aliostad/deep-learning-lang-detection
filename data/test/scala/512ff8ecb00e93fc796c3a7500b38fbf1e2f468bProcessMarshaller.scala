package dao.postgres.marshalling

import java.sql.{Connection, PreparedStatement, ResultSet, Timestamp}
import java.util.UUID
import dao.postgres.common.ProcessTable
import model.{Process, ProcessStatus}
import util.JdbcUtil._

object ProcessMarshaller {

  def unmarshalProcess(rs: ResultSet): Process = {
    import ProcessTable._
    Process(
      id = rs.getObject(COL_ID).asInstanceOf[UUID],
      processDefinitionName = rs.getString(COL_DEF_NAME),
      startedAt = javaDate(rs.getTimestamp(COL_STARTED)),
      status = rs.getString(COL_STATUS) match {
        case STATUS_SUCCEEDED => ProcessStatus.Succeeded(javaDate(rs.getTimestamp(COL_ENDED_AT)))
        case STATUS_FAILED => ProcessStatus.Failed(javaDate(rs.getTimestamp(COL_ENDED_AT)))
        case STATUS_RUNNING => ProcessStatus.Running()
      },
      taskFilter = getStringArray(rs, COL_TASK_FILTER)
    )
  }

  def marshalProcess(process: Process, stmt: PreparedStatement, columns: Seq[String], startIndex: Int = 1)
                    (implicit conn: Connection) = {
    import ProcessTable._
    var index = startIndex
    columns.foreach { col =>
      col match {
        case COL_ID => stmt.setObject(index, process.id)
        case COL_DEF_NAME => stmt.setString(index, process.processDefinitionName)
        case COL_STARTED => stmt.setTimestamp(index, new Timestamp(process.startedAt.getTime()))
        case COL_ENDED_AT => stmt.setTimestamp(index, process.endedAt.getOrElse(null))
        case COL_STATUS => stmt.setString(index, process.status match {
          case ProcessStatus.Succeeded(_) => STATUS_SUCCEEDED
          case ProcessStatus.Failed(_) => STATUS_FAILED
          case ProcessStatus.Running() => STATUS_RUNNING
        })
        case COL_TASK_FILTER => stmt.setArray(index, process.taskFilter.map(makeStringArray).getOrElse(null))
      }
      index += 1
    }
  }

}
