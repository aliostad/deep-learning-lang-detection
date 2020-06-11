package model

import java.util.{Date, UUID}

sealed trait ProcessStatusType
object ProcessStatusType {
  case object Running extends ProcessStatusType
  case object Succeeded extends ProcessStatusType
  case object Failed extends ProcessStatusType
}

sealed trait ProcessStatus {
  def statusType: ProcessStatusType
}
object ProcessStatus {
  case class Running() extends ProcessStatus {
    def statusType = ProcessStatusType.Running
  }
  case class Succeeded(endedAt: Date) extends ProcessStatus {
    def statusType = ProcessStatusType.Succeeded
  }
  case class Failed(endedAt: Date) extends ProcessStatus {
    def statusType = ProcessStatusType.Failed
  }
}

case class Process(id: UUID, processDefinitionName: String, startedAt: Date, status: ProcessStatus, taskFilter: Option[Seq[String]] = None) {
  def endedAt: Option[Date] = status match {
    case ProcessStatus.Running() => None
    case ProcessStatus.Succeeded(when) => Some(when)
    case ProcessStatus.Failed(when) => Some(when)
  }
}
