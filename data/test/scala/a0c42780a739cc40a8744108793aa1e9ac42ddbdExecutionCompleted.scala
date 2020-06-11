package org.system.plugin.command.manage

import org.system.api.command.Response
import play.api.libs.json.{JsObject, JsString, JsValue}

sealed trait Successfully

sealed trait Failed

sealed trait ExecutionCompleted extends Response {

  def report: JsValue

}

case class ExecutionSuccessfullyCompleted( report: JsValue = JsObject(Seq("report" -> JsString("no report"))) )  extends ExecutionCompleted with Successfully

case class ExecutionFailed( report: JsValue = JsObject(Seq("report" -> JsString("no report"))) )  extends ExecutionCompleted with Failed
