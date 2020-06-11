import java.net.InetSocketAddress

import play.sbt.PlayRunHook
import sbt._


object ClientBuild {

  def apply(base: File): PlayRunHook = {

    object GulpProcess extends PlayRunHook {

      var process: Option[Process] = None

      override def beforeStarted(): Unit = {
        Process("npm install", base).run
      }

      override def afterStarted(addr: InetSocketAddress): Unit = {
        process = Some(Process("node_modules/.bin/webpack --watch", base).run)
      }

      override def afterStopped(): Unit = {
        process.foreach(p => p.destroy())
        process = None
      }
    }

    GulpProcess
  }
}
