import java.io.File
import java.net.InetSocketAddress

import play.sbt.PlayRunHook

import scala.sys.process.Process

object Webpack {
  def apply(base: File): PlayRunHook = {
    object WebpackHook extends PlayRunHook {
      var process: Option[Process] = None

      override def beforeStarted() = {
        println("About to start 'npm install', this may take a while...")
        Process("npm install", base).!
        process = Option(
          Process("webpack", base).run()
        )
      }

      override def afterStarted(addr: InetSocketAddress) = {
        process = Option(
          Process("webpack --watch", base).run()
        )
      }

      override def afterStopped() = {
        process.foreach(_.destroy())
        process = None
      }
    }

    WebpackHook
  }
}
