package ch.inventsoft.scalabase
package process

/**
 * Message that signals the termination of the process (normal or abnormal).
 */
sealed trait ProcessEnd {
  def process: Process
}
object ProcessEnd {
  def unapply(end: ProcessEnd) = Some(end.process)
}

/**
 * Message that signals the normal exit of the process
 */
case class ProcessExit(process: Process) extends ProcessEnd
/**
 * Message that signals the killing of the process
 */
case class ProcessKill(process: Process, by: Process, reason: Throwable) extends ProcessEnd
/**
 * Message that signals the abnormal termination of the process.
 */
case class ProcessCrash(process: Process, reason: Throwable) extends ProcessEnd
