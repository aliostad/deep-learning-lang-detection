package com.sos.scheduler.engine.tests.order.monitor.spoolerprocessafter.setting

sealed abstract class MethodNames(val name: String) {
  protected val prefix = s"$name."
  val throwException = s"${prefix}throwException"
  val logError = s"${prefix}logError"
  val returns = s"${prefix}returns"
}

object SpoolerProcessNames extends MethodNames("SpoolerProcess")

object SpoolerProcessBeforeNames extends MethodNames("SpoolerProcessBefore")

object SpoolerProcessAfterNames extends MethodNames("SpoolerProcessAfter") {
  val parameter = s"${prefix}spoolerProcessAfterParameter"
}
