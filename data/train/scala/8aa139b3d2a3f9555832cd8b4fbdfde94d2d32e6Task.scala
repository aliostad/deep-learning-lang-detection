package me.yzhi.twiggy.system

/**
 */
class Task(val opt :TaskOpt, val request: Boolean = false, val time: Int = 0) {
  var customer: String = _
  var mngApp: ManageApp = null
  var mngNode: ManageNode = null
  var msg: String = _

  def setMessage(msg: String): Unit = {
    // TODO
  }
}

sealed trait TaskOpt

object Task {
  case object TERMINATE extends TaskOpt
  case object TERMINATE_CONFIRM extends TaskOpt
  case object REPLY extends TaskOpt
  case object MANAGE extends TaskOpt
  case object CALL_CUSTOMER extends TaskOpt
  case object HEARTBEATING extends TaskOpt
}
