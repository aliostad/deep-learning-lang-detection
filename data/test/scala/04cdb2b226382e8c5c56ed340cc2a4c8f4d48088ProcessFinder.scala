package cloud.fan

import scala.collection.mutable

/**
 * Created by cloud on 4/29/14.
 */
object ProcessFinder {

  val cachedProcessId = mutable.HashMap.empty[String, Option[String]]

  def getProcessIds(processName: String, node: String) = {
    val command = Seq(Seq("ps", "aux"), Seq("grep", processName), Seq("grep", "-v", "grep"), Seq("grep", "-v", "log-analyzer"), Seq("awk", "{print $2}"))
    val output = ShUtil.generatePipedCommand(command, node).!!
    if (output.length > 0) {
      Some(output.split('\n'))
    } else {
      None
    }
  }

  def getUniqueProcessId(processName: String, node: String): Option[String] = {

    def doWork(reTryCount: Int = 50): Option[String] = {
      getProcessIds(processName, node) match {
        case Some(pid) =>
          if (pid.size == 1) {
            Some(pid.head)
          } else {
            System.err.println("non unique process name! pid are: " + pid.mkString(","))
            None
          }
        case None =>
          if (reTryCount > 0) {
            Thread.sleep(2000)
            doWork(reTryCount - 1)
          } else {
            System.err.println(s"process $processName can not found at remote server $node!")
            None
          }
      }
    }

    if (cachedProcessId.contains(processName)) {
      cachedProcessId(processName)
    } else {
      processName.synchronized {
        if (cachedProcessId.contains(processName)) {
          cachedProcessId(processName)
        } else {
          val result = doWork()
          cachedProcessId += processName -> result
          result
        }
      }
    }
  }
}
