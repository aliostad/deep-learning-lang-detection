package molmed.shell.async

import scala.sys.process._
import scala.concurrent._
import scala.concurrent.ExecutionContext.Implicits.global
import molmed.shell.async.JobStatuses._

object AsyncShellManager {

  def apply(): AsyncShellManager = new AsyncShellManager()

}

class AsyncShellManager {

  private var managedProcesses: Set[AsyncShellJob] = Set()

  private def addManagedProcess(p: AsyncShellJob): Set[AsyncShellJob] = {
    managedProcesses += p
    managedProcesses
  }

  private def removeManagedProcess(p: AsyncShellJob): Set[AsyncShellJob] = {
    managedProcesses -= p
    managedProcesses
  }

  private def stopProcess(p: AsyncShellJob): Unit =
    p.stop()

  def exit(): Unit =
    for (p <- managedProcesses)
      stopProcess(p)

  def createAsyncShellJob(processToBuild: ProcessBuilder): AsyncShellJob = {
    val process = AsyncShellJob(processToBuild)
    process.start()
    addManagedProcess(process)
    process
  }

  def updateStatus() =
    for (process <- managedProcesses) {
      queryStatus(process)
      managedProcesses
    }

  def queryStatus(process: AsyncShellJob): JobStatus = {
    process.status()
  }

  def tryStop(processes: Seq[AsyncShellJob]): Unit = {
    for (process <- processes) {
      process.stop()
      removeManagedProcess(process)
    }
  }

}