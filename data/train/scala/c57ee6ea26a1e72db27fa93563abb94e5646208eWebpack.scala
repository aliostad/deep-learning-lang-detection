import java.net.InetSocketAddress

import play.sbt.PlayRunHook
import sbt._

object Webpack {
  def apply(base: File): PlayRunHook = {

    object WebpackProcess extends PlayRunHook {

      var process: Option[Process] = None

      override def beforeStarted(): Unit = {
        Process("npm install").!
      }

      override def afterStarted(addr: InetSocketAddress): Unit = {
        process = Some(Process("./node_modules/.bin/webpack --progress -d --watch", base).run)
      }

      override def afterStopped(): Unit = {
        process.map(p => p.destroy())
        process = None
      }
    }

    WebpackProcess
  }
}