import play.sbt.PlayRunHook
import sbt._
import java.net.InetSocketAddress

import scala.sys.process.Process

object GulpRunner {
  def apply(base: File): PlayRunHook = {

    object GruntProcess extends PlayRunHook {

      var watchProcess: Option[Process] = None

      override def beforeStarted(): Unit = {
        Process("gulp dist", base).run
      }

      override def afterStarted(addr: InetSocketAddress): Unit = {
        watchProcess = Some(Process("gulp run", base).run)
      }

      override def afterStopped(): Unit = {
        watchProcess.map(p => p.destroy())
        watchProcess = None
      }
    }

    GruntProcess
  }
}