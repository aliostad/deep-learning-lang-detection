import play.PlayRunHook
import sbt._

import java.net.InetSocketAddress

object Gulp {
  def apply(base: File): PlayRunHook = {

    object GulpProcess extends PlayRunHook {

      var process: Option[Process] = None

      override def beforeStarted(): Unit = {
        Process("gulp dist", base).run
      }

      override def afterStarted(addr: InetSocketAddress): Unit = {
        process = Some(Process("gulp watch", base).run)
      }

      override def afterStopped(): Unit = {
        process.map(p => p.destroy())
        process = None
      }
    }

    GulpProcess
  }
}