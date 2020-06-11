import play.sbt.PlayRunHook
import sbt._
import java.net.InetSocketAddress

object Webpack {
  def apply(base: File): PlayRunHook = {
    object WebpackProcess extends PlayRunHook {

      var watchProcess: Option[Process] = None

      override def afterStarted(addr: InetSocketAddress): Unit = {
        watchProcess = Some(Process("webpack --watch --devtool=sourcemap", base).run)
      }

      override def afterStopped(): Unit = {
        watchProcess.map(p => p.destroy())
        watchProcess = None
      }
    }
    WebpackProcess
  }
}