import java.net.InetSocketAddress

import play.sbt.PlayRunHook
import sbt._

object Gulp {
  def apply(base: File): PlayRunHook = {
    object GulpProcess extends PlayRunHook {

      var process: Option[Process] = None

      override def beforeStarted(): Unit = {
        Process("gulp dist", base).run()
      }

      override def afterStarted(addr: InetSocketAddress): Unit = {
        process = Some(Process("gulp watch", base).run())
      }

      override def afterStopped(): Unit = {
        process.foreach(_.destroy())
        process = None
      }
    }

    GulpProcess
  }
}
