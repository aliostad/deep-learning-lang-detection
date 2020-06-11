import play.PlayRunHook
import sbt._

import java.net.InetSocketAddress


object Grunt {
  def apply(base: File): PlayRunHook = {

    object GruntProcess extends PlayRunHook {

      var process: Option[Process] = None

      override def beforeStarted(): Unit = {
        Process("grunt", base).run
      }

      override def afterStarted(addr: InetSocketAddress): Unit = {
        process = Some(Process("grunt watch", base).run)
      }

      override def afterStopped() = {
        process.map(_.destroy)
        process = None
      }
    }

    GruntProcess
  }
}
